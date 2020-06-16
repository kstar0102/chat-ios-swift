//
//  PurchaseManager.swift
//  Manga
//
//  Created by juc com on 3/1/17.
//  Copyright © 2017 juc com. All rights reserved.
//

import Foundation
import StoreKit
import SVProgressHUD

private let purchaseManagerSharedManager = PurchaseManager()

extension SKProduct {
    var localizedPrice: Double {
        let numberFormatter = NumberFormatter()
        numberFormatter.formatterBehavior = .behavior10_4
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = self.priceLocale
        return Double(numberFormatter.string(from: self.price) ?? "") ?? 0.0
    }
}

class PurchaseManager : NSObject,SKPaymentTransactionObserver {
    
    var delegate : PurchaseManagerDelegate?
    
    private var productIdentifier : String?
    private var isRestore : Bool = false
    private var purchasingProduct: SKProduct?
    private var loadingTimeout: Timer?
    
    /// シングルトン
    class func sharedManager() -> PurchaseManager{
        return purchaseManagerSharedManager;
    }
    
    /// 課金開始
    func startWithProduct(product : SKProduct, item_num: NSInteger){
        var errorCount = 0
        var errorMessage = ""
        
        if SKPaymentQueue.canMakePayments() == false {
            errorCount += 1
            errorMessage = "設定で購入が無効になっています。"
        }
        
        if self.productIdentifier != nil {
            errorCount += 10
            errorMessage = "課金処理中です。"
        }
        
        if self.isRestore == true {
            errorCount += 100
            errorMessage = "リストア中です。"
        }
        
        //エラーがあれば終了
        if errorCount > 0 {
            let error = NSError(domain: "PurchaseErrorDomain", code: errorCount, userInfo: [NSLocalizedDescriptionKey:errorMessage + "(\(errorCount))"])
            self.delegate?.purchaseManager?(purchaseManager: self, didFailWithError: error)
            return
        }
        
        //未処理のトランザクションがあればそれを利用
        let transactions = SKPaymentQueue.default().transactions
        if transactions.count > 0 {
            for transaction in transactions {
                if transaction.transactionState != .purchased {
                    continue
                }
                if transaction.payment.productIdentifier == product.productIdentifier {
                    SKPaymentQueue.default().finishTransaction(transaction)
                }
            }
        }
    
        //課金処理開始
        let payment = SKMutablePayment(product: product)
        payment.quantity = item_num
        SKPaymentQueue.default().add(payment)
        self.productIdentifier = product.productIdentifier
        self.purchasingProduct = product
        
        print("☺️ start buying")
        SVProgressHUD.show()
        
        loadingTimeout = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(timeoutLoading(timer:)), userInfo: nil, repeats: false)
    }
    
    @objc func timeoutLoading(timer : Timer) {
        SVProgressHUD.dismiss()
    }
    
    /// リストア開始
    func startRestore(){
        if self.isRestore == false {
            self.isRestore = true
            SKPaymentQueue.default().restoreCompletedTransactions()
        }else{
            let error = NSError(domain: "PurchaseErrorDomain", code: 0, userInfo: [NSLocalizedDescriptionKey:"リストア処理中です。"])
            self.delegate?.purchaseManager?(purchaseManager: self, didFailWithError: error)
        }
    }
    
    // MARK: - SKPaymentTransactionObserver
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        //課金状態が更新されるたびに呼ばれる
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchasing :
                //課金中
                break
            case .purchased :
                SVProgressHUD.dismiss()
                loadingTimeout?.invalidate()
                //課金完了
                self.completeTransaction(transaction: transaction)
                break
            case .failed :
                SVProgressHUD.dismiss()
                loadingTimeout?.invalidate()
                //課金失敗
                self.failedTransaction(transaction: transaction)
                break
            case .restored :
                //リストア
                self.restoreTransaction(transaction: transaction)
                break
            case .deferred :
                //承認待ち
                self.deferredTransaction(transaction: transaction)
                break
            @unknown default:
                SVProgressHUD.dismiss()
                loadingTimeout?.invalidate()
                //課金失敗
                self.failedTransaction(transaction: transaction)
            }
        }
    }
    
    func paymentQueue(queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: NSError) {
        //リストア失敗時に呼ばれる
        self.delegate?.purchaseManager?(purchaseManager: self, didFailWithError: error)
        self.isRestore = false
    }
    
    func paymentQueueRestoreCompletedTransactionsFinished(queue: SKPaymentQueue) {
        //リストア完了時に呼ばれる
        self.delegate?.purchaseManagerDidFinishRestore?(purchaseManager: self)
        self.isRestore = false
    }
    
    // MARK: - SKPaymentTransaction process
    private func completeTransaction(transaction : SKPaymentTransaction) {
        if transaction.payment.productIdentifier == self.productIdentifier {
            //課金終了
            self.delegate?.purchaseManager?(purchaseManager: self, didFinishPurchaseWithTransaction: transaction, decisionHandler: { (complete) in
                if complete == true {
                    //トランザクション終了
                    SKPaymentQueue.default().finishTransaction(transaction)
                }
            })
            self.productIdentifier = nil
        }else{
            //課金終了(以前中断された課金処理)
            self.delegate?.purchaseManager?(purchaseManager: self, didFinishUntreatedPurchaseWithTransaction: transaction, decisionHandler: { (complete) in
                if complete == true {
                    //トランザクション終了
                    SKPaymentQueue.default().finishTransaction(transaction)
                }
            })
        }
        
        // set revenue event
        if let receiptUrl = Bundle.main.appStoreReceiptURL {
            if let receiptData = NSData(contentsOf: receiptUrl) {
                guard let product = purchasingProduct, let transactionId = transaction.transactionIdentifier else {
                    return
                }
                
                let quantity: Double = Double(transaction.payment.quantity) * product.localizedPrice
//                let purchasedEvent = PurchasedEvent(receiptData: receiptData,
//                                                    transactionId: transactionId,
//                                                    amount: quantity,
//                                                    currency: "JPY")
//
//                AdjustManager.shared.setPurchasedEvent(purchasedEvent)
                purchasingProduct = nil
            }
        }
    }
    
    private func failedTransaction(transaction : SKPaymentTransaction) {
        NSLog("\(transaction.error.debugDescription)")
        //課金失敗
        self.delegate?.purchaseManager?(purchaseManager: self, didFailWithError: transaction.error as NSError?)
        self.productIdentifier = nil
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    private func restoreTransaction(transaction : SKPaymentTransaction) {
        //リストア(originalTransactionをdidFinishPurchaseWithTransactionで通知)　※設計に応じて変更
        self.delegate?.purchaseManager?(purchaseManager: self, didFinishPurchaseWithTransaction: transaction, decisionHandler: { (complete) in
            if complete == true {
                //トランザクション終了
                SKPaymentQueue.default().finishTransaction(transaction)
            }
        })
    }
    
    private func deferredTransaction(transaction : SKPaymentTransaction) {
        //承認待ち
        self.delegate?.purchaseManagerDidDeferred?(purchaseManager: self)
        self.productIdentifier = nil
    }
}


@objc protocol PurchaseManagerDelegate {
    //課金完了
    @objc optional func purchaseManager(purchaseManager: PurchaseManager!, didFinishPurchaseWithTransaction transaction: SKPaymentTransaction!, decisionHandler: ((Bool) -> Void)!)
    //課金完了(中断していたもの)
    @objc optional func purchaseManager(purchaseManager: PurchaseManager!, didFinishUntreatedPurchaseWithTransaction transaction: SKPaymentTransaction!, decisionHandler: ((Bool) -> Void)!)
    //リストア完了
    @objc optional func purchaseManagerDidFinishRestore(purchaseManager: PurchaseManager!)
    //課金失敗
    @objc optional func purchaseManager(purchaseManager: PurchaseManager!, didFailWithError error: NSError!)
    //承認待ち(ファミリー共有)
    @objc optional func purchaseManagerDidDeferred(purchaseManager: PurchaseManager!)
}
