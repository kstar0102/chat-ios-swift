//
//  LocalstorageManager.swift
//  IOSChattingApp
//
//  Created by ADV on 2019/10/02.
//  Copyright © 2019 ADV. All rights reserved.
//

import UIKit

class LocalstorageManager: NSObject {
    static func setLoginInfo(info:UserModel){
        let key = "user_info"
        do {
            let encorded = try NSKeyedArchiver.archivedData(withRootObject: info, requiringSecureCoding: false)
            UserDefaults.standard.set(encorded, forKey: key)
        } catch  {
        }
    }
    static func getLoginInfo() -> UserModel? {
        let key = "user_info"
        let val = UserDefaults.standard.data(forKey: key)
        if val != nil {
            do {
                let decoded = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(val!) as! UserModel
                return decoded
            } catch  {
                return nil
            }
        }else {
            return nil
        }
    }
    static func setAgreeInfo(code:String){
        let key = "agree_info"
        UserDefaults.standard.set(code, forKey: key)
    }
    static func getAgreeInfo() -> String {
        let key = "agree_info"
        if let val:String = UserDefaults.standard.string(forKey: key) as String? {
            return val;
        }else{
            return ""
        }
    }
}
