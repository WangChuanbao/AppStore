//
//  DataServer.h
//  AppStore
//
//  Created by 王宝 on 15/8/12.
//  Copyright (c) 2015年 王宝. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPRequestOperation.h"
#import "AFHTTPRequestOperationManager.h"

typedef void(^FinishLoadHandle)(id result);
typedef void(^erro)(id erro);
@interface DataServer : NSObject

+ (AFHTTPRequestOperation *)requestWithURL:(NSString *)url
                                    params:(NSDictionary *)params
                                httpMethod:(NSString *)httpMethod
                               finishBlock:(FinishLoadHandle)block
                                      erro:(erro)block1;

@end
