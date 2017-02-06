//
//  DataServer.m
//  AppStore
//
//  Created by 王宝 on 15/8/12.
//  Copyright (c) 2015年 王宝. All rights reserved.
//

#import "DataServer.h"
#import "MD5.h"
#import "AES.h"

@implementation DataServer

+ (AFHTTPRequestOperation *)requestWithURL:(NSString *)url
                                    params:(NSDictionary *)params
                                httpMethod:(NSString *)httpMethod
                               finishBlock:(FinishLoadHandle)block
                                      erro:(erro)block1 {
    
    
    //token
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    
    if (params != nil) {
        params = [NSMutableDictionary dictionaryWithDictionary:params];
        [params setValue:token forKey:@"token"];
    }
    else {
        params = [NSMutableDictionary dictionaryWithObjectsAndKeys:token,@"token", nil];
    }
    
    NSString *jsonStr = [self jsonStringWithObject:params];
    
    NSData *aes = [AES AES128Encrypt:jsonStr withKey:AESKey];
    
    NSData *baseAes = [aes base64EncodedDataWithOptions:NSDataBase64Encoding76CharacterLineLength];
    
    NSString *content = [MD5 md5:[aes base64EncodedStringWithOptions:NSDataBase64Encoding76CharacterLineLength]];
    
    //设置参数
    NSArray *array = [url componentsSeparatedByString:@"/"];
    //请求地址
    NSString *action = [array objectAtIndex:array.count-2];
    //请求时间
    NSDate *date = [NSDate date];
    /*
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSTimeZone *zone = [[NSTimeZone alloc] initWithName:@"UTC"];
    [formatter setTimeZone:zone];
     */
    NSInteger interval = [date timeIntervalSince1970];
    
    //uuid
    NSString *uuid = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    //设备类型
    NSString *device = @"ios";
    //接口版本
    NSString *apiversion = @"1.0";
    //网络状态
    NSString *state = [self getNetWorkStates];
    //请求体内容
    //NSString *content = [[NSString alloc] initWithData:baseAes encoding:NSUTF8StringEncoding];
    NSString *contentmd5 = content;
    
    NSDictionary *headDict = [NSDictionary dictionaryWithObjectsAndKeys:@"x-zn-action",action,@"x-zn-date",[NSString stringWithFormat:@"%ld",interval],@"x-zn-apiversion",apiversion,@"x-zn-uuid",uuid,@"x-zn-device",device,@"x-zn-network",state,@"x-zn-contentmd5",content, nil];
    
    NSArray *keys = [headDict allKeys];
    NSArray *sortedArray = [keys sortedArrayUsingSelector:@selector(compare:)];

    NSString *sign = @"";
    for (int i=0; i<sortedArray.count; i++) {
        NSString *key = [sortedArray objectAtIndex:i];
        NSString *value = [headDict objectForKey:key];
        NSString *md5 = [MD5 md5:key];
        sign = [sign stringByAppendingString:[NSString stringWithFormat:@"%@:%@-",value,md5]];
    }
    
    NSString *accesskeyid = @"69b1db5f2c43e65c2b359bdfd7caed2d502cc43d";
    NSString *accesskeysecret = @"69b1db5f2c43e65c2b359bdfd7caed2d502cc43d";
    
    NSString *signature1 = [MD5 getSha1String:[[MD5 md5:sign] stringByAppendingString:accesskeyid]];
    
    NSString *hacStr = [MD5 hmacSha1:accesskeysecret text:signature1];
    
    NSData *hacdata = [hacStr dataUsingEncoding:NSUTF8StringEncoding];
    
    NSData *hacbase = [hacdata base64EncodedDataWithOptions:NSDataBase64Encoding76CharacterLineLength];
    
    NSString *signature = [[NSString alloc] initWithData:hacbase encoding:NSUTF8StringEncoding];
    
    //请求数据
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] init];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    
    //添加请求头

    [manager.requestSerializer setValue:signature forHTTPHeaderField:@"x-zn-signature"];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"%ld",interval] forHTTPHeaderField:@"x-zn-date"];
    [manager.requestSerializer setValue:apiversion forHTTPHeaderField:@"x-zn-apiversion"];
    [manager.requestSerializer setValue:action forHTTPHeaderField:@"x-zn-action"];
    [manager.requestSerializer setValue:uuid forHTTPHeaderField:@"x-zn-uuid"];
    [manager.requestSerializer setValue:device forHTTPHeaderField:@"x-zn-device"];
    [manager.requestSerializer setValue:state forHTTPHeaderField:@"x-zn-network"];
    [manager.requestSerializer setValue:contentmd5 forHTTPHeaderField:@"x-zn-contentmd5"];
    [manager.requestSerializer setValue:accesskeyid forHTTPHeaderField:@"x-zn-accesskeyid"];
    [manager.requestSerializer setValue:accesskeysecret forHTTPHeaderField:@"x-zn-accesskeysecret"];
    
    //拼接url
    url = [NSString stringWithFormat:@"%@%@",BaseURL,url];
    
    if ([httpMethod isEqualToString:@"GET"] || [httpMethod isEqualToString:@"get"]) {
        
        operation = [manager GET:url parameters:baseAes success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if (block) {
                block(responseObject);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if (block1) {
                block1(error);
            }
        }];
        
    }
    else if ([httpMethod isEqualToString:@"post"] || [httpMethod isEqualToString:@"POST"]) {
        NSLog(@"开始请求");
        operation = [manager POST:url parameters:baseAes success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if (block) {
                block(responseObject);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if (block1) {
                block1(error);
            }
        }];
    }
    return operation;
}

+ (NSString*)dictionaryToJson:(id)dic

{
    
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}

+(NSString *) jsonStringWithString:(NSString *) string{
    return [NSString stringWithFormat:@"\"%@\"",
            [[string stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"] stringByReplacingOccurrencesOfString:@"\""withString:@"\\\""]
            ];
}
+(NSString *) jsonStringWithArray:(NSArray *)array{
    NSMutableString *reString = [NSMutableString string];
    [reString appendString:@"["];
    NSMutableArray *values = [NSMutableArray array];
    for (id valueObj in array) {
        NSString *value = [self jsonStringWithObject:valueObj];
        if (value) {
            [values addObject:[NSString stringWithFormat:@"%@",value]];
        }
    }
    [reString appendFormat:@"%@",[values componentsJoinedByString:@","]];
    [reString appendString:@"]"];
    return reString;
}
+(NSString *) jsonStringWithDictionary:(NSDictionary *)dictionary{
    NSArray *keys = [dictionary allKeys];
    NSMutableString *reString = [NSMutableString string];
    [reString appendString:@"{"];
    NSMutableArray *keyValues = [NSMutableArray array];
    for (int i=0; i<[keys count]; i++) {
        NSString *name = [keys objectAtIndex:i];
        id valueObj = [dictionary objectForKey:name];
        NSString *value = [self jsonStringWithObject:valueObj];
        if (value) {
            [keyValues addObject:[NSString stringWithFormat:@"\"%@\":%@",name,value]];
        }
    }
    [reString appendFormat:@"%@",[keyValues componentsJoinedByString:@","]];
    [reString appendString:@"}"];
    return reString;
}
+(NSString *) jsonStringWithObject:(id) object{
    NSString *value = nil;
    if (!object) {
        return value;
    }
    if ([object isKindOfClass:[NSString class]]) {
        value = [self jsonStringWithString:object];
    }else if([object isKindOfClass:[NSDictionary class]]){
        value = [self jsonStringWithDictionary:object];
    }else if([object isKindOfClass:[NSArray class]]){
        value = [self jsonStringWithArray:object];
    }
    return value;
}

//获取网络状态，隐藏状态栏则无法获取
+(NSString *)getNetWorkStates{
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *children = [[[app valueForKeyPath:@"statusBar"]valueForKeyPath:@"foregroundView"]subviews];
    NSString *state = [[NSString alloc] init];
    
    int netType =0;
    //获取到网络返回码
    for (id child in children) {
        if ([child isKindOfClass:NSClassFromString(@"UIStatusBarDataNetworkItemView")]) {
            //获取到状态栏
            netType = [[child valueForKeyPath:@"dataNetworkType"]intValue];
            
            switch (netType) {
                case 0:
                    state = @"无网络";
                    //无网模式
                    break;
                case 1:
                    state = @"2g";
                    break;
                case 2:
                    state = @"3g";
                    break;
                case 3:
                    state = @"4g";
                    break;
                case 5:
                {
                    state = @"wifi";
                }
                    break;
                default:
                    break;
            }
        }
        
    }
    //根据状态选择
    return state;
}



@end
