//
//  LXSubmittonButton.h
//  LXSubmitButton
//
//  Created by 漫漫 on 2019/2/19.
//  Copyright © 2019 漫漫. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LXSubmitAnimationView.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^LXSubmitClick)(SubmitStatus submitStatus);
@interface LXSubmittonButton : UIView
//各状态文本
@property (strong,nonatomic)NSString *normalStatusText;
@property (strong,nonatomic)NSString *doingStatusText;
@property (strong,nonatomic)NSString *successStatusText;
@property (strong,nonatomic)NSString *failedStatusText;

@property (strong,nonatomic)UIFont *textFont;
@property (strong,nonatomic)UIColor *textColor;

@property (nonatomic,assign)SubmitStatus submitStatus;
@property (nonatomic ,copy)LXSubmitClick submitClick;
@end

NS_ASSUME_NONNULL_END
