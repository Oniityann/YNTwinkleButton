//
//  ZYNTwinkleButton.h
//  ZYNTwinkleButton
//
//  Created by ZYN on 16/7/5.
//  Copyright © 2016年 Riven. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ZYNTwinkleButtonClickBlock)(void);

typedef NS_ENUM(NSUInteger, ZYNTwinkleButtonType) {
    ZYNTwinkleButtonTypeInside,
    ZYNTwinkleButtonTypeOutside
};

@interface ZYNTwinkleButton : UIView

/** button 点击事件 */
@property (nonatomic, copy) ZYNTwinkleButtonClickBlock clickEvent;

/**
 创建方法
 
 @param frame        button 框架
 @param type         button 类型
 @param twinkleColor 闪烁颜色
 @param color        背景色
 
 @return 按钮
 
 @since 1.0
 */
+ (ZYNTwinkleButton *)buttonWithFrame:(CGRect)frame
                                 type:(ZYNTwinkleButtonType)type
                         twinkleColor:(UIColor *)twinkleColor
                      backgroundColor:(UIColor *)color
                   andBackgroundImage:(UIImage *)image;

- (void)setText:(NSString *)text;
- (void)setTextColor:(UIColor *)textColor;
- (void)setText:(NSString *)text withTextColor:(UIColor *)textColor;

@end
