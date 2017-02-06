//
//  SearchViewController.h
//  AppStore
//
//  Created by 王宝 on 15/8/11.
//  Copyright (c) 2015年 王宝. All rights reserved.
//

#import "BaseViewController.h"

@interface SearchViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>

@property (strong, nonatomic) NSArray *data;

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@end
