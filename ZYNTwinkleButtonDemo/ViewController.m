//
//  ViewController.m
//  ZYNTwinkleButtonDemo
//
//  Created by 郑一楠 on 2016/12/15.
//  Copyright © 2016年 zyn. All rights reserved.
//

#import "ViewController.h"
#import "ZYNTwinkleButton.h"
#import <Masonry.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // inside style
    ZYNTwinkleButton *tB = [ZYNTwinkleButton buttonWithFrame:CGRectMake(100, 100, 120, 40) type:ZYNTwinkleButtonTypeInside twinkleColor:[UIColor whiteColor] backgroundColor:[UIColor brownColor] andBackgroundImage:nil];
    [tB setText:@"twinkle" withTextColor:[UIColor whiteColor]];
    [self.view addSubview:tB];
    
    // outside style
    UIColor *twinkleColor = [UIColor colorWithRed:(166 / 255) green:(193 / 255) blue:(84 / 255) alpha:1];
    ZYNTwinkleButton *tB1 = [ZYNTwinkleButton buttonWithFrame:CGRectMake(100, 200, 120, 40) type:ZYNTwinkleButtonTypeOutside twinkleColor:twinkleColor backgroundColor:nil
                                           andBackgroundImage:[UIImage imageNamed:@"sing_dub"]];
    [self.view addSubview:tB1];
    
    
    /**
     When use masonry to layout the control, please use remakeConstraints.
     The frame param can not be nil.
     You can also use 'alloc] initWithFrame:]' to create a twinkle button, in this circumstances, you have to add a bg pic or title label yourself, if you want one.
     */
    ZYNTwinkleButton *tB2 = [ZYNTwinkleButton buttonWithFrame:CGRectMake(100, 500, 120, 40) type:ZYNTwinkleButtonTypeInside twinkleColor:[UIColor whiteColor] backgroundColor:nil andBackgroundImage:[UIImage imageNamed:@"sing_dub"]];
    [self.view addSubview:tB2];
    
    [tB2 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tB1.mas_bottom).offset(80);
        make.left.equalTo(tB1);
        make.width.and.height.equalTo(tB1);
    }];
    
    ZYNTwinkleButton *tB3 = [ZYNTwinkleButton buttonWithFrame:CGRectMake(100, 500, 120, 40) type:ZYNTwinkleButtonTypeInside twinkleColor:[UIColor whiteColor] backgroundColor:[UIColor blackColor] andBackgroundImage:nil];
    [tB3 setText:@"twinkle" withTextColor:[UIColor whiteColor]];
    [self.view addSubview:tB3];
    
    [tB3 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tB2.mas_bottom).offset(80);
        make.left.equalTo(tB1);
        make.size.equalTo(tB1);
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
