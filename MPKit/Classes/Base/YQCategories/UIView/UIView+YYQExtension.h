//
//  UIView+YYQExtension.h
//
//  Created by 尹永奇 on 16/6/15.
//  Copyright © 2016年 尹永奇. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    UIViewBorderDirectionTop,
    UIViewBorderDirectionLeft,
    UIViewBorderDirectionBottom,
    UIViewBorderDirectionRight,
} UIViewBorderDirection;

typedef NS_ENUM(NSInteger, MPCornerRadiusType) {
    MPCornerRadiusNone   = 0,
    MPCornerRadiusTopLeft    = 1 << 0,
    MPCornerRadiusTopRight   = 1 << 1,
    MPCornerRadiusBottomLeft = 1 << 2,
    MPCornerRadiusBottomRight  = 1 << 3,
    MPCornerRadiusAll    = MPCornerRadiusTopLeft | MPCornerRadiusTopRight | MPCornerRadiusBottomLeft | MPCornerRadiusBottomRight
};

@interface UIWindow (CurrentViewController)
/*!
 @method currentViewController
 @return Returns the topViewController in stack of topMostController.
 */
+ (UIViewController*)zf_currentViewController;

@end

@interface UIView (YYQExtension)

/**
 *  删除所有子view
 *  不能用在view的 drawRect方法
 */
-(void)removeAllSubviews;

/**
 *  添加边框
 *
 *  @param borderColor 边框颜色
 *  @param borderWidth 边框宽度
 */
-(void)setBorderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth;

/**
 *  给视图的一边添加边框
 *
 *  @param direction    方向
 *  @param borderColor 边框颜色
 *  @param borderWidth 边框高度
 */
-(void)setBorderWithPosition:(UIViewBorderDirection)direction color:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth;

/**
 *  给视图截图
 *
 *  @return 视图的截图
 */
-(UIImage *)snapshotImage;

/**
 *  根据给定frame获取视图截图
 *
 *  @param frame 要截取的frame
 */
-(UIImage *)snapshotImageWithFrame:(CGRect)frame;

/**
 *  调试（给view添加个边框颜色方便修改及查看）
 */
-(void)debug:(UIColor *)color width:(CGFloat)width;

/**
 *  移除多个视图
 */
+(void)removeViews:(NSArray *)views;

/**
 *  获取view所在的控制器
 */
- (UIViewController*)viewController;

/**
 获取响应某个方法的子视图,可能返回ni

 @param selector 方法编号
 @return 子视图
 */
- (UIView *)subViewWithResponseToSelector:(SEL)selector;

/**
 图片设置圆角

 @param radius 圆角数
 @param rectCorner 哪一边
 */
- (void)hq_setCornerRadius:(CGFloat)radius withRectCorners:(UIRectCorner)rectCorner;


/**
 设置默认主题渐变色,粉色渐变
 */
- (void)setMainThemeGradientColor;

/**
 给视图设置渐变层，必须在该视图设置frame后调用!

 @param startColor 起始颜色
 @param endColor 结束颜色
 */
- (void)setGradientLayerFromColor:(UIColor *)startColor toColor:(UIColor *)endColor;

/**
 生成渐变层layer

 @param fromColor 起始颜色
 @param toColor 结束颜色
 @return 渐变层
 */
- (CAGradientLayer *)setGradualChangingColorfromColor:(UIColor *)fromColor toColor:(UIColor *)toColor fromPoint:(CGPoint)fromPoint toPoint:(CGPoint)toPoint;

/**
 设置描边

 @param top 上
 @param left 下
 @param bottom 左
 @param right 右
 @param color 颜色
 @param width 宽度
 */
- (void)setBorderWithTop:(BOOL)top left:(BOOL)left bottom:(BOOL)bottom right:(BOOL)right borderColor:(UIColor *)color borderWidth:(CGFloat)width;

/**
 获取视图的子视图

 @param className <#className description#>
 @return <#return value description#>
 */
- (UIView*)subViewOfClassName:(NSString*)className;


- (void)setUpVerticalGradientLayerFromColor:(UIColor *)startColor toColor:(UIColor *)endColor;

/// 设置四个角中某几个角为圆角(否则为反向圆角)
/// @param radius 半径
/// @param size 图的大小
/// @param rectCorner 角的枚举
- (void)setCornerRadiusWithReverseRadius:(CGFloat)radius viewSize:(CGSize)size corners:(MPCornerRadiusType)rectCorner;

@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat maxX;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat maxY;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, assign) CGFloat radius;
@end
