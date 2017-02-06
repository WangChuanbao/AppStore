//
//  UpDataTableViewCell.m
//  AppStore
//
//  Created by 王宝 on 15/8/24.
//  Copyright (c) 2015年 王宝. All rights reserved.
//

#import "UpDataTableViewCell.h"
#import "UIImageView+WebCache.h"

@implementation UpDataTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _icon = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self addSubview:_icon];
        
        _title = [[UILabel alloc] initWithFrame:CGRectZero];
        _title.font = [UIFont boldSystemFontOfSize:14];
        [self addSubview:_title];
        
        _info = [[UILabel alloc] initWithFrame:CGRectZero];
        _info.font = [UIFont systemFontOfSize:12];
        [self addSubview:_info];
        
        _newFeatures = [[ZLabel alloc] initWithFrame:CGRectZero font:[UIFont systemFontOfSize:12]];
        _newFeatures.userInteractionEnabled = YES;
        [self addSubview:_newFeatures];
        _imgView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _imgView.contentMode = UIViewContentModeScaleAspectFit;
        _imgView.userInteractionEnabled = YES;
        [self addSubview:_imgView];
        
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showNewFeatures)];
        [_newFeatures addGestureRecognizer:tap1];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showNewFeatures)];
        [_imgView addGestureRecognizer:tap];
        
        _featuresInfo = [[ZLabel alloc] initWithFrame:CGRectZero font:[UIFont systemFontOfSize:12]];
        [self addSubview:_featuresInfo];
        
        _upData = [[UIButton alloc] initWithFrame:CGRectZero];
        [_upData setTitle:@"更新" forState:UIControlStateNormal];
        [_upData setTitleColor:RGBA(54, 125, 242, 1) forState:UIControlStateNormal];
        _upData.titleLabel.font = [UIFont systemFontOfSize:13];
        [_upData addTarget:self action:@selector(upDataAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_upData];
        
        _upData.layer.masksToBounds = YES;
        _upData.layer.borderWidth = 1;
        _upData.layer.cornerRadius = 5;
        _upData.layer.borderColor = RGBA(54, 125, 242, 1).CGColor;
        
    }
    
    return self;
}

- (void)layoutSubviews {
    
    //图标
    _icon.frame = CGRectMake(15, 10, 50, 50);
    NSString *icon = [_data objectForKey:@"logo"];
    [_icon sd_setImageWithURL:[NSURL URLWithString:icon]];
    
    //应用名称
    _title.frame = CGRectMake(_icon.right+10, 12, self.width-_icon.width-100, 16);
    _title.text = [_data objectForKey:@"name"];
    
    //应用简介
    _info.frame = CGRectMake(_title.left, _title.bottom, _title.width, 15);
    NSString *version = [_data objectForKey:@"version"];
    NSString *size = [_data objectForKey:@"size"];
    NSString *info = [NSString stringWithFormat:@"版本 %@，%@",version,size];
    _info.text = info;
    
    //新特性入口,展开则显示更新时间
    _newFeatures.frame = CGRectMake(_title.left, _info.bottom, _title.width, _info.height);
    if ([_featuresState isEqualToString:@"0"] || _featuresState.integerValue == 0) {
        _newFeatures.text = @"新功能";
    }
    else {
        NSString *uptime = [_data objectForKey:@"uptime"];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:uptime.integerValue];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
        NSString *time = [dateFormatter stringFromDate:date];
        _newFeatures.text = time;
    }
    
    _imgView.frame = CGRectMake(_newFeatures.right+5, _newFeatures.top, 15, 15);
    _imgView.image = [UIImage imageNamed:@"san.png"];
    
    //新特性
    _featuresInfo.frame = CGRectMake(_icon.left, _icon.bottom+10, self.width-30, 0);
    if ([_featuresState isEqualToString:@"0"] || _featuresState.integerValue == 0) {
        _featuresInfo.hidden = YES;
    }
    else {
        _featuresInfo.hidden = NO;
    }
    NSString *uplog = [_data objectForKey:@"uplog"];
    _featuresInfo.text = @"asdkhjdhskcjldsajkjkbcuiebiuewbjhbdchjvbjhdksbvkcjabchvgwexcwqibvuewhda";
    
    //更新
    _upData.frame = CGRectMake(_title.right+20, 23, 40, 24);
    NSString *updated = [_data objectForKey:@"updated"];
    if ([updated isEqualToString:@"0"] || updated.integerValue == 0) {
        [_upData setTitle:@"更新" forState:UIControlStateNormal];
    }
    else {
        [_upData setTitle:@"打开" forState:UIControlStateNormal];
    }
}

- (void)showNewFeatures {
    if (_featuresInfo.hidden == YES) {
        //显示新特性
        _featuresState = @"1";
        
        //改变三角图标的坐标，transform
        [_imgView setLeft:_newFeatures.right+5];
        _imgView.transform = CGAffineTransformMakeRotation((180.0f * M_PI) / 180.0f);
    }
    else {
        _featuresState = @"0";
        
        _imgView.transform = CGAffineTransformIdentity;
    }
    [_delegate UpDataCell:self changeTableViewHeightWithHeight:_featuresInfo.height AndState:_featuresState];
}

//更新
- (void)upDataAction {
    
    NSString *updated = [_data objectForKey:@"updated"];
    if ([updated isEqualToString:@"0"] || updated.integerValue == 0) {
        NSString *url = [_data objectForKey:@"url"];
        //NSString *downUrl = [downBaseURL stringByAppendingString:url];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        [self saveToLocal];
    }
    else {
        NSString *urlTypes = [_data objectForKey:@"ios_uri"];
        NSURL *url = [NSURL URLWithString:urlTypes];
        [[UIApplication sharedApplication] openURL:url];
    }

}

- (void)saveToLocal {
    //获取路径对象
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //获取完整路径
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:@"data.plist"];
    
    //为当前对象添加更新时间
    NSMutableDictionary *dictplist = [NSMutableDictionary dictionaryWithDictionary:_data];
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy年MM月dd日"];
    NSString *dateStr = [formatter stringFromDate:date];
    [dictplist setObject:dateStr forKey:@"upDataDate"];
    
    //读取本地数据，替换当前对象信息
    NSMutableDictionary *data = [self readPlistFile];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    if (data) {
        array = [data objectForKey:@"plistArray"];
        NSInteger index = [self checkObjectLocationIndex:array];
        [array replaceObjectAtIndex:index withObject:dictplist];
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

- (NSInteger)checkObjectLocationIndex:(NSArray *)array {
    NSInteger index = 0;
    NSString *cid = [_data objectForKey:@"id"];
    for (int i=0; i<array.count; i++) {
        NSDictionary *dic = [array objectAtIndex:i];
        NSString *dicId = [dic objectForKey:@"id"];
        if ([dicId isEqualToString:cid]) {
            index = i;
        }
    }
    return index;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
