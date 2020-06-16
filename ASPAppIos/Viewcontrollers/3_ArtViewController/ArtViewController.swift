//
//  ScheduleViewController.swift
//  ASPAppIos
//
//  Created by ADV on 2020/03/07.
//  Copyright © 2020 ADV. All rights reserved.
//

import UIKit
import WebKit
import SVProgressHUD

class ArtViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
    }
    @IBAction func menuBtnClicked(_ sender: Any) {
        sideMenuController?.revealMenu()
    }

}

