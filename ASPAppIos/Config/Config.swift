//
//  Config.swift
//  IOSChattingApp
//
//  Created by ADV on 2019/09/28.
//  Copyright © 2019 ADV. All rights reserved.
//

import Foundation
import UIKit

func SCALE(value : CGFloat) -> CGFloat{
    return value * Config.SCREEN_WIDTH / 414
}
func BORDER_WIDTH() -> CGFloat{
    if(Config.SCREEN_WIDTH>375){
        return 0.33
    }else{
        return 0.5
    }
}

class Config {
    
    static let BASEURL = "https://hata-kimio.net/"
    static let DEVICE = "https://api.core-asp.com/iphone_token_regist.php"

    static let BOOKS = "#books"
    static let LECTURES = "apply"
    static let BOTTOMUP = "lecture"
    static let NOTIFY = "contact"
    static let PROFILE = "profile"
    static let SCHEDULE = "lecture#schedule"
    static let FACEBOOK_URL = "https://www.facebook.com/kimio.hata"

    static let TERMS = "https://docs.google.com/document/d/1wdqfSY3y4zrJGdLrcIP3JCbobLiG-agJRq2vie-8HtY/edit"
    //*********************************************************************************************
    // 通知のコンフィグキーの設定
    //*********************************************************************************************
    static let CONFIG_KEY = "a930fccedcd34bb27a5d7d777d2feff9"

    static let YES = "はい"
    static let NO = "いいえ"
    static let CANCEL = "キャンセル"
    static let INPUT_ERR_TITLE = "入力エラー"
    static let INPUT_ERR_MSG = "を正確に入力してください。"

    static let BASE = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
    static let BACK = UIColor(red: 137/255, green: 193/255, blue: 180/255, alpha: 1.0)
    static let GRAY = UIColor(red: 112/255, green: 111/255, blue: 111/255, alpha: 1.0)
    static let BLACK = UIColor(red: 29/255, green: 29/255, blue: 27/255, alpha: 1.0)
    static let BUBBLE = UIColor(red: 203/255, green: 187/255, blue: 159/255, alpha: 1.0)

    //UIConfig
    
    static let SCREEN_WIDTH  = CGFloat(UIScreen.main.bounds.size.width)
    static let SCREEN_HEIGHT = CGFloat(UIScreen.main.bounds.size.height)
    static let SCALE         = SCREEN_WIDTH / 414.0
    static let HEADER_HEIGHT = 70 * SCALE
    static let TABBAR_HEIGHT = 60 * SCALE
    static let NAV_BAR_OFFSET: Int = 50
    
}
