//
//  CorePushAnalyticsManager.h
//  COREASP
//
//  Copyright (c) 2017 株式会社ブレスサービス. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CorePushAnalyticsManagerDelegate;

/**
 アクセス解析のマネージャークラス
 */
@interface CorePushAnalyticsManager : NSObject

/// CorePushAnalyticsManagerDelegateプロトコルを実装したクラス
@property (nonatomic, assign, nullable) id <CorePushAnalyticsManagerDelegate> delegate;

/// CorePushAnalyticsManagerクラスのシングルトンオブジェクト
@property (class, nonatomic, nonnull, readonly) CorePushAnalyticsManager* shared;

/**
   通知からのアプリ起動時のデータを送信します。<br/><br/>
   送信に成功した場合は CorePushAnalyticsManagerDelegate#analyticsManagerSuccess が呼ばれます。<br/>
   送信に失敗した場合は CorePushAnalyticsManagerDelegate#analyticsManagerFail が呼ばれます。
 
   @param pushId 通知ID
   @param latitude 緯度
   @param longitude 経度
 */
- (void)requestAppLaunchAnalytics:(nonnull NSString *)pushId latitude:(nullable NSString *)latitude longitude:(nullable NSString *)longitude;

/**
 通知からのアプリ起動時のデータを送信します。アクションキーを指定することで通知IDに紐づくアクションを分析することができます。actionKeyパラメータにnilを指定した場合は、起動数を表すアクションキーの001が設定されます。<br/><br/>
 送信に成功した場合は CorePushAnalyticsManagerDelegate#analyticsManagerSuccess が呼ばれます。<br/>
 送信に失敗した場合は CorePushAnalyticsManagerDelegate#analyticsManagerFail が呼ばれます。
 
 @param pushId 通知ID
 @param actionKey CORE ASP管理画面のアクション設定のアクションキー。nilが指定された場合は、起動数を表すアクションキーの001が設定されます。
 @param latitude 緯度
 @param longitude 経度
 */
- (void)requestAppLaunchAnalytics:(nonnull NSString *)pushId actionKey:(nullable NSString *)actionKey latitude:(nullable NSString *)latitude longitude:(nullable NSString *)longitude;

@end

/**
 CorePushAnalyticsManagerDelegateのデリゲートプロトコル
 */
@protocol CorePushAnalyticsManagerDelegate <NSObject>
@required

/**
 アクセス解析の送信成功時に呼び出されます。
 */
- (void)analyticsManagerSuccess;

/**
 アクセス解析の送信失敗時に呼び出されます。
 */
- (void)analyticsManagerFail;

@end
