//
//  HomeViewController.h
//  AppStore
//
//  Created by 王宝 on 15/8/10.
//  Copyright (c) 2015年 王宝. All rights reserved.
//

#import "BaseViewController.h"

@interface HomeViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic ,strong) NSArray     *data;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
