//
//  UpDataViewController.h
//  AppStore
//
//  Created by 王宝 on 15/8/24.
//  Copyright (c) 2015年 王宝. All rights reserved.
//

#import "BaseViewController.h"
#import "UpDataTableViewCell.h"

@interface UpDataViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,UpDataCellDelegate>

@property (strong, nonatomic) IBOutlet UITableView    *tableView;

@property (strong, nonatomic) NSArray        *data;//网络请求下数据

@property (strong, nonatomic) NSArray        *plistData;//持久化数据

@property (strong, nonatomic) NSMutableArray *displayData;//处理后数据

@end
