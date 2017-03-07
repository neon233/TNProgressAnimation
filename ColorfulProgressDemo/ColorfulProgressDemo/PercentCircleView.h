//
//  PercentCircleView.h
//  ColorfulProgressDemo
//
//  Created by neon on 2017/3/2.
//  Copyright © 2017年 neon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PercentCircleView : UIView
@property (nonatomic) CGFloat maxRage;
@property (nonatomic) CGFloat countValue;
- (void)drawCircleWithMaxRage:(CGFloat)maxRage withNumber:(CGFloat)countValue;


@end
