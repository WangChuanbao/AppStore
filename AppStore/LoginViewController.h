//
//  LoginViewController.h
//  AppStore
//
//  Created by 王宝 on 15/8/12.
//  Copyright (c) 2015年 王宝. All rights reserved.
//

#import "BaseViewController.h"

@interface LoginViewController : BaseViewController<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *userName;
@property (strong, nonatomic) IBOutlet UITextField *passWord;
@property (strong, nonatomic) IBOutlet UILabel *infoLabel;

@property (strong, nonatomic) IBOutlet UILabel *messageLabel;
@end
