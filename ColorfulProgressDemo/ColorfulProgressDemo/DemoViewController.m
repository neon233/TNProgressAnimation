//
//  DemoViewController.m
//  ColorfulProgressDemo
//
//  Created by neon on 2017/3/6.
//  Copyright © 2017年 neon. All rights reserved.
//

#import "DemoViewController.h"
#import "PercentCircleView.h"
@interface DemoViewController () <CALayerDelegate>
@property (nonatomic,strong) PercentCircleView *circleView;
@end

@implementation DemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.circleView];
    [self.circleView.layer setNeedsDisplay];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)beganAction:(id)sender {
    _circleView.maxRage = 0.7;
    _circleView.countValue = 233;
    [self.circleView.layer setNeedsDisplay];
}



#pragma mark setter&getter
- (PercentCircleView *)circleView {
    if (!_circleView) {
        _circleView = [[PercentCircleView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-180)];
        _circleView.maxRage = 0.0;
        _circleView.countValue = 0;
//        [_circleView drawCircleWithMaxRage:0.9 withNumber:430];
    }
    return _circleView;
}
@end
