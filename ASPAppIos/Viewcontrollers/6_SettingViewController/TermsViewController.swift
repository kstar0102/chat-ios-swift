//
//  TermsViewController.swift
//  ASPAppIos
//
//  Created by ADV on 2020/04/02.
//  Copyright © 2020 ADV. All rights reserved.
//

import UIKit

class TermsViewController: UIViewController {

    @IBOutlet weak var checkBox: VKCheckbox!
    @IBOutlet weak var agreeBtn: UIButton!
    @IBOutlet weak var checkBottom: NSLayoutConstraint!
    @IBOutlet weak var menuView: UIView!
    
        
        private var checkedFlag: Bool = false
        
        override func viewDidLoad() {
            super.viewDidLoad()

            if Common.fromVC == "setting" {
                checkBox.checkboxValueChangedBlock = {
                    isOn in
                    self.checkedFlag = isOn
                    if self.checkedFlag {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { // Change `2.0` to the desired number of seconds.
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                }
                    self.menuView.isHidden = true
                }else {
                    self.checkBox.isHidden = true
                    self.agreeBtn.isHidden = true
                    checkBottom.constant = 0
                }
            
    }

        @IBAction func nextBtnClicked(_ sender: Any) {
            checkBox.setOn(!self.checkedFlag)
        }
        
        @IBAction func menuBtnClicked(_ sender: Any) {
            sideMenuController?.revealMenu()
        }

    }

    // MARK: - Actions
    extension TermsViewController
    {
        @IBAction func onReset(_ sender: AnyObject)
        {
            self.checkBox.setOn(false)
        }
        
    }


