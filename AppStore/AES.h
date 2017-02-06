//
//  AES.h
//  AppStore
//
//  Created by 王宝 on 15/8/17.
//  Copyright (c) 2015年 王宝. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AES : NSObject
+(NSData *)AES128Encrypt:(NSString *)plainText withKey:(NSString *)key;
+(NSString *)AES128Decrypt:(NSData *)data withKey:(NSString *)key;
@end
