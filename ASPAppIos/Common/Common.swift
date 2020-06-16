//
//  Common.swift
//  IOSChattingApp
//
//  Created by ADV on 2019/09/28.
//  Copyright © 2019 ADV. All rights reserved.
//

import UIKit

class Common {

    static var currentNavViewController: UINavigationController?
    static var deviceToken: String = ""
    static var me: UserModel?
    static var fromVC: String = "setting"
    

    static func setBorderColor(view: UIView) {
        view.layer.borderColor = Config.GRAY.cgColor
        view.layer.borderWidth = 0.5
        view.layer.cornerRadius = 3
        view.layer.masksToBounds = true
    }

    static func getCurrentViewController(sender : UIView) ->  UIViewController{
        //let sender = UIApplication.sharedApplication().keyWindow?.subviews.last;
        var vc = sender.next;
        while vc != nil && !(vc!.isKind(of: UIViewController.self)) {
            vc = vc!.next;
        }
        return vc as! UIViewController;
    }
    
    static func showErrorAlert(vc: UIViewController, title: String?, message: String) {
        let alert: UIAlertController = UIAlertController(title: title as String?,
                                                         message: message as String,
                                                         preferredStyle: .alert);
        let cancelAction: UIAlertAction = UIAlertAction(title: Config.YES,
                                                        style: .cancel,
                                                        handler: nil)
        alert.addAction(cancelAction)
        vc.present(alert, animated: true, completion: nil)
    }

}
