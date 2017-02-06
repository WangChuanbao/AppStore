//
//  HomeViewController.m
//  AppStore
//
//  Created by 王宝 on 15/8/10.
//  Copyright (c) 2015年 王宝. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeTableViewCell.h"
#import "InfoViewController.h"
#import "KeychainItemWrapper.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"应用商城";
    
    KeychainItemWrapper *wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:@"text" accessGroup:@"com.hongtiantech.group"];
    
    NSString *data = [wrapper objectForKey:(id)kSecValueData];
    
    _tableView.backgroundColor = RGBA(248, 248, 248, 1);
        
    [self _loadData];
    
}

- (void)_loadData {
    [super showHUD:@"加载中"];
    
    NSString *url = @"store/home/";
    
    [DataServer requestWithURL:url params:nil httpMethod:@"POST" finishBlock:^(id result) {
        
        @try {
            self.data = [result objectForKey:@"data"];
            if ([_data isKindOfClass:[NSArray class]]) {
                [_tableView reloadData];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identity = @"cell";
    HomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identity];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"HomeTableViewCell" owner:self options:nil] lastObject];
    }
    
    cell.data = [_data objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = [_data objectAtIndex:indexPath.row];
    NSString *urlTypes = [dic objectForKey:@"ios_uri"];
    NSString *appId = [dic objectForKey:@"id"];
    InfoViewController *infoVC = [[InfoViewController alloc] init];
    infoVC.appId = appId;
    infoVC.urlTypes = urlTypes;
    [self.navigationController pushViewController:infoVC animated:YES];
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
