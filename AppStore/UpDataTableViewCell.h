//
//  UpDataTableViewCell.h
//  AppStore
//
//  Created by 王宝 on 15/8/24.
//  Copyright (c) 2015年 王宝. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZLabel.h"
@class UpDataTableViewCell;
@protocol UpDataCellDelegate <NSObject>

- (void)UpDataCell:(UpDataTableViewCell *)cell changeTableViewHeightWithHeight:(CGFloat)height
          AndState:(NSString *)featuresState;

@end

@interface UpDataTableViewCell : UITableViewCell
{
    /**图标*/
    UIImageView *_icon;
    
    /**标题*/
    UILabel *_title;
    
    /**简介（版本，大小）*/
    UILabel *_info;
    
    /**查看新特性*/
    ZLabel *_newFeatures;
    UIImageView *_imgView;
    
//    /**新特性*/
//    ZLabel *_newFeaturesInfo;
    
    /**更新*/
    UIButton *_upData;
}

/**
 *  记录新特性是否显示，默认不显示
 *  0 不显示
 *  1 显示
 */
@property (nonatomic ,strong) NSString *featuresState;

@property (nonatomic ,strong) ZLabel *featuresInfo;

@property (nonatomic ,assign) id<UpDataCellDelegate> delegate;

@property (nonatomic ,strong) NSDictionary *data;

@end
