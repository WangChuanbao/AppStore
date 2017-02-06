//
//  BaseViewController.h
//  AppStore
//
//  Created by 王宝 on 15/8/10.
//  Copyright (c) 2015年 王宝. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface BaseViewController : UIViewController

@property (nonatomic ,retain) MBProgressHUD *hud;

@property BOOL isBackButton;

- (void)showHUD:(NSString *)title;

- (void)hiddenHUD;

@end
