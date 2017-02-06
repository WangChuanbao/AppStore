//
//  SearchViewController.m
//  AppStore
//
//  Created by 王宝 on 15/8/11.
//  Copyright (c) 2015年 王宝. All rights reserved.
//

#import "SearchViewController.h"
#import "HomeTableViewCell.h"
#import "DataServer.h"

@interface SearchViewController ()
{
    /**搜索框遮盖视图   */
    UIView *coverView;
    
    UISearchBar *_searchBar;
}
@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"搜索";
    // Do any additional setup after loading the view from its nib.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBordWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBordWillHidden:) name:UIKeyboardWillHideNotification object:nil];
    
    _tableView.tableHeaderView = [self tableViewForHeaderView];
    _tableView.backgroundColor = [UIColor clearColor];
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

- (UIView *)tableViewForHeaderView {
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 50)];
    contentView.backgroundColor = RGBA(248, 248, 248, .3);
    
    CALayer *bottom = [CALayer layer];
    bottom.backgroundColor = RGBA(184, 184, 184, 1).CGColor;
    bottom.frame = CGRectMake(0, 50-0.5, kScreenWidth, 0.5);
    [contentView.layer addSublayer:bottom];
    
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(5, 10, kScreenWidth-10, contentView.height-20)];
    _searchBar.delegate = self;
    _searchBar.keyboardType = UIKeyboardTypeDefault;
    _searchBar.placeholder = @"搜索";
    _searchBar.searchBarStyle = UISearchBarStyleMinimal;
    
    [contentView addSubview:_searchBar];
    [self.view addSubview:contentView];
    return contentView;
}

#pragma mark UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    [searchBar resignFirstResponder];
    
    [super showHUD:@"加载中"];
    
    NSString *keyWord = searchBar.text;
    
    NSString *url = @"store/search/";
    NSDictionary *params = [NSDictionary dictionaryWithObject:keyWord forKey:@"keyword"];
    [DataServer requestWithURL:url params:params httpMethod:@"POST" finishBlock:^(id result) {
        
        @try {
            _data = [result objectForKey:@"data"];
  
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

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    
    return YES;
}

- (void)keyBordWillShow:(NSNotification *)notifi {
    NSDictionary *info = notifi.userInfo;
    NSNumber *value = [info objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    float time = [value floatValue];
    
    [self initCoverView];
    
    [UIView animateWithDuration:time animations:^{
        coverView.alpha = 0.3;
    }];
}

- (void)initCoverView {
    if (coverView == nil) {
        coverView = [[UIView alloc] initWithFrame:CGRectMake(0, 50, self.view.width, self.view.height-50)];
        coverView.alpha = 0;
        coverView.backgroundColor = [UIColor blackColor];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [coverView addGestureRecognizer:tap];
        
        [self.view addSubview:coverView];
    }
}

- (void)keyBordWillHidden:(NSNotification *)notifi {
    NSDictionary *info = notifi.userInfo;
    NSNumber *value = [info objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    float time = [value floatValue];
    
    [UIView animateWithDuration:time animations:^{
        coverView.alpha = 0;
    } completion:^(BOOL finished) {
        coverView = nil;
        [coverView removeFromSuperview];
    }];
}

- (void)tapAction:(UITapGestureRecognizer *)tap {
    [_searchBar resignFirstResponder];
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
