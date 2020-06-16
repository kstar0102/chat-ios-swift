//
//  CorePushConfig.h
//  COREASP
//
//  Copyright (c) 2017 株式会社ブレスサービス. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 CORE PUSHのコンフィグクラス
 */

/// デバイストークン登録成功時の通知キー
extern NSString* CorePushManagerRegisterTokenRequestSuccessNotification;

/// デバイストークン登録失敗時の通知キー
extern NSString* CorePushManagerRegisterTokenRequestFailNotification;

/// デバイストークン削除成功時の通知キー
extern NSString* CorePushManagerUnregisterTokenRequestSuccessNotification;

/// デバイストークン削除失敗時の通知キー
extern NSString* CorePushManagerUnregisterTokenRequestFailNotification;

/// ユーザー属性の登録成功時の通知キー
extern NSString* CorePushManagerRegisterUserAttributesRequestSuccessNotification;

/// ユーザー属性の登録失敗時の通知キー
extern NSString* CorePushManagerRegisterUserAttributesRequestFailNotification;

/// デバイストークン登録・削除API
extern NSString* CorePushRegistTokenApi;

/// 通知履歴取得API
extern NSString* CorePushNotificationHistoryApi;

/// アクセス解析API
extern NSString* CorePushAnalyticsApi;

/// 設定キーを保持するための UserDefaults のキー
extern NSString* CorePushConfigKey;

/// デバイストークンの文字列を保持するための UserDefaults のキー
extern NSString* CorePushDeviceTokenKey;

/// デバイストークンの文字列をCORE ASPサーバに送信済みかを判定するためのUserDefaultsのキー
extern NSString* CorePushIsDeviceTokenSentToServerKey;

/// アプリ内のユーザーIDを保持するための UserDefaults のキー
extern NSString* CorePushAppUserIdKey;

/// 1次元カテゴリIDを保持するための UserDefaults のキー
extern NSString* CorePushCategoryIdsKey;

/// 2次元カテゴリIDを保持するための UserDefaults のキー
extern NSString* CorePushMultiCategoryIdsKey;
