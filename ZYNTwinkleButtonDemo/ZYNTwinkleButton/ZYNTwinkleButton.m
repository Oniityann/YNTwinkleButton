//
//  ZYNTwinkleButton.m
//  ZYNTwinkleButton
//
//  Created by ZYN on 16/7/5.
//  Copyright © 2016年 Riven. All rights reserved.
//

#import "ZYNTwinkleButton.h"

static CGFloat const ZYNInsideCircleRadius = 20;

@interface ZYNTwinkleButton ()<CAAnimationDelegate>

/** button title */
@property (nonatomic, strong) UILabel *titleLabel;
/** button type */
@property (nonatomic, assign) ZYNTwinkleButtonType buttonType;
/** button 闪烁颜色 */
@property (nonatomic, strong) UIColor *twinkleColor;
/** button 背景图片 */
@property (nonatomic, strong) UIImageView *bgImageView;

@end

@implementation ZYNTwinkleButton

+ (ZYNTwinkleButton *)buttonWithFrame:(CGRect)frame
                                 type:(ZYNTwinkleButtonType)type
                         twinkleColor:(UIColor *)twinkleColor
                      backgroundColor:(UIColor *)color
                   andBackgroundImage:(UIImage *)image {
    
    ZYNTwinkleButton *button = [[ZYNTwinkleButton alloc] initWithFrame:frame];
    button.buttonType = type;
    button.twinkleColor = twinkleColor;
    
    if (color) {
        button.backgroundColor = color;
    } else {
        button.backgroundColor = [UIColor whiteColor];
    }
    
    if (image) {
        UIImageView *bgImageView = [[UIImageView alloc] init];
        bgImageView.frame = button.bounds;
        bgImageView.image = image;
        [button addSubview:bgImageView];
    }
    
    return button;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
        [self addGestureRecognizer:tap];
        
        _titleLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _titleLabel.backgroundColor = [UIColor clearColor];
        [_titleLabel setTextColor:[UIColor whiteColor]];
        [_titleLabel setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:_titleLabel];
        
        self.backgroundColor = [UIColor grayColor];
    }
    
    return self;
}

- (void)setText:(NSString *)text {
    [self setText:text withTextColor:nil];
}

- (void)setTextColor:(UIColor *)textColor {
    [self setText:nil withTextColor:textColor];
}

- (void)setText:(NSString *)text withTextColor:(UIColor *)textColor {
    
    if (text) {
        self.titleLabel.text = text;
    }
    
    if (textColor) {
        self.titleLabel.textColor = textColor;
    }
}

- (void)setButtonType:(ZYNTwinkleButtonType)buttonType {
    
    if (buttonType == ZYNTwinkleButtonTypeInside) {
        self.clipsToBounds = YES;
    } else {
        self.clipsToBounds = NO;
    }
    
    if (_buttonType != buttonType) {
        _buttonType = buttonType;
    }
}

- (void)tapped:(UITapGestureRecognizer *)recognizer {
    
    CGPoint tapLocation = [recognizer locationInView:self];
    CAShapeLayer *circleShape = nil;
    CGFloat scale = 1.0f;
    
    CGFloat width = self.bounds.size.width, height = self.bounds.size.height;
    
    if (self.buttonType == ZYNTwinkleButtonTypeInside) {
        
        CGFloat biggerEdge = width > height ? width : height;
        CGFloat smallerEdge = width > height ? height : width;
        
        CGFloat radius = smallerEdge / 2 > ZYNInsideCircleRadius ? ZYNInsideCircleRadius : smallerEdge / 2;
        
        scale = biggerEdge / radius + 0.5;
        
        circleShape = [self createCircleShapeWithPosition:CGPointMake(tapLocation.x - radius, tapLocation.y - radius)
                                                 pathRect:CGRectMake(0, 0, radius * 2, radius * 2)
                                                   radius:radius];
    } else {
        
        scale = 2.5f;
        
        circleShape = [self createCircleShapeWithPosition:CGPointMake(width/2, height/2)
                                                 pathRect:CGRectMake(-CGRectGetMidX(self.bounds), -CGRectGetMidY(self.bounds), width, height)
                                                   radius:self.layer.cornerRadius];
    }
    
    [self.layer addSublayer:circleShape];
    
    CAAnimationGroup *groupAnimation = [self createFlashAnimationWithScale:scale duration:0.5f];
    
    [groupAnimation setValue:circleShape forKey:@"circleShaperLayer"];
    
    [circleShape addAnimation:groupAnimation forKey:nil];
    [circleShape setDelegate:self];
}

- (CAShapeLayer *)createCircleShapeWithPosition:(CGPoint)position
                                       pathRect:(CGRect)rect
                                         radius:(CGFloat)radius {
    
    CAShapeLayer *circleShape = [CAShapeLayer layer];
    circleShape.path = [self createCirclePathWithRadius:rect radius:radius];
    circleShape.position = position;
    
    if (self.buttonType == ZYNTwinkleButtonTypeInside) {
        circleShape.bounds = CGRectMake(0, 0, radius * 2, radius * 2);
        circleShape.fillColor = self.twinkleColor ? self.twinkleColor.CGColor : [UIColor whiteColor].CGColor;
    } else {
        circleShape.fillColor = [UIColor clearColor].CGColor;
        circleShape.strokeColor = self.twinkleColor ? self.twinkleColor.CGColor : [UIColor purpleColor].CGColor;
    }
    
    circleShape.opacity = 0;
    circleShape.lineWidth = 1;
    
    return circleShape;
}

- (CAAnimationGroup *)createFlashAnimationWithScale:(CGFloat)scale
                                           duration:(CGFloat)duration {
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    scaleAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(scale, scale, 1)];
    
    CABasicAnimation *alphaAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    alphaAnimation.fromValue = @1;
    alphaAnimation.toValue = @0;
    
    CAAnimationGroup *animation = [CAAnimationGroup animation];
    animation.animations = @[scaleAnimation, alphaAnimation];
    animation.delegate = self;
    animation.duration = duration;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    return animation;
}

- (CGPathRef)createCirclePathWithRadius:(CGRect)frame
                                 radius:(CGFloat)radius {
    return [UIBezierPath bezierPathWithRoundedRect:frame cornerRadius:radius].CGPath;
}

#pragma mark - CAAnimation delegate
- (void)animationDidStop:(CAAnimation *)anim
                finished:(BOOL)flag {
    
    CALayer *layer = [anim valueForKey:@"circleShaperLayer"];
    
    if (layer) {
        [layer removeFromSuperlayer];
        if (self.clickEvent) {
            self.clickEvent();
        }
    }
}

@end
