//
//  SpashViewController.swift
//  ASPAppIos
//
//  Created by ADV on 2020/03/07.
//  Copyright © 2020 ADV. All rights reserved.
//

import UIKit

class SpashViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let user = LocalstorageManager.getLoginInfo()
        Common.me = user

        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { // Change `2.0` to the desired number of seconds.
            self.gotoNextScreen()
        }
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
          return .lightContent
    }

    func gotoNextScreen() {

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let delegateObj = AppDelegate.instance();
        if Common.me == nil {
            DispatchQueue.main.async {
                        let vc: UIViewController = storyboard.instantiateViewController(withIdentifier: "mainView") as UIViewController
                        vc.modalPresentationStyle = .fullScreen
                        delegateObj.window?.rootViewController!.present(vc, animated: true, completion: {
                        })
            }
        }
        
    }

}
