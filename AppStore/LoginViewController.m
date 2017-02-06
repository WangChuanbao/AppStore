//
//  LoginViewController.m
//  AppStore
//
//  Created by 王宝 on 15/8/12.
//  Copyright (c) 2015年 王宝. All rights reserved.
//

#import "LoginViewController.h"
#import "MainTabBarController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"登录";
    
    _userName.layer.masksToBounds = YES;
    _userName.layer.borderWidth = 1;
    _userName.layer.borderColor = RGBA(154, 154, 154, 1).CGColor;
    
    _passWord.layer.masksToBounds = YES;
    _passWord.layer.borderWidth = 1;
    _passWord.layer.borderColor = RGBA(154, 154, 154, 1).CGColor;
    
    UIView *userLeftView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, 40, 30)];
    UIImageView *user = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"账户.png"]];
    [user setFrame:CGRectMake(10, 0, 30, 30)];
    user.contentMode = UIViewContentModeScaleAspectFit;
    [userLeftView addSubview:user];
    
    _userName.leftView = userLeftView;
    _userName.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *userRightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
    _userName.rightView = userRightView;
    _userName.rightViewMode = UITextFieldViewModeAlways;
    
    UIView *passLeftView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, 40, 30)];
    UIImageView *passView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"密码.png"]];
    [passView setFrame:CGRectMake(10, 0, 30, 30)];
    passView.contentMode = UIViewContentModeScaleAspectFit;
    [passLeftView addSubview:passView];
    
    _passWord.leftView = passLeftView;
    _passWord.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *passRightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
    _passWord.rightView = passRightView;
    _passWord.rightViewMode = UITextFieldViewModeAlways;
    
    _infoLabel.font = [UIFont boldSystemFontOfSize:12];
    _infoLabel.text = @"版本1.0\n北京鸿天融达信息技术有限公司\nCopyright©2015";
    
}

- (IBAction)login:(UIButton *)sender {
    [_userName resignFirstResponder];
    [_passWord resignFirstResponder];
    
    if ([_userName.text isEqualToString:@""]) {
        _messageLabel.text = @"请填写账户";
        return;
    }
    if ([_passWord.text isEqualToString:@""]) {
        _messageLabel.text = @"请填写密码";
        return;
    }
    
    [super showHUD:@"努力登陆中"];
    
    NSString *url = @"public/login/";
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:_userName.text,@"username",_passWord.text,@"password", nil];
    
    [DataServer requestWithURL:url params:params httpMethod:@"POST" finishBlock:^(id result) {
        
        @try {
            NSString *state = [result objectForKey:@"state"];
            if ([state isEqualToString:@"0"] || state.integerValue == 0) {
                
                NSDictionary *data = [result objectForKey:@"data"];
                NSString *token = [data objectForKey:@"token"];
                
                [[NSUserDefaults standardUserDefaults] setObject:params forKey:@"login"];
                [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"token"];
                
                MainTabBarController *mainVC = [[MainTabBarController alloc] init];
                [self.navigationController pushViewController:mainVC animated:YES];
                
            }
            else {
                _messageLabel.text = @"用户名密码错误";
            }
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            [super hiddenHUD];
        }
        
    } erro:^(id erro) {
        
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [textField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
