//
//  MPViewController.m
//  MPKit
//
//  Created by yyqxiaoyin on 11/08/2017.
//  Copyright (c) 2017 yyqxiaoyin. All rights reserved.
//

#import "MPViewController.h"
#import "MPKit.h"
#import "MPTextField.h"

@interface MPViewController ()

@end

@implementation MPViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"init finished");
}


- (void)popTextField {
    MPTextField *textfield = [self alertViewTextFieldWithPlaceholder:@"请输入密码" secureTextEntry:YES leftTitle:@"" delegate:nil];
    YQAlertView *alert = [YQAlertView alertViewWithTitle:@"确认支付" message:@""];
    YQAlertAction *actionText = [YQAlertAction actionWithTextField:textfield handle:nil];
    textfield.keyboardType =  UIKeyboardTypeEmailAddress;
    YQAlertAction *actionCancel = [YQAlertAction actionWithTitle:@"取消" handler:^(YQAlertAction *action) {
        
    }];
    
    YQAlertAction *actionEnsure = [YQAlertAction actionWithTitle:@"确定啊？" titleColor:UIColor.whiteColor handler:^(YQAlertAction *action) {
        
    }];
    
    [alert addAction:actionText];
    
    if(1) {
        /// 忘记密码
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(MPWidth(0), 0, MPWidth(105), MPHeight(40));
        btn.titleLabel.font = MPFontSize(14);
        [btn setTitle:@"忘记密码?" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithHexColorString:@"999999"] forState:UIControlStateNormal];
        [btn addTouchHandle:^(UIButton *btn) {
            [alert hide];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            });
        }];
        YQAlertAction*custom = [YQAlertAction actionWithCustumView:btn];
        [alert addAction:custom];
    }

    /// 取消按钮
    [alert addAction:actionCancel];
    /// 确认密码按钮
    [alert addAction:actionEnsure];
    [alert show];
    
    /// 自动弹起键盘
    [textfield becomeFirstResponder];
}

- (MPTextField *)alertViewTextFieldWithPlaceholder:(NSString *)placeholder
                                   secureTextEntry:(BOOL)secureTextEntry
                                         leftTitle:(NSString *)leftTitle
                                          delegate:(id<UITextFieldDelegate>)delegate{
    MPTextField *textField = [[MPTextField alloc]init];
    textField.backgroundColor = [UIColor whiteColor];
    [textField.layer setBorderColor:[UIColor colorWithHexColorString:@"e1e1e1"].CGColor borderWidth:1.0/([UIScreen mainScreen].scale)];
    UILabel *leftView = [[UILabel alloc]init];
    leftView.backgroundColor = [UIColor whiteColor];
    leftView.font = MPFontSize(14);
    leftView.textAlignment = NSTextAlignmentCenter;
    [leftView sizeToFit];
    leftView.bounds = CGRectMake(0, 0, leftView.width + MPWidth(10), leftView.height +1);
    
    UIView *finalView = [[UIView alloc] initWithFrame:leftView.bounds];
    [finalView addSubview:leftView];
    
    textField.leftView = finalView;
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.delegate = delegate;
    textField.placeholder = placeholder;
    textField.secureTextEntry = secureTextEntry;
    
    return textField;
}




- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self popTextField];
}

- (void)originalMethod {
    YQAlertView *alertView = [YQAlertView alertViewWithTitle:nil message:@"123"];
//    alertView.isLastButtonActionNormalColor = YES;
    YQAlertAction *action1 = [YQAlertAction actionWithTitle:@"好的" handler:^(YQAlertAction *action) {
        
    }];
    YQAlertAction *action2 = [YQAlertAction actionWithTitle:@"好的1" handler:^(YQAlertAction *action) {
        
    }];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"自定义" forState:UIControlStateNormal];
    btn.frame = CGRectMake(0, 0, 100, 40);
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    YQAlertAction *custom = [YQAlertAction actionWithCustumView:btn];
    [alertView addAction:action1];
    [alertView addAction:action2];
    [alertView addAction:custom];
    [alertView show];
}

- (void)btnClick{
    NSLog(@"自定义View点击");
    [YQAlertView hideWithCompletion:^{
        NSLog(@"123");
        YQAlertView *alertView1 = [YQAlertView alertViewWithTitle:nil message:@"123"];
        YQAlertAction *action1 = [YQAlertAction actionWithTitle:@"好的" handler:^(YQAlertAction *action) {
            
        }];
        [alertView1 addAction:action1];
        [alertView1 show];
    }];
}

@end
