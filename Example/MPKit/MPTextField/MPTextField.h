//
//  MPTextField.h
//  MoponChinaFilm
//
//  Created by Mopon on 16/10/3.
//  Copyright © 2016年 Mopon. All rights reserved.
//

#import <UIKit/UIKit.h>

#define NUM @"0123456789"
#define ALPHA @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
#define ALPHANUM @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
#define ALLBUTCHINESE @"ABCDEFGHIJKLMNOPQRSTUVWXYZqwertyuiopasdfghjklzxcvbnm0123456789~`!@#$%^&*()_+-=;':""<>?/.,|\\œ∑®†¥øπ“‘«åß∂ƒ©˙∆˚¬…æΩ≈ç√∫µ≤≥÷！@#￥%……&*（）——+？》《。，‘“；：}{】【{}[]+——）（*&……%￥#@！~·"

///Test Data
#define MPWidth(x) ceilf((x) * (UIScreen.mainScreen.bounds.size.width / 375.0))
#define MPHeight(x) ceilf((x) * (UIScreen.mainScreen.bounds.size.width / 375.0))
#define MPFontSize(R) [UIFont fontWithName:@"PingFangSC-Regular" size:MPWidth(R)]
#define MJWeakSelf __weak typeof(self) weakSelf = self;
@interface MPTextField : UITextField

- (void)rightViewWithEyeAndCustumView:(UIView *)custumView;

@property (nonatomic, assign) BOOL hanzLimit;
@property(nonatomic,assign) BOOL fk;

@end
