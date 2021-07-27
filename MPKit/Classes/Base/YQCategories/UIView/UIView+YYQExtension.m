//
//  UIView+YYQExtension.h
//
//  Created by 尹永奇 on 16/6/15.
//  Copyright © 2016年 尹永奇. All rights reserved.
//

#import "UIView+YYQExtension.h"
#import "UIColor+YYQExtension.h"

static NSString *kDefaultLayerName = @"kDefaultGradientLayer";

@implementation UIWindow (CurrentViewController)

+ (UIViewController *)zf_currentViewController; {
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    UIViewController *topViewController = [window rootViewController];
    while (true) {
        if (topViewController.presentedViewController) {
            topViewController = topViewController.presentedViewController;
        } else if ([topViewController isKindOfClass:[UINavigationController class]] && [(UINavigationController*)topViewController topViewController]) {
            topViewController = [(UINavigationController *)topViewController topViewController];
        } else if ([topViewController isKindOfClass:[UITabBarController class]]) {
            UITabBarController *tab = (UITabBarController *)topViewController;
            topViewController = tab.selectedViewController;
        } else {
            break;
        }
    }
    return topViewController;
}

@end

@implementation UIView (YYQExtension)

-(void)removeAllSubviews{
    
    while (self.subviews.count) {
        [self.subviews.lastObject removeFromSuperview];
    }
}

-(void)setBorderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth{
    CALayer *layer = self.layer;
    layer.borderColor = borderColor.CGColor;
    layer.borderWidth = borderWidth;
}

-(void)setBorderWithPosition:(UIViewBorderDirection)direction color:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth{
    
    UIView *borderLine = [[UIView alloc]init];
    borderLine.backgroundColor = borderColor;
    [self addSubview:borderLine];
    borderLine.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *views=NSDictionaryOfVariableBindings(borderLine);
    NSDictionary *metrics=@{@"w":@(borderWidth),@"y":@(self.height - borderWidth),@"x":@(self.width - borderWidth)};
    
    
    NSString *vfl_H=@"";
    NSString *vfl_W=@"";
    
    //上
    if(UIViewBorderDirectionTop==direction){
        vfl_H=@"H:|-0-[line]-0-|";
        vfl_W=@"V:|-0-[line(==w)]";
    }
    
    //左
    if(UIViewBorderDirectionLeft==direction){
        vfl_H=@"H:|-0-[line(==w)]";
        vfl_W=@"V:|-0-[line]-0-|";
    }
    
    //下
    if(UIViewBorderDirectionBottom==direction){
        vfl_H=@"H:|-0-[line]-0-|";
        vfl_W=@"V:[line(==w)]-0-|";
    }
    
    //右
    if(UIViewBorderDirectionRight==direction){
        vfl_H=@"H:|-x-[line(==w)]";
        vfl_W=@"V:|-0-[line]-0-|";
    }
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl_H options:0 metrics:metrics views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl_W options:0 metrics:metrics views:views]];
}

-(UIImage *)snapshotImage{
    //开启图形上下文
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, 0);
    //获取当前上下文并把view的layer渲染到图形上下文
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    //从当前上下文获取截图
    UIImage *snapImage = UIGraphicsGetImageFromCurrentImageContext();
    //关闭图形上下文
    UIGraphicsEndImageContext();
    return snapImage;
}

-(UIImage *)snapshotImageWithFrame:(CGRect)frame{

    UIImage *image = [self snapshotImage];
    CGImageRef cgImageRef = CGImageCreateWithImageInRect(image.CGImage, frame);
    
    UIImage *snapImage = [UIImage imageWithCGImage:cgImageRef];
    CGImageRelease(cgImageRef);
    return snapImage;
}

-(void)debug:(UIColor *)color width:(CGFloat)width{
    [self setBorderColor:color borderWidth:width];
}

+(void)removeViews:(NSArray *)views{
    //在主线程移除需要移除的视图数组
    dispatch_async(dispatch_get_main_queue(), ^{
        for (UIView *subView in views) {
                [subView removeFromSuperview];
        }
    });
}

-(UIViewController *)viewController{

    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

- (UIView *)subViewWithResponseToSelector:(SEL)selector
{
    UIView *resultView = nil;
    for(UIView *subView in self.subviews)
    {
        if([subView respondsToSelector:selector])
        {
            resultView = subView;
        }
        
        if([subView subViewWithResponseToSelector:selector])
        {
            resultView = [subView subViewWithResponseToSelector:selector];
        }
    }
    return resultView;

}

#pragma mark -- set corner radius
- (void)hq_setCornerRadius:(CGFloat)radius withRectCorners:(UIRectCorner)rectCorner
{
    CGRect bounds = self.bounds;
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:bounds byRoundingCorners:rectCorner cornerRadii:CGSizeMake(radius,radius)];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
    
}

- (void)setMainThemeGradientColor{
    [self setGradientLayerFromColor:[UIColor colorWithHexColorString:@"fe6c8b"] toColor:[UIColor colorWithHexColorString:@"ff2c8a"]];
}

- (void)setUpVerticalGradientLayerFromColor:(UIColor *)startColor toColor:(UIColor *)endColor{
    NSMutableArray *subGradientLayers = NSMutableArray.array;
    [self.layer.sublayers enumerateObjectsUsingBlock:^(CALayer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if([obj.name isEqualToString:kDefaultLayerName]){
            [subGradientLayers addObject:obj];
        }
    }];
    [subGradientLayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    [self.layer insertSublayer:[self setGradualChangingColorfromColor:startColor toColor:endColor fromPoint:CGPointMake(0, 1) toPoint:CGPointMake(0, 0)] atIndex:0];
}

- (void)setGradientLayerFromColor:(UIColor *)startColor toColor:(UIColor *)endColor{
    
    NSMutableArray *subGradientLayers = NSMutableArray.array;
    [self.layer.sublayers enumerateObjectsUsingBlock:^(CALayer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if([obj.name isEqualToString:kDefaultLayerName]){
            [subGradientLayers addObject:obj];
        }
    }];
    [subGradientLayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    [self.layer insertSublayer:[self setGradualChangingColorfromColor:startColor toColor:endColor fromPoint:CGPointMake(0, 1) toPoint:CGPointMake(1, 1)] atIndex:0];
}

- (CAGradientLayer *)setGradualChangingColorfromColor:(UIColor *)fromColor toColor:(UIColor *)toColor fromPoint:(CGPoint)fromPoint toPoint:(CGPoint)toPoint{
    
    //    CAGradientLayer类对其绘制渐变背景颜色、填充层的形状(包括圆角)
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = self.bounds;
    gradientLayer.name = kDefaultLayerName;
    //  创建渐变色数组，需要转换为CGColor颜色
    gradientLayer.colors = @[(__bridge id)fromColor.CGColor,(__bridge id)toColor.CGColor];
    
    //  设置渐变颜色方向，左上点为(0,0), 右下点为(1,1)
    gradientLayer.startPoint = fromPoint;
    gradientLayer.endPoint = toPoint;
    
    //  设置颜色变化点，取值范围 0.0~1.0
    gradientLayer.locations = @[@0,@1];
    
    return gradientLayer;
}

- (void)setBorderWithTop:(BOOL)top left:(BOOL)left bottom:(BOOL)bottom right:(BOOL)right borderColor:(UIColor *)color borderWidth:(CGFloat)width
{
    if (top) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, 0, self.width, width);
        layer.backgroundColor = color.CGColor;
        [self.layer addSublayer:layer];
    }
    if (left) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, 0, width, self.height);
        layer.backgroundColor = color.CGColor;
        [self.layer addSublayer:layer];
    }
    if (bottom) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, self.height - width, self.width, width);
        layer.backgroundColor = color.CGColor;
        [self.layer addSublayer:layer];
    }
    if (right) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(self.width - width, 0, width, self.height);
        layer.backgroundColor = color.CGColor;
        [self.layer addSublayer:layer];
    }
}


- (void)setCornerRadiusWithReverseRadius:(CGFloat)radius viewSize:(CGSize)size corners:(MPCornerRadiusType)rectCorner {
    CGFloat width = size.width;
    CGFloat height = size.height;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGPoint startPoint = CGPointMake(0, 0);
    [path moveToPoint:startPoint];
    
    if(rectCorner & MPCornerRadiusTopLeft) {
        [path addArcWithCenter:CGPointMake(radius, radius) radius:radius startAngle:M_PI_2 * 2 endAngle:M_PI_2 * 3  clockwise:YES];
    } else {
        [path addArcWithCenter:CGPointMake(0, 0) radius:radius startAngle:M_PI_2 endAngle:0  clockwise:NO];
    }
    
    if(rectCorner & MPCornerRadiusTopRight) {
        [path addArcWithCenter:CGPointMake(width - radius, radius) radius:radius startAngle:-M_PI_2 endAngle:0 clockwise:YES];
    } else {
        [path addArcWithCenter:CGPointMake(width, 0) radius:radius startAngle:-M_PI_2*2 endAngle:(M_PI_2 ) clockwise:NO];
    }
    
    
    if(rectCorner & MPCornerRadiusBottomRight) {
        [path addArcWithCenter:CGPointMake(width - radius, height-radius) radius:radius startAngle:0 endAngle:M_PI_2 clockwise:YES];
    } else {
        [path addArcWithCenter:CGPointMake(width, height) radius:radius startAngle:-M_PI_2 endAngle:-M_PI_2*2  clockwise:NO];
    }
    
    if(rectCorner & MPCornerRadiusBottomLeft) {
        [path addArcWithCenter:CGPointMake(0 + radius, height-radius) radius:radius startAngle:M_PI_2 endAngle:M_PI_2*2  clockwise:YES];
    } else {
        [path addArcWithCenter:CGPointMake(0, height) radius:radius startAngle:0 endAngle:-M_PI_2  clockwise:NO];
    }
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = path.CGPath;
    
    self.layer.mask = maskLayer;
    
}

- (UIView*)subViewOfClassName:(NSString*)className {
    for (UIView* subView in self.subviews) {
        if ([NSStringFromClass(subView.class) isEqualToString:className]) {
            return subView;
        }
        
        UIView* resultFound = [subView subViewOfClassName:className];
        if (resultFound) {
            return resultFound;
        }
    }
    return nil;
}

-(CGFloat)x{
    return self.frame.origin.x;
}

-(void)setX:(CGFloat)x{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame  =frame;
}

-(CGFloat)maxX{
    return self.frame.origin.x +self.frame.size.width;
}

-(void)setMaxX:(CGFloat)maxX{
    CGRect frame = self.frame;
    frame.origin.x = maxX - frame.size.width;
    self.frame = frame;
}

-(CGFloat)y{
    return self.frame.origin.y;
}

-(void)setY:(CGFloat)y{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

-(CGFloat)maxY{
    return self.frame.origin.y +self.frame.size.height;
}

-(void)setMaxY:(CGFloat)maxY{
    CGRect frame = self.frame;
    frame.origin.y = maxY - frame.size.height;
    self.frame = frame;
}

-(CGFloat)width{
    return self.frame.size.width;
}

-(void)setWidth:(CGFloat)width{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

-(CGFloat)height{
    return self.frame.size.height;
}

-(void)setHeight:(CGFloat)height{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

-(CGFloat)centerX{
    return self.center.x;
}

-(void)setCenterX:(CGFloat)centerX{
    self.center = CGPointMake(centerX, self.center.y);
}

-(CGFloat)centerY{
    return self.center.y;
}

-(void)setCenterY:(CGFloat)centerY{
    self.center = CGPointMake(self.center.x, centerY);
}

-(CGPoint)origin{
    return self.frame.origin;
}

-(void)setOrigin:(CGPoint)origin{
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

-(CGSize)size{
    return self.frame.size;
}

-(void)setSize:(CGSize)size{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

-(void)setRadius:(CGFloat)radius{
    if (radius <= 0) radius = self.frame.size.width *.5f;
    self.layer.cornerRadius = radius;
    self.layer.masksToBounds = YES;
}

-(CGFloat)radius{
    return self.layer.cornerRadius;
}


@end
