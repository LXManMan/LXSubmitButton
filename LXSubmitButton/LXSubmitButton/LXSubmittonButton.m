//
//  LXSubmittonButton.m
//  LXSubmitButton
//
//  Created by 漫漫 on 2019/2/19.
//  Copyright © 2019 漫漫. All rights reserved.
//

#import "LXSubmittonButton.h"
#import "UIView+Frame.h"
@interface LXSubmittonButton()
@property (nonatomic ,strong)UILabel *titleLabel;
@property (nonatomic ,strong)LXSubmitAnimationView *animationView;
@end
@implementation LXSubmittonButton

-(instancetype)initWithFrame:(CGRect)frame{
    self =[super initWithFrame:frame];
    if (self) {
        [self initilize];
    }
    return self;
}
-(instancetype)init{
    self = [super init];
    if (self) {
         [self initilize];
    }
    return self;
}
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initilize];
    }
    return self;
}
-(void)initilize{
    
    self.normalStatusText = @"提交";
    self.doingStatusText = @"提交中";
    self.successStatusText = @"提交成功";
    self.failedStatusText = @"重试";

    [self addSubview:self.titleLabel];
    [self addSubview:self.animationView];
    
    self.submitStatus  = SubmitStatusNormal;
    
  
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [self addGestureRecognizer:tap];
  
}
-(void)tapAction:(UITapGestureRecognizer *)tap{
    
    if (self.submitStatus == SubmitStatusNormal || self.submitStatus == SubmitStatusFailed) {
        if (self.submitClick) {
            self.submitClick(self.submitStatus);
        }
    }
    
    
}
-(void)setSubmitStatus:(SubmitStatus)submitStatus{
    _submitStatus = submitStatus;
    switch (_submitStatus) {
        case SubmitStatusNormal:
        {
            self.animationView.hidden = YES;
            self.titleLabel.text = self.normalStatusText;
            [self.titleLabel sizeToFit];
            
        }
            break;
        case SubmitStatusDoing:
        {
            self.animationView.hidden = NO;
            self.titleLabel.text = self.doingStatusText;
            [self.titleLabel sizeToFit];
            
        }
            break;
        case SubmitStatusSuccess:
        {
            self.animationView.hidden = NO;
            self.titleLabel.text = self.successStatusText;
            [self.titleLabel sizeToFit];
            
        }
            break;
        case SubmitStatusFailed:
        {
            self.animationView.hidden = YES;
            self.titleLabel.text = self.failedStatusText;
            [self.titleLabel sizeToFit];
            
        }
            break;
            
        default:
            break;
    }
    self.animationView.submitStatus = _submitStatus;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.titleLabel.center = CGPointMake(self.width/2, self.height/2);
    self.animationView.x = CGRectGetMinX(self.titleLabel.frame) - self.animationView.width- 10;
    self.animationView.center = CGPointMake(self.animationView.center.x, self.titleLabel.center.y);
}
-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel =[[UILabel alloc]init];
        _titleLabel.textColor = [UIColor whiteColor];
    }
    return _titleLabel;
}
-(LXSubmitAnimationView *)animationView{
    if (!_animationView) {
        _animationView =[[LXSubmitAnimationView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
        _animationView.mainColor = [UIColor whiteColor];
        _animationView.lineWidth = 2;
    }
    return _animationView;
}
@end
