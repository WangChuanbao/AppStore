//
//  AboutViewController.m
//  AppStore
//
//  Created by 王宝 on 15/8/10.
//  Copyright (c) 2015年 王宝. All rights reserved.
//

#import "AboutViewController.h"
#import "AboutView.h"
#import "ZLabel.h"

@interface AboutViewController ()
{
    UIScrollView *scrollView;
    NSString *text;
    ZLabel *label1;
    ZLabel *label2;
    UILabel *contactUs;
    UILabel *website;
    UILabel *message;
}
@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"关于";
    
    [self _initViews];

    [self _loadData];

}

- (void)_initViews {
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height-64-49)];
    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.userInteractionEnabled = YES;
    [self.view addSubview:scrollView];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 65, 105)];
    imageView.image = [UIImage imageNamed:@"logo02.png"];
    [scrollView addSubview:imageView];
    
    label1 = [[ZLabel alloc] initWithFrame:CGRectMake(82, 10, self.view.width-90, 115) font:[UIFont boldSystemFontOfSize:12]];
    label1.fixedWidth = YES;
    [scrollView addSubview:label1];
    
    label2 = [[ZLabel alloc] initWithFrame:CGRectMake(10, label1.bottom, self.view.width-20, 0) font:[UIFont boldSystemFontOfSize:12]];
    label2.fixedWidth = YES;
    [scrollView addSubview:label2];
    
    contactUs = [[UILabel alloc] initWithFrame:CGRectMake(imageView.left, label2.bottom+10, label2.width, 15)];
    contactUs.userInteractionEnabled = YES;
    contactUs.text = [NSString stringWithFormat:@"联系我们：%@",kCompanyPhone];
    contactUs.font = [UIFont boldSystemFontOfSize:12];
    contactUs.textColor = RGBA(54, 125, 242, 1);
    [scrollView addSubview:contactUs];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contactUs)];
    [contactUs addGestureRecognizer:tap];
    
    website = [[UILabel alloc] initWithFrame:CGRectMake(contactUs.left, contactUs.bottom, contactUs.width, contactUs.height)];
    website.userInteractionEnabled = YES;
    website.text = [NSString stringWithFormat:@"公司网址：%@",kCompanyWebsite];
    website.font = [UIFont boldSystemFontOfSize:12];
    website.textColor = RGBA(54, 125, 242, 1);
    [scrollView addSubview:website];
    
    UITapGestureRecognizer *websiteTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(websiteTap)];
    [website addGestureRecognizer:websiteTap];
    
    message = [[UILabel alloc] initWithFrame:CGRectMake(0, website.bottom+10, self.view.width, 45)];
    message.text = @"版本1.0\n北京鸿天融达信息技术有限公司\nCopyright©2015";
    message.font = [UIFont boldSystemFontOfSize:12];
    message.numberOfLines = 0;
    message.textAlignment = NSTextAlignmentCenter;
    message.textColor = [UIColor grayColor];
    [scrollView addSubview:message];
}

- (void)_loadData {
    text=@"";
    NSString *string = @"这里是关于该商城的文字描述";
    for (int i=0; i<20; i++) {
        text = [text stringByAppendingString:[NSString stringWithFormat:@"%@",string]];
    }
    
    [self _loadAfter];
}

- (void)_loadAfter {
    
    label1.text = text;
    
    if (label1.height > 120) {
        for (int i=0; i<text.length; i++) {
            NSString *str = [text substringToIndex:i];
            label1.text = str;
            
            if (label1.height>115) {
                label1.text = [text substringToIndex:i-1];
                label2.text = [text substringFromIndex:i-1];
                [self changeViewsFrame];
                return;
            }
        }
    }
}

- (void)changeViewsFrame {
    float poor = self.view.height-64-49-label2.bottom;
    if (poor < 105) {
        [contactUs setTop:label2.bottom+10];
        [website setTop:contactUs.bottom];
        [message setTop:website.bottom+10];
        [scrollView setContentSize:CGSizeMake(0, message.bottom+10)];
    }
    else {
        [message setTop:self.view.height - 55 - 49 - 64];
        [website setBottom:message.top -10];
        [contactUs setBottom:website.top-5];
    }
}

- (void)contactUs {
    NSLog(@"拨打电话");
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:
                                                [NSString stringWithFormat:@"tel://%@",kCompanyPhone]]];
}

- (void)websiteTap {
    NSLog(@"发送邮件");
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:
                                                [NSString stringWithFormat:@"mailto://%@",kCompanyWebsite]]];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"----------%@",touches);
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
