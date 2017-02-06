//
//  HomeTableViewCell.m
//  AppStore
//
//  Created by 王宝 on 15/8/10.
//  Copyright (c) 2015年 王宝. All rights reserved.
//

#import "HomeTableViewCell.h"
#import "UIImageView+WebCache.h"

@implementation HomeTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    bgview = [[UIView alloc] initWithFrame:CGRectZero];
    bgview.backgroundColor = [UIColor clearColor];
    bgview.userInteractionEnabled = YES;
    [self addSubview:bgview];
    [self sendSubviewToBack:bgview];
    
    toplayer = [CALayer layer];
    toplayer.backgroundColor = RGBA(54, 125, 242, 1).CGColor;
    [bgview.layer addSublayer:toplayer];
    
    _install.layer.masksToBounds = YES;
    _install.layer.borderWidth = 1;
    _install.layer.cornerRadius = 5;
    _install.layer.borderColor = RGBA(54, 125, 242, 1).CGColor;
    
}

- (void)layoutSubviews {
    bgview.frame = self.bounds;
    toplayer.frame = CGRectMake(0, 0, kScreenWidth, 0.5);
    
    NSString *imageUrl = [_data objectForKey:@"logo"];
    [_icon sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
    
    NSString *title = [_data objectForKey:@"name"];
    _title.text = title;
    
    NSString *version = [_data objectForKey:@"version"];
    NSString *size = [_data objectForKey:@"size"];
    _info.text = [NSString stringWithFormat:@"版本 %@，%@",version,size];
    
    NSString *type = [_data objectForKey:@"type_name"];
    _type.text = type;
    
    NSString *urlTypes = [_data objectForKey:@"ios_uri"];
    isInstall = [self checkURLTypes:urlTypes];
    if (isInstall) {
        [_install setTitle:@"打开" forState:UIControlStateNormal];
    }
}

- (BOOL)checkURLTypes:(NSString *)urlTypes {
    NSURL *url = [NSURL URLWithString:urlTypes];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        return YES;
    }
    return NO;
}

- (IBAction)install:(UIButton *)sender {
    
    if (isInstall) {
        //打开
        NSString *urlTypes = [_data objectForKey:@"ios_uri"];
        NSURL *url = [NSURL URLWithString:urlTypes];
        [[UIApplication sharedApplication] openURL:url];
    }
    else {
        //下载安装
        NSString *url = [_data objectForKey:@"url"];

        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",url]]];
        [self saveToLocal];
        
    }
    
}

- (void)saveToLocal {
    
    //获取路径对象
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //获取完整路径
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:@"data.plist"];
    
    NSMutableDictionary *dictplist = [NSMutableDictionary dictionaryWithDictionary:_data];
    
    /*  
     先读取，如果有数据则判断之前是否存储过，
     如果存储过则替换，没有则添加到数组（为了防止第一次安装写入文件后，删除程序重新安装）
     */
    NSMutableDictionary *data = [self readPlistFile];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    if (data) {
        array = [data objectForKey:@"plistArray"];
        NSInteger index = [self checkObjectLocationIndex:array];
        if (index != NO) {
            [array replaceObjectAtIndex:index withObject:dictplist];
        }
        else {
            [array addObject:dictplist];
        }
    }
    
    data = [NSMutableDictionary dictionaryWithObject:array forKey:@"plistArray"];
    
    //写入文件
    [data writeToFile:plistPath atomically:YES];
    
}

- (NSMutableDictionary *)readPlistFile {
    //获取路径对象
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //获取完整路径
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:@"data.plist"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    return data;
}

//检查在数组中是否有重复数据
- (NSInteger)checkObjectLocationIndex:(NSArray *)array {
    NSString *cid = [_data objectForKey:@"id"];
    for (int i=0; i<array.count; i++) {
        NSDictionary *dic = [array objectAtIndex:i];
        NSString *dicId = [dic objectForKey:@"id"];
        if ([dicId isEqualToString:cid]) {
            return i;
        }
    }
    return NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
