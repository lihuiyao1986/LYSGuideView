//
//  LYSGuideView.h
//  LYSGuideView
//
//  Created by jk on 2017/4/21.
//  Copyright © 2017年 Goldcard. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LYSGuideInfoModel : NSObject

#pragma mark - 描述
@property(nonatomic,copy)NSString *desc;

#pragma mark - 图片
@property(nonatomic,strong)UIImage *descImage;

#pragma mark - 起始点
@property(nonatomic,assign)CGPoint targetPoint;

@end

typedef NS_ENUM(NSUInteger,LYSGuideViewShowType){
    LYSGuideViewShowTypeTop,        ///< 文字在图片上方
    LYSGuideViewShowTypeBottom,     ///< 文字在图片下方
    LYSGuideViewShowTypeAboveImage, ///< 文字浮于图片上面
};


@interface LYSGuideView : UIView

#pragma mark - 遮盖层的半径
@property (nonatomic, assign) CGFloat maskRadius;

#pragma mark - 线条的宽度
@property (nonatomic, assign) CGFloat lineWidth;

#pragma mark - 线条的颜色
@property (nonatomic, strong) UIColor *lineColor;

#pragma mark - 描述文字的颜色
@property (nonatomic, strong) UIColor *descColor;

#pragma mark - 描述文字的字体
@property (nonatomic, strong) UIFont  *descFont;

#pragma mark - 点击是否自动关闭
@property (nonatomic, assign) BOOL dismissOnTouch;

#pragma mark - 类型
@property (nonatomic,assign)LYSGuideViewShowType type;

#pragma mark - 间隔
@property (nonatomic,assign)CGFloat spacing;

#pragma mark - 待显示的数据
@property(nonatomic,copy)NSArray<LYSGuideInfoModel*> *items;

#pragma mark - 显示
- (void)show;

#pragma mark - 关闭
- (void)dismiss;

@end
