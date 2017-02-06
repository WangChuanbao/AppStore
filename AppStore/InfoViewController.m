//
//  InfoViewController.m
//  AppStore
//
//  Created by 王宝 on 15/8/11.
//  Copyright (c) 2015年 王宝. All rights reserved.
//

#import "InfoViewController.h"
#import "HomeTableViewCell.h"
#import "ZLabel.h"
#import "DataServer.h"

@interface InfoViewController ()

@end

@implementation InfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"应用详情";
    
    [self _loadData];
}

- (void)_loadData {
    [super showHUD:@"加载中"];
    
    NSString *url = @"store/app/";
    NSDictionary *params = [NSDictionary dictionaryWithObject:self.appId forKey:@"id"];
    [DataServer requestWithURL:url params:params httpMethod:@"POST" finishBlock:^(id result) {
        
        @try {
            _data = [NSMutableDictionary dictionaryWithDictionary:[result objectForKey:@"data"]];
            [_data setObject:_urlTypes forKey:@"ios_uri"];
            [_tableView reloadData];
            _tableView.tableFooterView = [self tableViewForFootView];
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            [super hiddenHUD];
        }
        
    } erro:^(id erro) {
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_data) {
        return 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HomeTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"HomeTableViewCell" owner:self options:nil] lastObject];
    
    cell.data = _data;
    
    return cell;
}

- (UIView *)tableViewForFootView {
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectZero];
    bgView.backgroundColor = [UIColor blueColor];
    
    ZLabel *label = [[ZLabel alloc] initWithFrame:CGRectMake(15, 0, self.view.width-30, 0) font:[UIFont systemFontOfSize:13]];
    
    NSString *text = [_data objectForKey:@"info"];
    
    label.text = text;
    
    [bgView addSubview:label];
    
    return bgView;
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
