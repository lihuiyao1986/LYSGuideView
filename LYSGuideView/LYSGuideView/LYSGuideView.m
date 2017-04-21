//
//  LYSGuideView.m
//  LYSGuideView
//
//  Created by jk on 2017/4/21.
//  Copyright © 2017年 Goldcard. All rights reserved.
//

#import "LYSGuideView.h"


@implementation LYSGuideInfoModel


@end

#if defined(__IPHONE_10_0) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0)
@interface LYSGuideView ()<CAAnimationDelegate>{
#else
@interface LYSGuideView (){
#endif
    CAShapeLayer * _guideLayer;
    UIView *_showView;
    CAShapeLayer *_maskLayer;
    CAShapeLayer *_shapeLayer;
}

#pragma mark - 动画时间
@property(nonatomic,assign)NSTimeInterval duration;

#pragma mark - 消失的时间
@property(nonatomic,assign)NSTimeInterval dismissTime;

#pragma mark - 引导线的宽度
@property(nonatomic,assign)CGFloat guidelineW;

#pragma mark - 引导线的高度
@property(nonatomic,assign)CGFloat guidelineH;

#pragma mark - 描述
@property(nonatomic,copy)NSString *desc;

#pragma mark - 图片
@property(nonatomic,strong)UIImage *descImage;

#pragma mark - 目标点
@property(nonatomic,assign)CGPoint targetPoint;

#pragma mark - 当前的点
@property(nonatomic,assign)NSUInteger selectedIndx;

#pragma mark - 是否是正在显示
@property(nonatomic,assign)BOOL isShowing;

@end

@implementation LYSGuideView


- (instancetype)init
{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        [self initConfig];
    }
    return self;
}

#pragma mark - 初始化配置
-(void)initConfig{
    [self setDefaults];
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
}

#pragma mark - 转换位置
-(CGPoint)convertPoint:(CGPoint)position{
    CGPoint result = position;
    if ((position.y - self.maskRadius - self.spacing) <= 0) {
        result.y = self.maskRadius + self.spacing;
    }
    if ((position.y + self.maskRadius + self.spacing) >= [UIScreen mainScreen].bounds.size.height) {
        result.y = [UIScreen mainScreen].bounds.size.height - self.maskRadius - self.spacing;
    }
    if ((position.x - self.maskRadius - self.spacing) <= 0) {
        result.x = self.maskRadius + self.spacing;
    }
    if ((position.x + self.maskRadius + self.spacing) >= [UIScreen mainScreen].bounds.size.width) {
        result.x = [UIScreen mainScreen].bounds.size.width - self.maskRadius - self.spacing;
    }
    return result;
}

#pragma mark - 创建引导线
-(CAShapeLayer*)createGuideLine{
    
    UIBezierPath *guidePath = [UIBezierPath bezierPath];
    [guidePath moveToPoint:CGPointMake(0, 0)];
    [guidePath addCurveToPoint: CGPointMake(34.21, 51.21) controlPoint1: CGPointMake(-0.75, 0) controlPoint2: CGPointMake(4.24, 51.21)];
    [guidePath addCurveToPoint: CGPointMake(50.02, 35.75) controlPoint1: CGPointMake(64.17, 51.21) controlPoint2: CGPointMake(50.02, 35.75)];
    [guidePath addCurveToPoint: CGPointMake(34.21, 35.75) controlPoint1: CGPointMake(50.02, 35.75) controlPoint2: CGPointMake(39.2, 28.99)];
    [guidePath addCurveToPoint: CGPointMake(40.87, 64.74) controlPoint1: CGPointMake(29.22, 42.52) controlPoint2: CGPointMake(31.71, 47.35)];
    [guidePath addCurveToPoint: CGPointMake(70, 86) controlPoint1: CGPointMake(50.02, 82.13) controlPoint2: CGPointMake(70, 86)];
    
    CAShapeLayer *guideLayer = [CAShapeLayer layer];
    guideLayer.path = guidePath.CGPath;
    guideLayer.lineWidth = self.lineWidth;
    guideLayer.lineCap = kCALineCapRound;
    guideLayer.strokeColor = self.lineColor.CGColor;
    guideLayer.fillColor = [UIColor clearColor].CGColor;
    guideLayer.anchorPoint = CGPointMake(0, 0);
    guideLayer.lineDashPattern = @[@10,@5];
    return guideLayer;
}

#pragma mark - 创建遮罩
-(void)createMaskInPosition:(CGPoint)position{
    
    [_shapeLayer removeFromSuperlayer];
    [_maskLayer removeFromSuperlayer];
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRect:self.bounds];
    UIBezierPath *roundPath = [UIBezierPath bezierPathWithArcCenter:position radius:self.maskRadius startAngle:0 endAngle:2 * M_PI clockwise:NO];
    [maskPath appendPath:roundPath];
    
    _maskLayer = [CAShapeLayer layer];
    _maskLayer.path = maskPath.CGPath;
    _maskLayer.strokeColor = [UIColor clearColor].CGColor;
    _maskLayer.fillColor = [UIColor whiteColor].CGColor;
    [self.layer setMask:_maskLayer];
    
    _shapeLayer = [CAShapeLayer layer];
    _shapeLayer.path = roundPath.CGPath;
    _shapeLayer.lineWidth = self.lineWidth;
    _shapeLayer.lineCap = kCALineCapRound;
    _shapeLayer.strokeColor = self.lineColor.CGColor;
    _shapeLayer.fillColor = [UIColor clearColor].CGColor;
    _shapeLayer.lineDashPattern = @[@10,@5];
    _shapeLayer.lineDashPhase = 0;
    [self.layer addSublayer:_shapeLayer];
}


-(CGPoint)calGuideLinePosition:(CGPoint)position{
    
    CGFloat x = position.x, y = position.y;
    if (y > [UIScreen mainScreen].bounds.size.height / 2) {
        y -= (self.maskRadius + self.spacing);
        _guideLayer.transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
        if (x <= ([UIScreen mainScreen].bounds.size.width / 2)) {
            _guideLayer.transform = CATransform3DMakeRotation(M_PI, 1, 0, 0);
        }
    } else {
        y += (self.maskRadius + self.spacing);
        if (x > ([UIScreen mainScreen].bounds.size.width / 2)) {
            _guideLayer.transform = CATransform3DMakeRotation(M_PI, 0, 1, 0);
        }
    }
    position = CGPointMake(x, y);
    return position;
}

#pragma mark - 设置默认值
-(void)setDefaults{
    
    _guidelineH = 86;
    _guidelineW = 70;
    _duration = 0.5;
    _dismissTime = 0.3;
    
    _maskRadius = 10.f;
    _lineWidth = 3.f;
    _lineColor = [UIColor whiteColor];
    _descColor = [UIColor whiteColor];
    _descFont = [UIFont systemFontOfSize:14];
    _spacing = 5.f;
    _dismissOnTouch = YES;
    _type = LYSGuideViewShowTypeTop;
    
    _targetPoint = CGPointZero;

}

#pragma mark - 显示
- (void)show {
    if (self.items.count > 0) {
        NSEnumerator *windowEnnumtor = [UIApplication sharedApplication].windows.reverseObjectEnumerator;
        for (UIWindow *window in windowEnnumtor) {
            BOOL isOnMainScreen = window.screen == [UIScreen mainScreen];
            BOOL isVisible      = !window.hidden && window.alpha > 0;
            BOOL isLevelNormal  = window.windowLevel == UIWindowLevelNormal;
            
            if (isOnMainScreen && isVisible && isLevelNormal) {
                [window addSubview:self];
                [self addStrokeAnimWithAnimation:YES item:self.items[self.selectedIndx]];
            }
        }
    }
}

- (void)addStrokeAnimWithAnimation:(BOOL)animated item:(LYSGuideInfoModel*)item{
    self.isShowing = YES;
    [_guideLayer removeAllAnimations];
    [_guideLayer removeFromSuperlayer];
    [_showView removeFromSuperview];
    self.descImage = item.descImage;
    self.targetPoint = item.targetPoint;
    self.desc = item.desc;
    self.targetPoint = [self convertPoint:self.targetPoint];
    [self createMaskInPosition:self.targetPoint];
    _guideLayer = [self createGuideLine];
    _guideLayer.borderWidth = 1;
    _guideLayer.borderColor = [UIColor redColor].CGColor;
    _guideLayer.position = [self calGuideLinePosition:self.targetPoint];
    [self.layer addSublayer:_guideLayer];
    CABasicAnimation *strokeAnim = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    strokeAnim.duration = animated ? self.duration : 0;
    strokeAnim.fromValue = @0;
    strokeAnim.toValue = @1;
    strokeAnim.delegate = self;
    strokeAnim.removedOnCompletion = NO;
    [_guideLayer addAnimation:strokeAnim forKey:@"guideLineAnim"];
}

- (void)dismiss {
    if (self) {
        CABasicAnimation *dismissAnim = [CABasicAnimation animationWithKeyPath:@"opacity"];
        dismissAnim.duration = self.dismissTime;
        dismissAnim.delegate = self;
        dismissAnim.toValue = @0;
        dismissAnim.removedOnCompletion = NO;
        dismissAnim.fillMode = kCAFillModeForwards;
        [self.layer addAnimation:dismissAnim forKey:@"dismissAnim"];
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    if (!self.isShowing) {
        if (self.selectedIndx >= self.items.count -1) {
            if(self.dismissOnTouch){
                [self dismiss];
            }
        }else{
            self.selectedIndx = self.selectedIndx + 1;
            [self addStrokeAnimWithAnimation:YES item:self.items[self.selectedIndx]];
        }
    }
}

#pragma mark - custom show view
- (void)addShowView {
    CGFloat maxWidth = ([UIScreen mainScreen].bounds.size.width / 2 - self.guidelineW  - 10);
    UIImageView *descImageView;
    UILabel *textLabel;
    if (_showView) {
        [_showView removeFromSuperview];
        _showView = nil;
    }
    _showView = [[UIView alloc] init];
    _showView.backgroundColor = [UIColor clearColor];
    
    CGSize labelSize;
    if (self.desc) {
        textLabel = [[UILabel alloc] init];
        textLabel.backgroundColor = [UIColor clearColor];
        textLabel.font = self.descFont;
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.text = self.desc;
        textLabel.textColor = self.descColor;
        textLabel.numberOfLines = 0;
        labelSize = [self.desc boundingRectWithSize:CGSizeMake(maxWidth, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : textLabel.font} context:nil].size;
    }
    
    if (self.descImage) {
        descImageView = [[UIImageView alloc] initWithImage:self.descImage];
        descImageView.contentMode = UIViewContentModeCenter;
    }
    
    if (self.type == LYSGuideViewShowTypeTop) {
        _showView.frame = CGRectMake(0, 0, maxWidth, descImageView ? MIN(maxWidth,self.descImage.size.height + labelSize.height) : MIN(maxWidth, labelSize.height));
        if (descImageView) {
            descImageView.frame = CGRectMake(0, labelSize.height, maxWidth, MIN(maxWidth, self.descImage.size.height));
            [_showView addSubview:descImageView];
        }
        if (textLabel) {
            textLabel.frame = CGRectMake(0, 0, labelSize.width, labelSize.height);
            [_showView addSubview:textLabel];
        }
        [self addSubview:_showView];
    } else if (self.type == LYSGuideViewShowTypeBottom) {
        if (descImageView) {
            descImageView.frame = CGRectMake(0, 0, maxWidth, MIN(maxWidth, self.descImage.size.height));
        }
        if (textLabel) {
            textLabel.frame = CGRectMake(0, CGRectGetMaxY(descImageView.frame) + (descImageView ? self.spacing : 0), labelSize.width, labelSize.height);
        }
        _showView.frame = CGRectMake(0, 0, maxWidth, CGRectGetHeight(descImageView.frame) + CGRectGetHeight(textLabel.frame) + (descImageView ? self.spacing : 0));
        if (descImageView) {
            [_showView addSubview:descImageView];
        }
        if (textLabel) {
            [_showView addSubview:textLabel];
        }
        [self addSubview:_showView];
    } else {
        if (textLabel) {
            textLabel.frame = CGRectMake(0, 0, maxWidth, labelSize.height);
        }
        if (descImageView) {
            descImageView.frame = CGRectMake(0, CGRectGetMaxY(textLabel.frame) + (textLabel ? self.spacing : 0), maxWidth, MIN(maxWidth, self.descImage.size.height));
        }
        _showView.frame = CGRectMake(0, 0, maxWidth, CGRectGetHeight(textLabel.frame) + CGRectGetHeight(descImageView.frame) + (textLabel ? self.spacing : 0));
        if (textLabel) {
            [_showView addSubview:textLabel];
        }
        if (descImageView) {
            [_showView addSubview:descImageView];
        }
        [self addSubview:_showView];
    }
    CGPoint showViewOriPosition = [self giveOriginPointForTextWithPosition:[self calGuideLinePosition:self.targetPoint]];
    _showView.layer.position = showViewOriPosition;
    self.isShowing = NO;
}

#pragma mark -
- (CGPoint)giveOriginPointForTextWithPosition:(CGPoint)position {
    CGFloat x = self.targetPoint.x, y = self.targetPoint.y;
    CGFloat label_x = position.x, label_y = position.y;
    CGPoint textPoisition = CGPointZero;
    if (y <= [UIScreen mainScreen].bounds.size.height / 2) {
        if (x <= ([UIScreen mainScreen].bounds.size.width / 2)) {
            label_x += self.guidelineW + self.spacing;
            label_y += self.guidelineH;
            _showView.layer.anchorPoint = CGPointMake(0, 0.5);
        } else {
            label_x -= self.guidelineW + self.spacing;
            label_y += self.guidelineH;
            _showView.layer.anchorPoint = CGPointMake(1, 0.5);
        }
    } else {
        if (x > ([UIScreen mainScreen].bounds.size.width / 2)) {
            label_x -= self.guidelineW + self.spacing;
            label_y -= self.guidelineH;
            _showView.layer.anchorPoint = CGPointMake(1, 0.5);
        } else {
            label_x += self.guidelineW + self.spacing;
            label_y -= self.guidelineH;
            _showView.layer.anchorPoint = CGPointMake(0, 0.5);
        }
    }
    textPoisition = CGPointMake(label_x, label_y);
    return textPoisition;
}


#pragma mark - Core Anim Delegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if ([_guideLayer animationForKey:@"guideLineAnim"]) {
        [_guideLayer removeAllAnimations];
        [self addShowView];
    }
    if ([self.layer animationForKey:@"dismissAnim"]) {
        [_guideLayer removeFromSuperlayer];
        [self.layer removeAllAnimations];
        [self removeFromSuperview];
    }
}


-(void)dealloc{
    NSLog(@"%@ was dealloc",NSStringFromClass([self class]));
}
@end
