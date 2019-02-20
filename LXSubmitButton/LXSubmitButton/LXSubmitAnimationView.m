//
//  LXSubmitAnimationView.m
//  LXSubmitButton
//
//  Created by 漫漫 on 2019/2/19.
//  Copyright © 2019 漫漫. All rights reserved.
//

#import "LXSubmitAnimationView.h"

static CGFloat circleDuriation = 0.5f;
static CGFloat checkDuration = 0.2f;
#define BlueColor [UIColor colorWithRed:16/255.0 green:142/255.0 blue:233/255.0 alpha:1]
@interface LXSubmitAnimationView()<CAAnimationDelegate>
@property (nonatomic ,strong)CAShapeLayer *checkLayer;

@property (nonatomic ,strong)CAShapeLayer *circleLayer;

//加载中的属性
@property (nonatomic ,strong)CADisplayLink *link;//!<加载中的定时器
@property (nonatomic ,assign)CGFloat startAngle;//!<开始的角度
@property (nonatomic ,assign)CGFloat endAngle;//!<结束的角度
@property (nonatomic ,assign)CGFloat progress;//!<进程百分比

//提交成功使用的属性
@property (nonatomic ,strong)UIBezierPath *circlePath;//!<圆圈路径
@property (nonatomic ,strong)UIBezierPath *checkPath;//!<对号路径
@property (nonatomic ,strong)CABasicAnimation *circleAnimation;//!<圆圈动画
@property (nonatomic ,strong)CABasicAnimation *checkAnimation;//!<对号动画
@end
@implementation LXSubmitAnimationView
-(void)dealloc{
    self.link = nil;
}
-(instancetype)initWithFrame:(CGRect)frame{
    self =[super initWithFrame:frame];
    if (self) {
        [self initilize];
    }
    return self;
}
-(void)initilize{
    
    self.lineWidth = 4;
    [self.layer addSublayer:self.circleLayer];

    [self.layer addSublayer:self.checkLayer];

    self.checkLayer.path = self.checkPath.CGPath;
    
    self.checkLayer.hidden= YES;
}
-(void)setLineWidth:(CGFloat)lineWidth{
    _lineWidth = lineWidth;
    self.circleLayer.lineWidth = self.checkLayer.lineWidth = lineWidth;
    self.circlePath.lineWidth = lineWidth;
}
-(void)setMainColor:(UIColor *)mainColor{
    _mainColor = mainColor;
    self.circleLayer.strokeColor = self.checkLayer.strokeColor = mainColor.CGColor;
}
- (void)setSubmitStatus:(SubmitStatus)payStatus {
    switch (payStatus) {
        case SubmitStatusDoing:
            [self showSubmitingAnimation];
            break;
        case SubmitStatusSuccess:
            [self showSuccessAnimation];
            break;
        default:
            break;
    }
}
-(void)showSubmitingAnimation{
    
    self.link.paused = NO;
    self.circleLayer.hidden = NO;
    self.checkLayer.hidden = YES;
    
}
-(void)showSuccessAnimation{
    
    self.link.paused = YES;

    self.circleLayer.hidden = NO;
    self.checkLayer.hidden = NO;
    self.circleLayer.path = self.circlePath.CGPath;
    
    [self circleBeginAnimation];
    
    //必须在这里设置才能获得当前的时间状态，不能用懒加载
    _checkAnimation.beginTime = CACurrentMediaTime() + 0.3;
    
    [self checkBeginAnimaiton];
    
}
-(void)circleBeginAnimation{
    
    
    [self.circleLayer addAnimation:self.circleAnimation forKey:nil];

}
-(void)checkBeginAnimaiton{
    [self.checkLayer addAnimation:self.checkAnimation forKey:nil];

}
-(void)displayLinkAction{
    _progress += [self speed];
    if (_progress >= 1) {
        _progress = 0;
    }
    [self updateAnimationLayer];
}
-(void)updateAnimationLayer{
    //默认从-M_PI_2 开始。
    _startAngle = -M_PI_2;
    _endAngle = -M_PI_2 +_progress * M_PI * 2;
    
    if (_endAngle > M_PI) {
        //当完成3/4圈的时候，计算剩余完成的进度除以1/4圈，是当前剩下的1/4圈完成的进度，1 减去后就是剩余的进度
        CGFloat progress1 = 1 - (1 - _progress)/0.25;
        _startAngle = -M_PI_2 + progress1 * M_PI * 2;
    }
    CGFloat radius = self.circleLayer.bounds.size.width/2.0f - _lineWidth/2.0f;
    CGFloat centerX = self.circleLayer.bounds.size.width/2.0f;
    CGFloat centerY = self.circleLayer.bounds.size.height/2.0f;
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(centerX, centerY) radius:radius startAngle:_startAngle endAngle:_endAngle clockwise:true];
    path.lineCapStyle = kCGLineCapRound;
    
    self.circleLayer.path = path.CGPath;
}

-(CGFloat)speed{
    if (_endAngle > M_PI) {
        return 0.3/60.0f;
    }
    return 2/60.0f;
}
-(CADisplayLink *)link{
    if (!_link) {
        _link =[CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkAction)];
         [_link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
        _link.paused = YES;
    }
    return _link;
}
-(CAShapeLayer *)checkLayer{
    if (!_checkLayer) {
        _checkLayer =[CAShapeLayer layer];
        _checkLayer.fillColor = [UIColor clearColor].CGColor;
        _checkLayer.strokeColor = BlueColor.CGColor;
        _checkLayer.lineCap = kCALineCapRound;
        _checkLayer.lineJoin = kCALineJoinRound;
    }
    return _checkLayer;
}
-(CAShapeLayer *)circleLayer{
    if (!_circleLayer) {
        _circleLayer = [CAShapeLayer layer];
        _circleLayer.frame = self.bounds;
        _circleLayer.fillColor =  [[UIColor clearColor] CGColor];
        _circleLayer.strokeColor  = BlueColor.CGColor;
        _circleLayer.lineCap = kCALineCapRound;
    }
    return _circleLayer;
}
-(UIBezierPath *)circlePath{
    if (!_circlePath) {
        //        CGFloat lineWidth = 5.0f;
        CGFloat radius = self.bounds.size.width/2.0f - self.lineWidth/2.0f;
        _circlePath =[UIBezierPath bezierPathWithArcCenter:self.circleLayer.position radius:radius startAngle:-M_PI/2 endAngle:M_PI*3/2 clockwise:true];
    }
    return _circlePath;
}
-(UIBezierPath *)checkPath{
    if (!_checkPath) {
        _checkPath = [UIBezierPath bezierPath];
        CGFloat a = self.bounds.size.width;
        [_checkPath moveToPoint:CGPointMake(a*2.7/10,a*5.4/10)];
        [_checkPath addLineToPoint:CGPointMake(a*4.5/10,a*7/10)];
        [_checkPath addLineToPoint:CGPointMake(a*7.8/10,a*3.8/10)];
    }
    return _checkPath;
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
