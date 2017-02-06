//
//  UpDataViewController.m
//  AppStore
//
//  Created by 王宝 on 15/8/24.
//  Copyright (c) 2015年 王宝. All rights reserved.
//

#import "UpDataViewController.h"
#import "DataServer.h"

@interface UpDataViewController ()
{
    /**单元格高度*/
    NSMutableArray *_rowsHeight;
    /**记录是否显示cell中新特性*/
    NSMutableArray *_featuresStates;
}
@end

@implementation UpDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"更新";
    
    _rowsHeight = [[NSMutableArray alloc] init];
    _featuresStates = [[NSMutableArray alloc] init];
    _displayData = [[NSMutableArray alloc] init];
    
    [self _loadPlistData];
    
    [self _loadData];
    
}

- (void)_loadPlistData {
    //获取路径对象
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //获取完整路径
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:@"data.plist"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    if (data) {
        _plistData = [data objectForKey:@"plistArray"];
    }
}

- (void)_loadData {
    [super showHUD:@"加载中"];
    
    NSString *url = @"store/home/";
    
    [DataServer requestWithURL:url params:nil httpMethod:@"POST" finishBlock:^(id result) {
        
        @try {
            self.data = [result objectForKey:@"data"];
            [self _loadDataAfter];
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            [super hiddenHUD];
        }
        
    } erro:^(id erro) {
        
    }];
}

- (void)_loadDataAfter {
    
    //存储待更新
    NSMutableArray *waitUpData = [[NSMutableArray alloc] init];
    //存储更新过的
    NSMutableArray *upDated = [[NSMutableArray alloc] init];
    //存储待更新项目的行高
    NSMutableArray *heights = [[NSMutableArray alloc] init];
    //存储单元格中新特性是否显示
    NSMutableArray *states = [[NSMutableArray alloc] init];
    
    for (NSDictionary *dic in _data) {  //所有程序,网络请求的数据
        for (NSDictionary *plistDic in _plistData) {    //已安装程序,本地数据
            
            NSString *dicId = [dic objectForKey:@"id"];
            
            NSString *plistDicId = [plistDic objectForKey:@"id"];
            
            //如果id相同说明此程序已经安装
            if ([dicId isEqualToString:plistDicId]) {
                
                NSString *version = [dic objectForKey:@"version"];
                NSString *plistVersion = [plistDic objectForKey:@"version"];
                
                //如果版本不相同则有新版本
                if (![version isEqualToString:plistVersion] || version.floatValue != plistVersion.floatValue) {
                    float height = 70;
                    NSString *state = @"0";
                    [states addObject:state];
                    [heights addObject:[NSNumber numberWithFloat:height]];
                    
                    //向字典中添加是否有更新字段，用于判断cell中更新按钮显示更新or打开
                    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:dic];
                    [dict setObject:@"0" forKey:@"updated"];
                    
                    [waitUpData addObject:dict];
                }
                else {
                    //如果有更新时间则更新过，没有更新时间则一次都没有更新过
                    NSString *upDataDate = [plistDic objectForKey:@"upDataDate"];
                    if (upDataDate != nil && ![upDataDate isEqualToString:@""]) {
                        [upDated addObject:plistDic];
                    }
                }
                
            }
            
        }
        
    }
    
    if (waitUpData.count > 0) {
        NSDictionary *waitDic = [NSDictionary dictionaryWithObject:waitUpData forKey:@"待更新项目"];
        [_displayData addObject:waitDic];
    }
    
    [_rowsHeight addObject:heights];
    [_featuresStates addObject:states];
    
    [_tableView reloadData];
    
    [self handleUpDated:upDated];
    
}

//处理更新过的数据
- (void)handleUpDated:(NSArray *)array {
    //取出所有更新时间
    NSMutableSet *set = [[NSMutableSet alloc] init];
    for (NSDictionary *dic in array) {
        NSString *upDate = [dic objectForKey:@"upDataDate"];
        [set addObject:upDate];
    }
    
    //根据日期排序
    NSArray *ary = [set allObjects];
    NSArray *sortedArray = [ary sortedArrayUsingSelector:@selector(compare:)];
    
    //有一个日期创建一个对应的数组，存储在这个日期更新的程序
    for (int i=(int)sortedArray.count-1; i>=0; i--) {
        //NSLog(@"进入循环%d",i);
        NSString *key = [sortedArray objectAtIndex:i];
        //NSLog(@"更新日期%@",key);
        NSMutableArray *values = [[NSMutableArray alloc] init];
        NSMutableArray *heights = [[NSMutableArray alloc] init];
        NSMutableArray *states = [[NSMutableArray alloc] init];
        //如果日期相同，则添加到当前日期对应的数组中
        for (NSDictionary *dic in array) {
            NSString *upDate = [dic objectForKey:@"upDataDate"];
            //NSLog(@"已更新项目de更新日期%@",upDate);
            if ([key isEqualToString:upDate]) {
                //NSLog(@"更新日期相同");
                NSString *state = @"0";
                [states addObject:state];
                float height = 70;
                [heights addObject:[NSNumber numberWithFloat:height]];

                //标记已更新过
                NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:dic];
                [dict setObject:@"1" forKey:@"updated"];
                [values addObject:dict];
            }
        }
        
        //将在此日期更新的程序存在一个字典中
        NSDictionary *upDatedDic = [NSDictionary dictionaryWithObject:values forKey:key];
        //NSLog(@"存放更新过的数据的字典%@",upDatedDic);
        [_displayData addObject:upDatedDic];
        [_rowsHeight addObject:heights];
        [_featuresStates addObject:states];
    }
    
    //NSLog(@"----------%@",_displayData);
    
    [_tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _displayData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary *dic = [_displayData objectAtIndex:section];
    NSArray *array = dic.allValues.firstObject;
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifi = @"upDataCell";
    
    UpDataTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifi];
    
    if (cell == nil) {
        cell = [[UpDataTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifi];
        [cell setFrame:CGRectMake(0, 0, self.view.width, 0)];
        cell.delegate = self;
    }
    
    if (indexPath.row != 0) {
        CALayer *toplayer = [CALayer layer];
        toplayer.backgroundColor = RGBA(54, 125, 242, 1).CGColor;
        toplayer.frame = CGRectMake(0, 0, self.view.width, 0.5);
        [cell.layer addSublayer:toplayer];
    }
    
    NSDictionary *dic = [_displayData objectAtIndex:indexPath.section];
    NSArray *array = dic.allValues.firstObject;
    cell.data = [array objectAtIndex:indexPath.row];
    cell.featuresState = [[_featuresStates objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 20)];
    view.backgroundColor = [UIColor clearColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.view.width-20, 20)];
    label.font = [UIFont boldSystemFontOfSize:16];
    label.textColor = [UIColor grayColor];
    label.backgroundColor = [UIColor clearColor];
    
    NSDictionary *dic = [_displayData objectAtIndex:section];
    NSString *text = [dic.allKeys firstObject];
    if (section != 0) {
        text = [NSString stringWithFormat:@"更新于%@",text];
    }
    label.text = text;
    
    [view addSubview:label];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}

- (void)UpDataCell:(UpDataTableViewCell *)cell changeTableViewHeightWithHeight:(CGFloat)height AndState:(NSString *)featuresState{

    //改变单元格高度
    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
    
    NSMutableArray *heights = [_rowsHeight objectAtIndex:indexPath.section];
    float rowHeight = [[heights objectAtIndex:indexPath.row] floatValue];
    if (rowHeight > 70) {
        rowHeight = rowHeight - height;
    }
    else {
        rowHeight = rowHeight + height;
    }
    
    [heights replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithFloat:rowHeight]];
    [_rowsHeight replaceObjectAtIndex:indexPath.section withObject:heights];

    //改变单元格新特性显示状态
    NSMutableArray *states = [_featuresStates objectAtIndex:indexPath.section];
    NSString *state = featuresState;
    [states replaceObjectAtIndex:indexPath.row withObject:state];
    [_featuresStates replaceObjectAtIndex:indexPath.section withObject:states];
    [_tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray *heights = [_rowsHeight objectAtIndex:indexPath.section];
    float height = [[heights objectAtIndex:indexPath.row] floatValue];
    return height;
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
