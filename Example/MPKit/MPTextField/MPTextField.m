//
//  MPTextField.m
//  MoponChinaFilm
//
//  Created by Mopon on 16/10/3.
//  Copyright © 2016年 Mopon. All rights reserved.
//

#import "MPTextField.h"
#import "UIColor+YYQExtension.h"
#import "UIButton+YYQExtension.h"
#import "UIView+YYQExtension.h"
#import "NSObject+YYQExtension.h"



@interface MPTextField ()<UITextFieldDelegate>

/** 清除按钮 */
@property (nonatomic ,strong) UIButton *clearBtn;

@end

@implementation MPTextField

- (instancetype)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.delegate = self;
        [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(textDidChange) name:UITextFieldTextDidChangeNotification object:nil];
        self.clearsOnBeginEditing = NO;
        
    }
    return self;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    if (self.clearBtn) {
        self.clearBtn.hidden = !self.hasText;
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    self.clearBtn.hidden = YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (!_hanzLimit) {
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ALPHANUM] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        NSString *comcatstr = [textField.text stringByReplacingCharactersInRange:range withString:string];
        
        NSInteger caninputlen = 20 - comcatstr.length;
        
        if (caninputlen >= 0)
        {
            return [string isEqualToString:filtered];
        }
        else
        {
            NSInteger len = string.length + caninputlen;
            //防止当text.length + caninputlen < 0时，使得rg.length为一个非法最大正数出错
            NSRange rg = {0,MAX(len,0)};
            
            if (rg.length > 0)
            {
                NSString *s = [string substringWithRange:rg];
                
                [textField setText:[textField.text stringByReplacingCharactersInRange:range withString:s]];
            }
            return NO;
        }
        return [string isEqualToString:filtered];
    }else if(_fk){
       
        BOOL y = YES;
        if (string.length == 0) return YES;
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ALLBUTCHINESE] invertedSet];
        /**< 分离出要替换的中文字符 */
        NSString *filtered = [[string/*annotation:replacementString*/ componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        /**< 替换后的字符串 */
        NSString *comcatstr = [textField.text stringByReplacingCharactersInRange:range withString:string];
        
        NSInteger caninputlen = 30 - comcatstr.length; /**< 超出30位的长度,负数越小则超出越长 */
        
        if (caninputlen < 0){
            /**< 替换后的字符串已经大于了30位,caniputlen < 0 */
            NSInteger len = string.length + caninputlen;
            //防止当text.length + caninputlen < 0时，使得rg.length为一个非法最大正数出错
            NSRange rg = {0,MAX(len,0)};
            
            if (rg.length > 0){
                NSString *s = [string substringWithRange:rg];
//#error /**< need to understand */
                [textField setText:[textField.text stringByReplacingCharactersInRange:range withString:s]];
            }
        }
        y = [string isEqualToString:filtered];
        
        if (existedLength - selectedLength + replaceLength > 30) {
            y = NO;
        }
        
        return y;

    }else{
        return YES;
    }
    
    
}


- (void)drawRect:(CGRect)rect {
    [self setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15]];
    [self setTintColor:[UIColor colorWithHexColorString:@"3b6dea"]];
    [self setBorderStyle:UITextBorderStyleNone];
    [self setAutocorrectionType:UITextAutocorrectionTypeNo];
    [self setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [self setTextColor:[UIColor colorWithHexColorString:@"282828"]];
    self.leftViewMode = UITextFieldViewModeAlways;
    
    self.rightViewMode = UITextFieldViewModeAlways;
    
    if (self.attributedPlaceholder) {
        self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeholder attributes:@{NSForegroundColorAttributeName: [UIColor colorWithHexColorString:@"999999"] ,NSFontAttributeName :MPFontSize(14)}];
    }
    
    
    [self setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [self setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    
    /**< 画出底部灰线 */
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, rect.size.height)];
    [path addLineToPoint:CGPointMake(rect.size.width, rect.size.height)];
    [path setLineWidth:0.5];
    [[UIColor colorWithHexColorString:@"e1e1e1"] set];
    [path stroke];
}

- (void)rightViewWithBtn{

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithHexColorString:@"ff2c76"] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"pupeo"] forState:UIControlStateHighlighted];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    btn.titleLabel.font = MPFontSize(14);
    [btn sizeToFit];
}

-(void)rightViewWithEye{
    
    MJWeakSelf;
    self.secureTextEntry = YES;
    UIButton *eyeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [eyeBtn setImage:[UIImage imageNamed:@"passwordUnshown"] forState:UIControlStateNormal];
    [eyeBtn setImage:[UIImage imageNamed:@"passwordShow"] forState:UIControlStateSelected];
    [eyeBtn sizeToFit];
    [eyeBtn addTouchHandle:^(UIButton *btn) {
        btn.selected = !btn.selected;
        weakSelf.secureTextEntry = !btn.selected;
    }];
}

- (void)rightViewWithEyeAndCustumView:(UIView *)custumView{

    MJWeakSelf;
    UIButton *clearBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [clearBtn setImage:[UIImage imageNamed:@"chongshu"] forState:UIControlStateNormal];
    [clearBtn addTouchHandle:^(UIButton *btn) {
        weakSelf.text = nil;
        btn.hidden = YES;
        [NSNotificationCenter.defaultCenter postNotificationName:UITextFieldTextDidChangeNotification object:nil];
    }];
    [clearBtn sizeToFit];
    self.clearBtn = clearBtn;
    
    self.clearBtn.hidden = YES;
    
    UIView *bgView = [[UIView alloc]init];
    [bgView addSubview:custumView];
    [bgView addSubview:clearBtn];
    
    clearBtn.origin = CGPointMake(0, self.height/2 - clearBtn.height/2);
    custumView.origin = CGPointMake(clearBtn.maxX + MPWidth(15), self.height/2 - custumView.height/2);
    bgView.bounds = CGRectMake(0, 0, custumView.width + MPWidth(15) +clearBtn.width, self.height-1);
    self.rightView = bgView;
}

- (void)setPlaceholder:(NSString *)placeholder{

    [super setPlaceholder:placeholder];
    if (![placeholder isValidString]) {
        return;
    }
    self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeholder attributes:@{NSForegroundColorAttributeName: [UIColor colorWithHexColorString:@"999999"] ,NSFontAttributeName :MPFontSize(14)}];
}

- (void)textDidChange{

    if (self.clearBtn) {
        if (self.editing) {
            
            self.clearBtn.hidden = !self.hasText;
        }
    }
}

- (void)dealloc
{
    [NSNotificationCenter.defaultCenter removeObserver:self];
}



@end
