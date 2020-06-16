//
//  CorePushNotificationHistoryManager.h
//  COREASP
//
//  Copyright (c) 2017 株式会社ブレスサービス. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CorePushNotificationHistoryModel.h"

@protocol CorePushNotificationHistoryManagerDelegate;

/**
 * 通知履歴のマネージャークラス
 */
@interface CorePushNotificationHistoryManager : NSObject

/// 通知履歴を格納した CorePushNotificationHistoryModelオブジェクトの配列
@property (nonatomic, strong, nonnull) NSArray<CorePushNotificationHistoryModel*> *notificationHistoryModelArray;

/// CorePushNotificationHistoryManagerのシングルトンオブジェクト
@property (class, nonatomic, nonnull, readonly) CorePushNotificationHistoryManager* shared;

/// CorePushNotificationHistoryManagerDelegateプロトコルを実装したクラス
@property (nonatomic, assign, nullable) id<CorePushNotificationHistoryManagerDelegate> delegate;

/**
 通知履歴を取得します。日付の新しい順に最大100件取得されます。<br/><br/>
 取得に成功した場合は CorePushNotificationHistoryManagerDelegate#notificationHistoryManagerSuccess が呼ばれます。<br/>
 取得に失敗した場合は CorePushNotificationHistoryManagerDelegate#notificationHistoryManagerFail が呼ばれます。
 */
- (void)requestNotificationHistory;

/**
 指定の履歴IDのメッセージを既読に設定します。
 
 @param historyId 履歴ID
 */
- (void)setRead:(nonnull NSString *)historyId;

/**
 指定の履歴IDのメッセージが未読であるかを判定します。
 
 @param historyId 履歴ID
 */
- (BOOL)isUnread:(nonnull NSString *)historyId;

/**
 通知履歴の未読数を返します。
 */
- (int)getUnreadNumber;

@end

/**
 CorePushNotificationHistoryManagerDelegateのデリゲートプロトコル
 */
@protocol CorePushNotificationHistoryManagerDelegate <NSObject>
@required

/**
 通知履歴の取得成功時に呼び出されます。
 */
- (void)notificationHistoryManagerSuccess;

/**
 通知履歴の取得失敗時に呼び出されます。
 */
- (void)notificationHistoryManagerFail;

@end
