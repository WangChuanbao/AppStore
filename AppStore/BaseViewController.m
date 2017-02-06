//
//  BaseViewController.m
//  AppStore
//
//  Created by 王宝 on 15/8/10.
//  Copyright (c) 2015年 王宝. All rights reserved.
//

#import "BaseViewController.h"
#import "UIView+ViewController.h"
#import "UIImageView+WebCache.h"
#import "UIViewExt.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBar.translucent = NO;
    
    self.view.backgroundColor = RGBA(237, 237, 237, 1);
    
    if (self.navigationController.viewControllers.count > 1) {
        self.isBackButton = YES;
    }
    
    if (self.isBackButton) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, 13, 20);
        [button setImage:[UIImage imageNamed:@"返回按钮.png"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
        self.navigationItem.leftBarButtonItem = item;
        
    }
    else {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 75, 23)];
        imageView.image = [UIImage imageNamed:@"logo.png"];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:imageView];
        self.navigationItem.leftBarButtonItem = item;
    }
    
}

- (void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)showHUD:(NSString *)title {
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.labelText = title;
}

- (void)hiddenHUD {
    [self.hud setHidden:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    if ([self isViewLoaded] && self.view.window == nil) {
        
        self.view = nil;
        
    }
    
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
