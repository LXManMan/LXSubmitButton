//
//  LXSubmitSuccessView.m
//  TestDemo
//
//  Created by 漫漫 on 2019/2/19.
//  Copyright © 2019 万众创新. All rights reserved.
//

#import "LXSubmitSuccessView.h"
static CGFloat lineWidth = 4.0f;
static CGFloat circleDuriation = 0.5f;
static CGFloat checkDuration = 0.2f;
#define BlueColor [UIColor colorWithRed:16/255.0 green:142/255.0 blue:233/255.0 alpha:1]
@interface LXSubmitSuccessView()<CAAnimationDelegate>
@property (nonatomic ,strong)CAShapeLayer *animationLayer;//!<容器layer
@property (nonatomic ,strong)CAShapeLayer *circleLayer;//!<圆圈
@property (nonatomic ,strong)CAShapeLayer *checkLayer;//!<对号
@property (nonatomic ,strong)UIBezierPath *circlePath;//!<圆圈路径
@property (nonatomic ,strong)UIBezierPath *checkPath;//!<对号路径
@property (nonatomic ,strong)CABasicAnimation *circleAnimation;//!<圆圈动画
@property (nonatomic ,strong)CABasicAnimation *checkAnimation;//!<对号动画


@end
@implementation LXSubmitSuccessView


-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initilize];
    }
    return self;
}
-(void)initilize{
    [self.layer addSublayer:self.animationLayer];
    
    [self.animationLayer addSublayer:self.circleLayer];
    
    [self.animationLayer addSublayer:self.checkLayer];
    
   
    
   
    
}
- (void)start {
    
    [self circleBeginAnimation];
    
    _checkAnimation.beginTime = CACurrentMediaTime() + 0.3;
    
    [self checkBeginAnimaiton];
    
}

- (void)hide {
    
    for (CALayer *layer in self.animationLayer.sublayers) {
        [layer removeAllAnimations];
    }
}
-(void)circleBeginAnimation{
    [self.circleLayer addAnimation:self.circleAnimation forKey:nil];
}
-(void)checkBeginAnimaiton{
    [self.checkLayer addAnimation:self.checkAnimation forKey:nil];
    
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    _animationLayer.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    _circleLayer.frame = self.animationLayer.bounds;

    if (!self.circlePath) {
        CGFloat radius = self.animationLayer.bounds.size.width/2.0f - lineWidth/2.0f;
        self.circlePath =[UIBezierPath bezierPathWithArcCenter:self.circleLayer.position radius:radius startAngle:-M_PI/2 endAngle:M_PI*3/2 clockwise:true];
    }
    self.circleLayer.path = self.circlePath.CGPath;
   
    if (!self.checkPath) {
        self.checkPath = [UIBezierPath bezierPath];
        
        CGFloat a = _animationLayer.bounds.size.width;
        [_checkPath moveToPoint:CGPointMake(a*2.7/10,a*5.4/10)];
        [_checkPath addLineToPoint:CGPointMake(a*4.5/10,a*7/10)];
        [_checkPath addLineToPoint:CGPointMake(a*7.8/10,a*3.8/10)];
    }
    self.checkLayer.path = self.checkPath.CGPath;
   
}
-(CAShapeLayer *)animationLayer{
    if (!_animationLayer) {
        _animationLayer =[CAShapeLayer  layer];
    }
    return _animationLayer;
}
-(CAShapeLayer *)checkLayer{
    if (!_checkLayer) {
        _checkLayer =[CAShapeLayer layer];
        _checkLayer.fillColor = [UIColor clearColor].CGColor;
        _checkLayer.strokeColor = BlueColor.CGColor;
        _checkLayer.lineWidth = lineWidth;
        _checkLayer.lineCap = kCALineCapRound;
        _checkLayer.lineJoin = kCALineJoinRound;
    }
    return _checkLayer;
}
-(CAShapeLayer *)circleLayer{
    if (!_circleLayer) {
        _circleLayer = [CAShapeLayer layer];
        _circleLayer.frame = self.animationLayer.bounds;
        _circleLayer.fillColor =  [[UIColor clearColor] CGColor];
        _circleLayer.strokeColor  = BlueColor.CGColor;
        _circleLayer.lineWidth = lineWidth;
        _circleLayer.lineCap = kCALineCapRound;
    }
    return _circleLayer;
}

/*
 *圆圈动画
 *
 */
-(CABasicAnimation *)circleAnimation{
    if (!_circleAnimation) {
        _circleAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        _circleAnimation.duration = circleDuriation;
        _circleAnimation.fromValue = @(0.0f);
        _circleAnimation.toValue = @(1.0f);
        _circleAnimation.delegate = self;
        _circleAnimation.fillMode = kCAFillModeForwards;
        _circleAnimation.removedOnCompletion  = NO;
        
        [_circleAnimation setValue:@"circleAnimation" forKey:@"animationName"];
    }
    return _circleAnimation;
}
/*
 *对号动画
 *
 */
-(CABasicAnimation *)checkAnimation{
    if (!_checkAnimation) {
        _checkAnimation  = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        _checkAnimation.duration = checkDuration;
        _checkAnimation.fillMode = kCAFillModeForwards;
        _checkAnimation.removedOnCompletion  = NO;
        _checkAnimation.fromValue = @(0.0f);
        _checkAnimation.toValue = @(1.0f);
        _checkAnimation.delegate = self;
        [_checkAnimation setValue:@"checkAnimation" forKey:@"animationName"];
    }
    return _checkAnimation;
}
@end
