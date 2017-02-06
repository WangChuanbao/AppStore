//
//  MD5.h
//  WoJianDing
//
//  Created by Apple on 14/12/16.
//  Copyright (c) 2014年 zenk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MD5 : NSObject

/**MD5*/
+(NSString *) md5: (NSString *) inPutText ;

/**Sha1*/
+ (NSString *)getSha1String:(NSString *)srcString;

+ (NSString *)hmacSha1:(NSString*)key text:(NSString*)text;

@end
