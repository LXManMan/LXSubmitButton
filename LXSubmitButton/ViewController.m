//
//  ViewController.m
//  LXSubmitButton
//
//  Created by 漫漫 on 2019/2/19.
//  Copyright © 2019 漫漫. All rights reserved.
//

#import "ViewController.h"
#import "LXSubmittonButton.h"
#import "LXSubmitLoadingView.h"
#import "LXSubmitSuccessView.h"
#import "HudController.h"
@interface ViewController ()
@property (nonatomic ,strong)LXSubmitLoadingView *loadingView;
@property (nonatomic ,strong)LXSubmitSuccessView *successView;
@property (weak, nonatomic) IBOutlet UITextField *intput;

@property (weak, nonatomic) IBOutlet LXSubmittonButton *submittonButton;
@property (weak, nonatomic) IBOutlet UIButton *resetButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"媚儿";
   
//    self.loadingView  = [[LXSubmitLoadingView alloc]initWithFrame:CGRectMake(100, 100, 50, 50)];
//
//    [self.view addSubview:self.loadingView];
    
    UILabel *loadingLabel =[[UILabel alloc]init];
    loadingLabel.text = @"加载中";
    loadingLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:loadingLabel];
    
    [loadingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       make.left.mas_equalTo(100);
       make.top.mas_equalTo(100);

    }];
    self.loadingView = [[LXSubmitLoadingView alloc]init];
    [self.view addSubview:self.loadingView];
    [self.loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(100);
        make.top.mas_equalTo(loadingLabel.mas_bottom).offset(20);
        make.size.mas_equalTo(CGSizeMake(37, 37));
    }];
    
    UILabel *successLabel =[[UILabel alloc]init];
    successLabel.text = @"提交成功";
    successLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:successLabel];
    
    [successLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-100);
        make.top.mas_equalTo(100);
        
    }];
    self.successView = [[LXSubmitSuccessView alloc]init];
    [self.view addSubview:self.successView];
    [self.successView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-100);
        make.top.mas_equalTo(successLabel.mas_bottom).offset(20);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    
    
    
    kWeakSelf
    self.submittonButton.submitClick = ^(SubmitStatus submitStatus) {
        
        weakSelf.submittonButton.submitStatus  = SubmitStatusDoing;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if ([weakSelf.intput.text isEqualToString:@"12345"]) {
                
                weakSelf.submittonButton.submitStatus = SubmitStatusSuccess;
            }else{
                weakSelf.submittonButton.submitStatus = SubmitStatusFailed;
            }
        });

    };
    
    
    
    


    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.successView start];
}
- (IBAction)rest:(id)sender {
    self.submittonButton.submitStatus = SubmitStatusNormal;
}
- (IBAction)hud:(id)sender {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;//必须先设置这个style，才能设置背景透明。否则会有毛玻璃效果蒙版
    hud.minSize = CGSizeMake(100, 100);
    LXSubmitLoadingView *loadingView =[[LXSubmitLoadingView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    hud.customView = loadingView;
//    hud.label.text = @"加载中...";
    //是否设置黑色背景，这两句配合使用
    hud.bezelView.color = [UIColor clearColor];
    hud.contentColor = [UIColor clearColor];
    hud.label.textColor = [UIColor whiteColor];
    hud.removeFromSuperViewOnHide = YES;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        hud.hidden = YES;
    });

}

@end
