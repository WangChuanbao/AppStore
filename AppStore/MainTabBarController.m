//
//  MainTabBarController.m
//  AppStore
//
//  Created by 王宝 on 15/8/10.
//  Copyright (c) 2015年 王宝. All rights reserved.
//

#import "MainTabBarController.h"
#import "HomeViewController.h"
#import "SearchViewController.h"
#import "UpDataViewController.h"
#import "AboutViewController.h"
#import "BaseNavigationController.h"
#import "BaseViewController.h"
#import "TabBarItem.h"
#import "UIViewExt.h"

@interface MainTabBarController ()
{
    TabBarItem *_bar;
    UIImageView *_tabBarView;
}
@end

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initControllers];
    
    [self initTabBar];
}

- (void)initControllers {
    HomeViewController *homeVC = [[HomeViewController alloc] init];
    SearchViewController *searchVC = [[SearchViewController alloc] init];
    UpDataViewController *upDataVC = [[UpDataViewController alloc] init];
    AboutViewController *aboutVC = [[AboutViewController alloc] init];
    
    NSArray *viewVCs = @[homeVC,searchVC,upDataVC,aboutVC];
    NSMutableArray *navgations = [[NSMutableArray alloc] init];
    
    for (BaseViewController *viewVC in viewVCs) {
        BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:viewVC];
        nav.delegate = self;
        [navgations addObject:nav];
    }
    
    self.viewControllers = navgations;
}

- (void)initTabBar {
    self.tabBar.hidden = YES;
    //[self.tabBar setBarTintColor:[UIColor clearColor]];
    //[self.tabBar removeFromSuperview];
    
    _tabBarView = [[UIImageView alloc] initWithFrame:CGRectMake(0, kScreenHeight-49, kScreenWidth, 49)];
    _tabBarView.backgroundColor = RGBA(203, 203, 203, 1);
    _tabBarView.userInteractionEnabled = YES;
    [self.view addSubview:_tabBarView];
    
    CALayer *topBorder = [CALayer layer];
    topBorder.frame = CGRectMake(0, 0, kScreenWidth, 1);
    topBorder.backgroundColor = RGBA(184, 184, 184, 1).CGColor;
    [_tabBarView.layer addSublayer:topBorder];
    
    NSArray *imgAryNormal = @[@"首页01.png",@"搜索01.png",@"更新01.png",@"关于01.png"];
    NSArray *imgAry = @[@"首页02.png",@"搜索02.png",@"更新02.png",@"关于02.png"];
    NSArray *titleAry = @[@"首页",@"搜索",@"更新",@"关于"];
    
    //float range = kScreenWidth*22/320;
    float width = kScreenWidth/imgAry.count;
    
    for (int i=0; i<imgAry.count; i++) {
        
        NSString *imageName = [imgAryNormal objectAtIndex:i];
        NSString *imgName = [imgAry objectAtIndex:i];
        NSString *title = [titleAry objectAtIndex:i];
        
        TabBarItem *item = [[TabBarItem alloc] initWithFrame:CGRectMake(width*i, 0, width, 49) imageName:imageName selectImageName:imgName title:title];
        
        if (i==0) {
            item.selected = YES;
            _bar = item;
        }
        
        item.tag = i;
        [item addTarget:self action:@selector(tabBarItemSelected:) forControlEvents:UIControlEventTouchUpInside];
        [_tabBarView addSubview:item];
        
    }
}

- (void)tabBarItemSelected:(TabBarItem *)item {
    
    self.selectedIndex = item.tag;
    
    if (_bar) {
        
        _bar.selected = NO;
        
    }
    item.selected = YES;
    _bar = item;
    
}

- (void)showTabBar {
    [UIView animateWithDuration:.35 animations:^{
        _tabBarView.left = 0;
    }];
}

- (void)hiddenTabBar {
    [UIView animateWithDuration:.35 animations:^{
        _tabBarView.left = -kScreenWidth;
    }];
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    int count = (int)navigationController.viewControllers.count;
    
    if (count >= 2) {
        [self hiddenTabBar];
    }
    else {
        [self showTabBar];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.navigationController.navigationBarHidden == NO) {
        self.navigationController.navigationBarHidden = YES;
    }
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
