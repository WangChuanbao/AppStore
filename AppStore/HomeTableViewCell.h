//
//  HomeTableViewCell.h
//  AppStore
//
//  Created by 王宝 on 15/8/10.
//  Copyright (c) 2015年 王宝. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeTableViewCell : UITableViewCell
{
    CALayer *toplayer;
    UIView *bgview;
    BOOL isInstall;     //应用是否安装
}

@property (nonatomic ,strong) NSDictionary *data;

@property (strong, nonatomic) IBOutlet UIImageView  *icon;
@property (strong, nonatomic) IBOutlet UILabel      *title;
@property (strong, nonatomic) IBOutlet UILabel      *info;
@property (strong, nonatomic) IBOutlet UILabel      *type;
@property (strong, nonatomic) IBOutlet UIButton     *install;
@end
