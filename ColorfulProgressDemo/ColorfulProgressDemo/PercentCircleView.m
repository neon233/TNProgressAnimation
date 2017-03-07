//
//  PercentCircleView.m
//  ColorfulProgressDemo
//
//  Created by neon on 2017/3/2.
//  Copyright © 2017年 neon. All rights reserved.
//

#import "PercentCircleView.h"


#define CONVERTANGLE(angle) (angle/180.0*M_PI)
#define UIColorFromRGB(rgbValue) ([UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0])


static const NSTimeInterval DURATION = 8.0;
static const CGFloat CIRCLE_RADIUS = 54.0;
static const CGFloat DASHCIRCLE_RADIDUS = 46.0;
static const CGFloat LINEWIDTH = 3.0;
static float displayValue ;

@interface PercentCircleView ()
@property (nonatomic,strong) UIBezierPath *circlepathDash,*shadowPath;
@property (nonatomic,strong) UILabel *countLabel;
@property (nonatomic,strong) CAShapeLayer *progressLayer,*circleDashLayer,*shadowLayer;
@property (nonatomic,strong) CAGradientLayer *colorLayer;
@property (nonatomic,strong) CALayer *pointLayer;
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic) CGPoint centerPoint;
@end
@implementation PercentCircleView



- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.layer.contentsScale = [UIScreen mainScreen].scale;
    
        self.centerPoint = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
        self.circlepathDash = [UIBezierPath bezierPathWithArcCenter:self.centerPoint radius:DASHCIRCLE_RADIDUS startAngle:0 endAngle:M_PI*2  clockwise:YES];
        self.shadowPath = [UIBezierPath bezierPathWithArcCenter:self.centerPoint radius:CIRCLE_RADIUS
                                                     startAngle:CONVERTANGLE(-90) endAngle:CONVERTANGLE(270)  clockwise:YES];
        [self addSubview:self.countLabel];
        [self.layer addSublayer:self.circleDashLayer];
        [self.layer addSublayer:self.shadowLayer];
        [self.layer addSublayer:self.progressLayer];
        [self.layer addSublayer:self.colorLayer];
        [self.layer addSublayer:self.pointLayer];
        
        
        
    }
    return self;
}


- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx {
    [self.timer invalidate];
    [self drawCircleWithMaxRage:self.maxRage withNumber:self.countValue];
}



#pragma mark 绘制进度条 拆分是因为maxRage和countValue随时会更新
- (void)drawCircleWithMaxRage:(CGFloat)maxRage withNumber:(CGFloat)countValue {
    
    [self setClearsContextBeforeDrawing:YES];
#pragma mark 绘制进度条动画
    CGFloat endAngle = maxRage*360-90;
    UIBezierPath *progressPath = [UIBezierPath bezierPathWithArcCenter:self.centerPoint radius:CIRCLE_RADIUS startAngle:CONVERTANGLE(-90)  endAngle:CONVERTANGLE(endAngle) clockwise:YES];
    
    self.progressLayer.path = progressPath.CGPath;
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.fromValue = @0;
    animation.toValue = @1;
    animation.duration = DURATION;
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion= NO;
    [self.progressLayer addAnimation:animation forKey:@"colorAnimation"];
    
    
#pragma mark 绘制进度指示器动画
    CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animation];
    pathAnimation.calculationMode = kCAAnimationPaced;
    pathAnimation.fillMode = kCAFillModeForwards;
    pathAnimation.removedOnCompletion = NO;
    pathAnimation.duration = DURATION;
    pathAnimation.path = progressPath.CGPath;
    pathAnimation.keyPath = @"position";
    pathAnimation.repeatCount = 1;
    [self.pointLayer addAnimation:pathAnimation forKey:@"pointAnimation"];
    
#pragma mark 绘制数字跳动效果（感觉这一部分性能不够好，有时间优化这一块
    __weak typeof(self) weakself = self;
    displayValue = 0;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.184 repeats:YES block:^(NSTimer * _Nonnull timer) {
        displayValue += weakself.countValue/((1/0.184)*DURATION);
        weakself.countLabel.text = [NSString stringWithFormat:@"%.2f",displayValue];
        if (displayValue >=weakself.countValue) {
            [timer invalidate];
            timer = nil;
            weakself.countLabel.text = [NSString stringWithFormat:@"%.2f",weakself.countValue];
        }
    }];
    
}

#pragma mark setter & getter
- (UILabel *)countLabel {
    if (!_countLabel) {
        _countLabel = [[UILabel alloc]initWithFrame:self.bounds];
        _countLabel.backgroundColor = [UIColor whiteColor];
        _countLabel.textColor = [UIColor orangeColor];
        _countLabel.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        _countLabel.textAlignment = NSTextAlignmentCenter;
        _countLabel.font = [UIFont fontWithName:@"Courier New bold" size:22];
    }
    return _countLabel;
}

- (CAShapeLayer *)progressLayer {
    if (!_progressLayer) {
        _progressLayer = [CAShapeLayer layer];
        _progressLayer.strokeColor = [UIColor blueColor].CGColor;
        _progressLayer.fillColor = [UIColor clearColor].CGColor;
        _progressLayer.strokeStart = 0;
        _progressLayer.strokeEnd = 1;
        _progressLayer.frame = self.frame;
        _progressLayer.lineCap = @"round";
        _progressLayer.lineWidth = LINEWIDTH;
    }
    return _progressLayer;
}

- (CAGradientLayer *)colorLayer {
    if (!_colorLayer) {
        _colorLayer = [CAGradientLayer layer];
        _colorLayer.colors = @[(__bridge id)UIColorFromRGB(0x7cc8ff).CGColor,(__bridge id)UIColorFromRGB(0xff656a).CGColor];
        _colorLayer.startPoint = CGPointMake(0, 0.5);
        _colorLayer.endPoint = CGPointMake(0.5, 1);
        _colorLayer.frame = self.frame;
        _colorLayer.mask = self.progressLayer;
    }
    return _colorLayer;
}

- (CALayer *)pointLayer {
    if (!_pointLayer) {
        _pointLayer= [CALayer layer];
        _pointLayer.backgroundColor = [UIColor orangeColor].CGColor;
        _pointLayer.frame = CGRectMake(0, 0, 10, 10);
        _pointLayer.cornerRadius = 5;
    }
    return _pointLayer;
}


- (CAShapeLayer *)circleDashLayer {
    if (!_circleDashLayer) {
        _circleDashLayer = [CAShapeLayer layer];
        _circleDashLayer.strokeColor =  UIColorFromRGB(0xff656a).CGColor;
        _circleDashLayer.fillColor = [UIColor clearColor].CGColor;
        _circleDashLayer.lineWidth = LINEWIDTH;
        _circleDashLayer.path = self.circlepathDash.CGPath;
        _circleDashLayer.lineDashPhase = 2;
        [_circleDashLayer setLineDashPattern:
         [NSArray arrayWithObjects:[NSNumber numberWithInt:2],
          [NSNumber numberWithInt:6],nil]];
    }
    return _circleDashLayer;
}

- (CAShapeLayer *)shadowLayer {
    if (!_shadowLayer) {
        _shadowLayer = [CAShapeLayer layer];
        _shadowLayer.path = self.shadowPath.CGPath;
        _shadowLayer.lineWidth = LINEWIDTH;
        _shadowLayer.lineCap = @"round";
        _shadowLayer.strokeColor = UIColorFromRGB(0xf1f1f1).CGColor;
        _shadowLayer.fillColor = [UIColor clearColor].CGColor;
    }
    return _shadowLayer;
}

- (NSTimer *)timer {
    if (!_timer) {
        __weak typeof(self) weakself = self;
        static float displayValue = 0;
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.125 repeats:YES block:^(NSTimer * _Nonnull timer) {
            displayValue += weakself.countValue/((1/0.125)*DURATION);
            NSLog(@"displa--》%f",displayValue);
            weakself.countLabel.text = [NSString stringWithFormat:@"%.2f",displayValue];
            if (displayValue >=weakself.countValue) {
                [timer invalidate];
                timer = nil;
                weakself.countLabel.text = [NSString stringWithFormat:@"%.2f",weakself.countValue];
            }
        }];
    }
    return _timer;
}



@end

