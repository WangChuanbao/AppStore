//
//  InfoViewController.h
//  AppStore
//
//  Created by 王宝 on 15/8/11.
//  Copyright (c) 2015年 王宝. All rights reserved.
//

#import "BaseViewController.h"

@interface InfoViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>

@property (strong ,nonatomic) NSString *urlTypes;

@property (strong ,nonatomic) NSString *appId;

@property (strong ,nonatomic) NSMutableDictionary *data;

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@end
