//
//  LXSubmitLoadingView.m
//  LXSubmitButton
//
//  Created by 漫漫 on 2019/2/19.
//  Copyright © 2019 漫漫. All rights reserved.
//

#import "LXSubmitLoadingView.h"
static CGFloat lineWidth = 4.0f;
#define BlueColor [UIColor colorWithRed:16/255.0 green:142/255.0 blue:233/255.0 alpha:1]
@interface LXSubmitLoadingView()
@property (nonatomic ,strong)CAShapeLayer *roundLayer;//!<
@property (nonatomic ,strong)CADisplayLink *link;//!<定时器
@property (nonatomic ,assign)CGFloat startAngle;//!<开始的角度
@property (nonatomic ,assign)CGFloat endAngle;//!<结束的角度
@property (nonatomic ,assign)CGFloat progress;//!<进程百分比
@end
@implementation LXSubmitLoadingView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initilize];
    }
    return self;
}
-(instancetype)init{
    self=[super init];
    if (self) {
        [self initilize];
    }
    return self;
}
- (CGSize)intrinsicContentSize {
    
    return CGSizeMake(40, 40);
}
-(void)initilize{
    
    self.roundLayer.strokeColor = BlueColor.CGColor;
    self.roundLayer.fillColor = [UIColor clearColor].CGColor;
    self.roundLayer.lineWidth = lineWidth;
    self.roundLayer.lineCap = kCALineCapRound;
    [self.layer addSublayer:self.roundLayer];
    
    self.link = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkAction)];
    [self.link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    self.link.paused = false;
}
-(void)layoutSubviews{
    [super layoutSubviews];
    self.roundLayer.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);

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
    CGFloat radius = self.roundLayer.bounds.size.width/2.0f - lineWidth/2.0f;
    CGFloat centerX = self.roundLayer.bounds.size.width/2.0f;
    CGFloat centerY = self.roundLayer.bounds.size.height/2.0f;
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(centerX, centerY) radius:radius startAngle:_startAngle endAngle:_endAngle clockwise:true];
    path.lineCapStyle = kCGLineCapRound;
    
    self.roundLayer.path = path.CGPath;
}

-(CGFloat)speed{
    if (_endAngle > M_PI) {
        return 0.3/60.0f;
    }
    return 2/60.0f;
}

-(CAShapeLayer *)roundLayer{
    if (!_roundLayer) {
        _roundLayer = [CAShapeLayer layer];
    }
    return _roundLayer;
}
@end

