//
//  UserModel.swift
//  IOSChattingApp
//
//  Created by ADV on 2019/10/02.
//  Copyright © 2019 ADV. All rights reserved.
//

import UIKit

class UserModel: NSObject, NSCoding {
    
    var email        : String = ""
    var userName     : String = ""
    var gender       : String = ""
    var address      : String = ""
    var apply        : String = ""

    var json            : NSDictionary = NSDictionary()

    //---------------------------------------------------------------------------------------------------------
    //                                      Init
    //---------------------------------------------------------------------------------------------------------
    override init() {
        
    }
    //---------------------------------------------------------------------------------------------------------
    //                                      Init With JSON
    //---------------------------------------------------------------------------------------------------------
    convenience init(_ json: NSDictionary){
        self.init()
        self.initWithJSON(json: json)
    }
    
    func initWithJSON(json:NSDictionary){
        self.json = json
        if let val = json["email"]{
            email = (val as? String) ?? ""
        }
        if let val = json["user_name"]{
            userName = (val as? String) ?? ""
        }
        if let val = json["gender"]{
            gender = (val as? String) ?? ""
        }
        if let val = json["address"]{
            address = (val as? String) ?? ""
        }
        if let val = json["apply"]{
            apply = (val as? String) ?? ""
        }
    }
    //---------------------------------------------------------------------------------------------------------
    //                                      Encode With Coder
    //---------------------------------------------------------------------------------------------------------
    func encode(with aCoder: NSCoder) {
        let newDic = self.json.mutableCopy() as! NSMutableDictionary
        newDic.setValue(self.email, forKey: "email")
        newDic.setValue(self.userName, forKey: "user_name")
        newDic.setValue(self.gender, forKey: "gender")
        newDic.setValue(self.address, forKey: "address")
        newDic.setValue(self.apply, forKey: "apply")
        aCoder.encode(newDic, forKey: "json")
    }
    //---------------------------------------------------------------------------------------------------------
    //                                      Decode With Coder
    //---------------------------------------------------------------------------------------------------------
    required convenience init?(coder decoder:NSCoder) {
        self.init()
        let json = decoder.decodeObject(forKey: "json") as! NSDictionary
        self.initWithJSON(json: json)
    }
    
    func getDictionaryData() -> NSMutableDictionary  {
        let newDic = self.json.mutableCopy() as! NSMutableDictionary
        newDic.setValue(self.email, forKey: "email")
        newDic.setValue(self.userName, forKey: "user_name")
        newDic.setValue(self.gender, forKey: "gender")
        newDic.setValue(self.address, forKey: "address")
        newDic.setValue(self.apply, forKey: "apply")
        return newDic
    }
}
