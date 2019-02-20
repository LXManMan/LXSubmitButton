//
//  LXSubmitAnimationView.h
//  LXSubmitButton
//
//  Created by 漫漫 on 2019/2/19.
//  Copyright © 2019 漫漫. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger,SubmitStatus) {
    SubmitStatusNormal = 0,
    SubmitStatusDoing ,
    SubmitStatusSuccess,
    SubmitStatusFailed,
};
@interface LXSubmitAnimationView : UIView
@property (nonatomic ,assign)SubmitStatus submitStatus;//!状态
@property (nonatomic ,strong)UIColor *mainColor;//!主色调
@property (nonatomic ,assign)CGFloat lineWidth;//!线宽
@end

NS_ASSUME_NONNULL_END
