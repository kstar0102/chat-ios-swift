//
//  RegisterViewController.swift
//  ASPAppIos
//
//  Created by ADV on 2020/03/08.
//  Copyright © 2020 ADV. All rights reserved.
//

import UIKit
import COREASP
import Foundation
import Alamofire
import Firebase

class RegisterViewController: UIViewController
, UIPickerViewDelegate
, UIPickerViewDataSource
, UITableViewDelegate
, UITableViewDataSource {
    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet var contentCell: UITableViewCell!

    @IBOutlet weak var nicknameLe: ScaleTextField!
    @IBOutlet weak var genderSc: UISegmentedControl!
    @IBOutlet weak var emailLe: ScaleTextField!
    @IBOutlet weak var addressLe: ScaleTextField!
    @IBOutlet weak var applyLe1: ScaleTextField!
    @IBOutlet weak var applyLe2: ScaleTextField!
    @IBOutlet weak var applyViewHeight: NSLayoutConstraint!
    @IBOutlet weak var registerBtn: UIButton!
    
    private var placeData: [String] = [String]()
    private var applyData: [[String:String]] = [[String:String]]()
    private var selectedPlaceIndex: Int = 0
    private var selectedIDs  : [String] = []
    private var selectedNames  : [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableview.delegate = self
        self.tableview.dataSource = self
        self.tableview.alwaysBounceVertical = false
        
        Common.setBorderColor(view: nicknameLe)
        Common.setBorderColor(view: genderSc)
        Common.setBorderColor(view: emailLe)
        Common.setBorderColor(view: addressLe)
        Common.setBorderColor(view: applyLe1)
        Common.setBorderColor(view: applyLe2)
        
        let font = UIFont.systemFont(ofSize: 12)
        genderSc.setTitleTextAttributes([NSAttributedString.Key.font: font], for: .normal)
        
        applyLe2.isHidden = true
        registerBtn.layer.cornerRadius = 5

        placeData = [
            "北海道",
            "青森県",
            "岩手県",
            "宮城県",
            "秋田県",
            "山形県",
            "福島県",
            "茨城県",
            "栃木県",
            "群馬県",
            "埼玉県",
            "千葉県",
            "東京都",
            "神奈川県",
            "新潟県",
            "富山県",
            "石川県",
            "福井県",
            "山梨県",
            "長野県",
            "岐阜県",
            "静岡県",
            "愛知県",
            "三重県",
            "滋賀県",
            "京都府",
            "大阪府",
            "兵庫県",
            "奈良県",
            "和歌山県",
            "鳥取県",
            "島根県",
            "岡山県",
            "広島県",
            "山口県",
            "徳島県",
            "香川県",
            "愛媛県",
            "高知県",
            "福岡県",
            "佐賀県",
            "長崎県",
            "熊本県",
            "大分県",
            "宮崎県",
            "鹿児島県",
            "沖縄県",
            "海外",
            "回答しない"]

        applyData = [
            [
                "value":"b",
                "display":"ビジネス"
            ],
            [
                "value":"o",
                "display":"自己啓発"
            ],
            [
                "value":"s",
                "display":"スポーツ"
            ],
            [
                "value":"c",
                "display":"子育て"
            ],
            [
                "value":"e",
                "display":"教育"
            ],
            [
                "value":"k",
                "display":"その他"
            ]
        ]

        addDoneButtonOnKeyboard()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableview.reloadData()
        //*********************************************************************************************
        // デバイストークンの登録・削除時の通知をNotificationCenterに登録する。
        //*********************************************************************************************
//        NotificationCenter.default.addObserver(self, selector: #selector(RegisterViewController.registerTokenRequestSuccess), name: NSNotification.Name.CorePushManagerRegisterTokenRequestSuccess, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(RegisterViewController.registerTokenRequestFail), name: NSNotification.Name.CorePushManagerRegisterTokenRequestFail, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(RegisterViewController.unregisterTokenRequestSuccess), name: NSNotification.Name.CorePushManagerUnregisterTokenRequestSuccess, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(RegisterViewController.unregisterTokenRequestFail), name: NSNotification.Name.CorePushManagerUnregisterTokenRequestFail, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //*********************************************************************************************
        // デバイストークの登録・削除時の通知をNotificationCenterから解除する。
        //*********************************************************************************************
//        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.CorePushManagerRegisterTokenRequestSuccess, object: nil)
//        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.CorePushManagerRegisterTokenRequestFail, object: nil)
//        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.CorePushManagerUnregisterTokenRequestSuccess, object: nil)
//        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.CorePushManagerUnregisterTokenRequestFail, object: nil)

        NotificationCenter.default.removeObserver(self)
    }

    //-------------------------------------------------------------------------------------------------------------------------
           //                                              Number of sections
           //-------------------------------------------------------------------------------------------------------------------------
           func numberOfSections(in tableView: UITableView) -> Int {
               return 1
           }
          
        //-------------------------------------------------------------------------------------------------------------------------
           //                                              Number of rows in section
           //-------------------------------------------------------------------------------------------------------------------------
           func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
               return 1
           }
           //-------------------------------------------------------------------------------------------------------------------------
           //                                              Cell for row at index path
           //-------------------------------------------------------------------------------------------------------------------------
           func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
               let cell = contentCell
               return cell!
           }
        //-------------------------------------------------------------------------------------------------------------------------
           //                                              Height for row at indexPath
           //-------------------------------------------------------------------------------------------------------------------------
           func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 500
           }
           //-------------------------------------------------------------------------------------------------------------------------
           //                                              Did select row at indexPath
           //-------------------------------------------------------------------------------------------------------------------------
           func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           }
           
           func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
               return 0.0;
           }
       
       func addDoneButtonOnKeyboard(){
           let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
           doneToolbar.barStyle = .default

           let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
           let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))

           let items = [flexSpace, done]
           doneToolbar.items = items
           doneToolbar.sizeToFit()

           self.nicknameLe.inputAccessoryView = doneToolbar
           self.emailLe.inputAccessoryView = doneToolbar
           self.addressLe.inputAccessoryView = doneToolbar
           self.applyLe2.inputAccessoryView = doneToolbar
       }

       @objc func keyboardWillShow(notification:NSNotification){
           let userInfo = notification.userInfo!
           var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
           keyboardFrame = self.view.convert(keyboardFrame, from: nil)

           var contentInset:UIEdgeInsets = self.tableview.contentInset
           contentInset.bottom = keyboardFrame.size.height
           tableview.contentInset = contentInset
       }

       @objc func keyboardWillHide(notification:NSNotification){

           let contentInset:UIEdgeInsets = UIEdgeInsets.zero
           tableview.contentInset = contentInset
       }
       
       @objc func doneButtonAction(){
           self.nicknameLe.resignFirstResponder()
           self.emailLe.resignFirstResponder()
           self.addressLe.resignFirstResponder()
           self.applyLe2.resignFirstResponder()
       }
   
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
          return .lightContent
    }
    
    func checkEmptyFeild() -> Bool {
        
        if self.nicknameLe.text == "" {
            Common.showErrorAlert(vc: self, title: Config.INPUT_ERR_TITLE, message: "フルネーム"+Config.INPUT_ERR_MSG)
            return false
        }
        
        if self.emailLe.text == "" || !(self.emailLe.text?.contains("@"))! {
            Common.showErrorAlert(vc: self, title: Config.INPUT_ERR_TITLE, message: "メールアドレス"+Config.INPUT_ERR_MSG)
            return false
        }
        
        if self.addressLe.text == "" {
            Common.showErrorAlert(vc: self, title: Config.INPUT_ERR_TITLE, message: "居住地"+Config.INPUT_ERR_MSG)
            return false
        }
        
        if self.applyLe1.text == "" {
            Common.showErrorAlert(vc: self, title: Config.INPUT_ERR_TITLE, message: "活用法"+Config.INPUT_ERR_MSG)
            return false
        }else {
        }
        
        return true
    }

    
    @IBAction func addressBtnClicked(_ sender: Any) {
        let vc = UIViewController()
        vc.preferredContentSize = CGSize(width: Config.SCREEN_WIDTH,height: 150)
        let pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: Config.SCREEN_WIDTH, height: 150))
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.selectRow(selectedPlaceIndex, inComponent: 0, animated: false)
        vc.view.addSubview(pickerView)
        if self.addressLe.text == "" {
            self.addressLe.text = "北海道"
        }
        let editRadiusAlert = UIAlertController(title: "居住地を選択してください。", message: nil, preferredStyle: .actionSheet)
        editRadiusAlert.setValue(vc, forKey: "contentViewController")
        editRadiusAlert.addAction(UIAlertAction(title: "Done", style: .default, handler: {
            (action: UIAlertAction!) -> Void in
            editRadiusAlert.dismiss(animated: true, completion: nil)
        }))
        present(editRadiusAlert, animated: true, completion: nil)
    }
    
    @IBAction func applyBtnClicked(_ sender: Any) {
        MultiPickerDialog().show(title: "活用法を選択してください。",doneButtonTitle:"Done", cancelButtonTitle:Config.CANCEL ,options: applyData, selected:  self.selectedIDs) {
            values -> Void in
            //print("SELECTED \(value), \(showName)")
            print("callBack \(values)")
            var finalText = ""
            self.selectedIDs.removeAll()
            self.selectedNames.removeAll()
            for (index,value) in values.enumerated() {
                self.selectedIDs.append(value["value"]!)
                self.selectedNames.append(value["display"]!)
                finalText = finalText  + value["display"]! + (index < values.count - 1 ? ", ": "")
            }
            self.applyLe1.text = finalText
            if finalText.contains("その他") {
                self.applyLe2.isHidden = false
                self.applyViewHeight.constant = 90
            }else {
                self.applyLe2.isHidden = true
                self.applyViewHeight.constant = 45
            }
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return placeData.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return placeData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedPlaceIndex = row
        addressLe.text = placeData[row]
    }


    @IBAction func registerBtnClicked(_ sender: Any) {
        
        if self.checkEmptyFeild() {
            var genderTxt = "男性"
            if self.genderSc.selectedSegmentIndex == 1 {
                genderTxt = "女性"
            }
            if self.genderSc.selectedSegmentIndex == 2 {
                genderTxt = "回答しない"
            }
            var applyTxt = self.applyLe1.text
            if !self.applyLe2.isHidden {
                let applyTxt2 = self.applyLe2.text
                applyTxt = (self.applyLe1.text?.replacingOccurrences(of: "その他", with: applyTxt2 as! String))!
            }

            let multiCategoryIds = [
//                "1": [self.nicknameLe.text as Any],
//                "2": [self.emailLe.text as Any],
                "3": [genderTxt],
                "4": [self.addressLe.text as Any],
                "5": self.selectedNames
                ] as [String : Any]
            CorePushManager.shared.multiCategoryIds = (multiCategoryIds as! [String : [String]])
//            CorePushManager.shared.appUserId = "User001"
            CorePushManager.shared.registerForRemoteNotifications()
            
            let firebaseDb = Firestore.firestore()

            let collection = firebaseDb.collection("Users")
            let newDoc = collection.document()
            let userID = newDoc.documentID
            let date = Date()
            let format = DateFormatter()
            format.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let formattedDate = format.string(from: date)
            
            let newDic: NSMutableDictionary = NSMutableDictionary()
            newDic.setValue(userID, forKey: "user_id")
            newDic.setValue(Common.deviceToken, forKey: "token")
            newDic.setValue(formattedDate, forKey: "created_at")

            collection.document(userID).setData(newDic as! [String : Any]) { err in
            }

            let user = UserModel()
            user.userName = self.nicknameLe.text!
            user.gender = genderTxt
            user.email = emailLe.text!
            user.address = addressLe.text!
            user.apply = applyLe1.text!
            
            LocalstorageManager.setLoginInfo(info: user)
            
            Common.me = user
            
            let delegateObj = AppDelegate.instance();
            dismiss(animated: false, completion: nil)
            let vc: UIViewController = storyboard!.instantiateViewController(withIdentifier: "agreeView") as UIViewController
            vc.modalPresentationStyle = .fullScreen
            delegateObj.window?.rootViewController!.present(vc, animated: true, completion: nil)
        }
    }
}

// MARK: -  デバイストークンの登録・削除時の通知のセレクターの定義

extension RegisterViewController {
    
    // デバイストークン登録成功時に呼び出される。
    @objc func registerTokenRequestSuccess() {
        UIAlertView(title: "成功", message: "デバイストークンの登録に成功",
                    delegate: nil,
                    cancelButtonTitle:
            nil,
                    otherButtonTitles: "OK").show()
    }
    
    
    // デバイストークン登録失敗に呼び出される。
    @objc func registerTokenRequestFail() {
        UIAlertView(title: "エラー", message: "デバイストークンの登録に失敗",
                    delegate: nil,
                    cancelButtonTitle:
            nil,
                    otherButtonTitles: "OK").show()
    }
    
    // デバイストークン削除成功時に呼び出される。
    @objc func unregisterTokenRequestSuccess() {
        UIAlertView(title: "成功", message: "デバイストークンの削除に成功",
                    delegate: nil,
                    cancelButtonTitle:
            nil,
                    otherButtonTitles: "OK").show()
    }
    
    // デバイストークン削除失敗時に呼び出される。
    @objc func unregisterTokenRequestFail() {
        UIAlertView(title: "エラー", message: "デバイストークンの削除に失敗",
                    delegate: nil,
                    cancelButtonTitle: nil,
                    otherButtonTitles: "OK").show()
    }
}

