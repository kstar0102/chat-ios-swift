//
//  CorePushManager.h
//  COREASP
//
//  Copyright (c) 2017 株式会社ブレスサービス. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 プッシュ通知受信時の通知表示に関する定数
 
 - CorePushRemoteNotificationTypeNone:  通知表示なし
 - CorePushRemoteNotificationTypeBadge: バッジあり
 - CorePushRemoteNotificationTypeSound: サウンドあり
 - CorePushRemoteNotificationTypeAlert: アラートあり
 */
typedef NS_OPTIONS(NSUInteger, CorePushRemoteNotificationType) {
    /// 通知表示なし
    CorePushRemoteNotificationTypeNone    = 0,
    /// バッジあり
    CorePushRemoteNotificationTypeBadge   = 1 << 0,
    /// サウンドあり
    CorePushRemoteNotificationTypeSound   = 1 << 1,
    /// アラートあり
    CorePushRemoteNotificationTypeAlert   = 1 << 2,
};

/**
 CorePushManagerクラスのデリゲートメソッドを定義したプロトコル
 */
@protocol CorePushManagerDelegate <NSObject>

@optional

/**
 アプリがバックグランドで動作中に通知からアプリを起動した時に CorePushManager#handleRemoteNotification から呼び出されます。

 @param userInfo 通知情報を含むオブジェクト
 */
- (void)handleBackgroundNotification:(nonnull NSDictionary*)userInfo;

/**
 アプリがフォアグランドで動作中に通知を受信した時に CorePushManager#handleRemoteNotification から呼び出されます。
 
 @param userInfo 通知情報を含むオブジェクト
 */
- (void)handleForegroundNotifcation:(nonnull NSDictionary*)userInfo;

/**
 アプリのプロセスが起動していない状態で通知からアプリを起動した時にCorePushManager#handleLaunchingNotificationWithOption から呼び出されます。
 
 @param userInfo 通知情報を含むオブジェクト
 */
- (void)handleLaunchingNotification:(nonnull NSDictionary*)userInfo;

@end

/**
 CORE PUSHのマネジャークラス
 */
@interface CorePushManager : NSObject <CorePushManagerDelegate>

/// CORE PUSHの設定キー
@property (nonatomic, strong, nullable) NSString* configKey;

/// カテゴリIDの配列
@property (nonatomic, strong, nullable) NSArray<NSString*>* categoryIds;

/// ２次元カテゴリの辞書オブジェクト
@property (nonatomic, strong, nullable) NSDictionary<NSString*, NSArray<NSString*>*>* multiCategoryIds;

/// アプリのユーザーID
@property (nonatomic, strong, nullable) NSString* appUserId;

/// デバイストークン
@property (nonatomic, readonly, nullable) NSString* deviceToken;

/// デバイストークンがCORE ASPサーバに送信済みかを判定するフラグ
@property (nonatomic, readonly) BOOL isDeviceTokenSentToServer;

/// CorePushManagerクラスのシングルトンオブジェクト
@property (class, nonatomic, nonnull, readonly) CorePushManager* shared;

/// CorePushManagerDelegateプロトコルを実装したクラス
@property (nonatomic, assign, nullable) id<CorePushManagerDelegate> delegate;

/**
 アプリケーションアイコンのバッジ数をリセットします。
 */
+ (void)resetApplicationIconBadgeNumber;

/**
 アプリケーションアイコンのバッジ数を設定します。
 
 @param number バッジ数
 */
+ (void)setApplicationIconBadgeNumber:(NSInteger)number;

/**
 CORE PUSHの設定キーを設定します。
 
 @param configKey CORE PUSHの設定キーの値。指定した設定キーは UserDefaultsに CorePushConfigKey のキーで保存されます。
 */
- (void)setConfigKey:(nullable NSString *)configKey;

/**
 CORE PUSHのカテゴリIDを設定します。
 
 @param categoryIds カテゴリIDの配列
 */
- (void)setCategoryIds:(nullable NSArray<NSString*> *)categoryIds;

/**
 CORE PUSHのカテゴリIDを設定します。
 
 @param multiCategoryIds カテゴリIDのディクショナリ。カテゴリIDをキーにサブカテゴリIDの配列を指定。
 */
- (void)setMultiCategoryIds:(nullable NSDictionary<NSString*, NSArray<NSString*>*> *)multiCategoryIds;

/**
 CORE PUSHのユーザーIDを設定します。
 
 @param appUserId アプリのユーザーID。
 */
- (void)setAppUserId:(nullable NSString*)appUserId;

/**
 APNSの通知サービスにデバイスを登録します。<br/><br/>
 デフォルトでは通知のアラート、バッジ、サウンドをONに設定します。
 */
- (void)registerForRemoteNotifications;

/**
 APNSの通知サービスにデバイスを登録します。
 
 @param types 通知タイプ
 */
- (void)registerForRemoteNotificationTypes:(CorePushRemoteNotificationType)types;

/**
 CORE ASPサーバにデバイストークンを登録します。<br/><br/>
 
 変換したデバイストークンの文字列は UserDefaultsに CorePushDeviceTokenKeyキーで保存されます。<br/>
 デバイストークンの登録が成功した場合は CorePushManagerRegisterTokenRequestSuccessNotification の通知キーで NSNotificationCenter に通知を行います。<br/>
 デバイストークンの登録が失敗した場合は CorePushManagerRegisterTokenRequestFailNotification の通知キーで NSNotificationCenterに通知を行います。
 
 @param token APNSサーバから取得したデバイストークンのバイト列。
 */
- (void)registerDeviceToken:(nonnull NSData *)token;

/**
 CORE ASPサーバにデバイストークンを登録します。<br/><br/>
 変換したデバイストークンの文字列は UserDefaultsに CorePushDeviceTokenKeyキー で保存されます。<br/>
 デバイストークンの登録が成功した場合は CorePushManagerRegisterTokenRequestSuccessNotification の通知キーで NSNotificationCenter に通知を行います。<br/>
 デバイストークンの登録が失敗した場合は CorePushManagerRegisterTokenRequestFailNotification の通知キーで NSNotificationCenterに通知を行います。
 
 @param token APNSサーバから取得したデバイストークンの文字列。
 */
- (void)registerDeviceTokenString:(nonnull NSString *)token;

/**
 CORE PUSHからデバイストークンを削除します。<br/><br/>
 デバイストークン削除時に UserDefaultsのCorePushDeviceTokenKeyキーに保存されたデバイストークンを空文字で保存します。<br/>
 デバイストークンの削除が成功した場合は CorePushManagerUnregisterTokenRequestSuccessNotification の通知キーで NSNotificationCenter に通知を行います。<br/>
 デバイストークンの削除が失敗した場合は CorePushManagerUnregisterTokenRequestFailNotification の通知キーで NSNotificationCenter に通知を行います。
 */
- (void)unregisterDeviceToken;

/**
 指定のURLにユーザー属性を送信します。
 
 @param attributes ユーザー属性の配列
 @param url ユーザー属性を送信するurl
 */
- (void)registerUserAttributes:(nonnull NSArray<NSString*>*)attributes api:(nonnull NSString*)url;

/**
 アプリがフォアグランド・バックグランド状態で動作中に通知を受信した時の動作を定義します。<br/><br/>
 バックラウンド状態で通知を受信後に通知からアプリを起動した場合、CorePushManagerDelegate#handleBackgroundNotificationが呼び出されます。<br/>
 フォアグランド状態で通知を受信した場合、CorePushManagerDelegate#handleForegroundNotificationが呼び出されます。
 
 @param userInfo 通知の情報を含むオブジェクト
 */
- (void)handleRemoteNotification:(nonnull NSDictionary*)userInfo;

/**
 アプリのプロセスが起動していない状態で通知からアプリを起動した時の処理を定義します。<br/><br/>
 launchOptionsに通知のUserInfoが存在する場合は、CorePushManagerDelegate#handleLaunchingNotificationを呼び出し、存在しない場合は何も行いません。
 
 @param launchOptions 起動オプション。UIApplicationLaunchOptionsRemoteNotificationKeyをキーにUserInfoオブジェクトを取得します。
 */
- (void)handleLaunchingNotificationWithOption:(nullable NSDictionary*)launchOptions;

@end
