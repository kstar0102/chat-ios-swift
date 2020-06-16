//
//  CoreAspManager.h
//  COREASP
//
//  Copyright (c) 2017 株式会社ブレスサービス. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 CORE ASPのマネジャークラス
 */
@interface CoreAspManager : NSObject

/// デバッグログの出力制御フラグ
@property (nonatomic, assign) BOOL debugEnabled;

/// CoreAspManagerクラスのシングルトンオブジェクト
@property (class, nonatomic, nonnull, readonly) CoreAspManager* shared;

/**
 SDKの情報を表示します。
 */
+ (void)printSDKInfo;

@end
