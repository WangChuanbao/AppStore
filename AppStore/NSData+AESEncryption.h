//
//  NSData+AESEncryption.h
//  AppStore
//
//  Created by 王宝 on 15/8/17.
//  Copyright (c) 2015年 王宝. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (AESEncryption)

- (NSData *)AES256ParmEncryptWithKey:(NSString *)key;   /**加密*/
- (NSData *)AES256ParmDecryptWithKey:(NSString *)key;   /**解密*/
- (NSString *)newStringInBase64FromData;            //追加64编码
+ (NSString*)base64encode:(NSString*)str;           //同上64编码

-(NSString *)AES128Encrypt:(NSString *)key;

@end
