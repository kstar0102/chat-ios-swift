//
//  CorePushNotificationHistoryModel.h
//  COREASP
//
//  Copyright (c) 2017 株式会社ブレスサービス. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 通知履歴のモデルクラス
 */
@interface CorePushNotificationHistoryModel : NSObject

/// 履歴ID
@property (nonatomic, strong, nullable) NSString* historyId;

/// 通知メッセージ
@property (nonatomic, strong, nullable) NSString* message;

/// 通知URL
@property (nonatomic, strong, nullable) NSString* url;

/// 通知日時
@property (nonatomic, strong, nullable) NSString* regDate;

@end
