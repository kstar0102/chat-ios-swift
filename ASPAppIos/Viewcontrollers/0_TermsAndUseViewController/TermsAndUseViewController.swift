//
//  TermsAndUseViewController.swift
//  ASPAppIos
//
//  Created by ADV on 2020/03/30.
//  Copyright © 2020 ADV. All rights reserved.
//

import UIKit

class TermsAndUseViewController: UIViewController {

    @IBOutlet weak var checkBox: VKCheckbox!
    
    @IBOutlet weak var nextBtn: UIButton!
    
    private var checkedFlag: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nextBtn.layer.cornerRadius = 5
        nextBtn.isHidden = true
        checkBox.checkboxValueChangedBlock = {
            isOn in
            self.checkedFlag = isOn
            self.nextBtn.isHidden = !isOn
        }
    }
    

    @IBAction func agreeBtnClicked(_ sender: Any) {
        checkedFlag = !checkedFlag
        checkBox.setOn(checkedFlag)
    }
    
    @IBAction func nextBtnClicked(_ sender: Any) {
        if checkedFlag {
            LocalstorageManager.setAgreeInfo(code: "Agreed")
            let delegateObj = AppDelegate.instance();
            dismiss(animated: false, completion: nil)
            let vc: UIViewController = storyboard!.instantiateViewController(withIdentifier: "mainView") as UIViewController
            vc.modalPresentationStyle = .fullScreen
            delegateObj.window?.rootViewController!.present(vc, animated: true, completion: nil)
        }
    }
    
    
}

// MARK: - Actions
extension TermsAndUseViewController
{
    @IBAction func onReset(_ sender: AnyObject)
    {
        self.checkBox.setOn(false)
    }
    
}
