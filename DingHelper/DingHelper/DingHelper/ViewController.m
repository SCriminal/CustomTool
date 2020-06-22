//
//  ViewController.m
//  DingHelper
//
//  Created by 隋林栋 on 2020/4/26.
//  Copyright © 2020 隋林栋. All rights reserved.
//

#import "ViewController.h"
#import "GlobalMethod.h"

#define TIME_DAY_SHOW @"yyyy-MM-dd"
#define TIME_ALL_SHOW @"yyyy-MM-dd HH:mm:ss"
#define TIME_SEC_SHOW @"HH:mm:ss"

#define TIME0 @"08:23:10"
#define TIME1 @"11:30:15"
#define TIME2 @"12:41:00"
#define TIME3 @"18:30:15"


@interface ViewController ()
@property (nonatomic, strong) UILabel *time0;
@property (nonatomic, strong) UILabel *time1;
@property (nonatomic, strong) UILabel *time2;
@property (nonatomic, strong) UILabel *time3;
@property (nonatomic, strong) UILabel *timeCurrent;
@property (nonatomic, strong) UIButton *btnTest;
@property (nonatomic, strong) NSDate *date0;
@property (nonatomic, strong) NSDate *date1;
@property (nonatomic, strong) NSDate *date2;
@property (nonatomic, strong) NSDate *date3;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation ViewController
#pragma mark 懒加载
- (UILabel *)time0{
    if (_time0 == nil) {
        _time0 = [UILabel new];
        _time0.textColor = [UIColor whiteColor];
        _time0.font =  [UIFont systemFontOfSize:18 weight:UIFontWeightRegular];
    }
    return _time0;
}
- (UILabel *)time1{
    if (_time1 == nil) {
        _time1 = [UILabel new];
        _time1.textColor = [UIColor whiteColor];
        _time1.font =  [UIFont systemFontOfSize:18 weight:UIFontWeightRegular];
    }
    return _time1;
}
- (UILabel *)time2{
    if (_time2 == nil) {
        _time2 = [UILabel new];
        _time2.textColor = [UIColor whiteColor];
        _time2.font =  [UIFont systemFontOfSize:18 weight:UIFontWeightRegular];
    }
    return _time2;
}
- (UILabel *)time3{
    if (_time3 == nil) {
        _time3 = [UILabel new];
        _time3.textColor = [UIColor whiteColor];
        _time3.font =  [UIFont systemFontOfSize:18 weight:UIFontWeightRegular];
    }
    return _time3;
}
- (UILabel *)timeCurrent{
    if (_timeCurrent == nil) {
        _timeCurrent = [UILabel new];
        _timeCurrent.backgroundColor = [UIColor blueColor];
        _timeCurrent.textColor = [UIColor whiteColor];
        _timeCurrent.font =  [UIFont systemFontOfSize:18 weight:UIFontWeightRegular];
        _timeCurrent.numberOfLines = 0;
    }
    return _timeCurrent;
}
-(UIButton *)btnTest{
    if (_btnTest == nil) {
        _btnTest = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnTest.tag = 1;
        [_btnTest addTarget:self action:@selector(jumpToDing) forControlEvents:UIControlEventTouchUpInside];
        _btnTest.backgroundColor = [UIColor clearColor];
        _btnTest.titleLabel.font = [UIFont systemFontOfSize:(18)];
        [_btnTest setTitle:@"测试跳转" forState:(UIControlStateNormal)];
        [_btnTest setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
    }
    return _btnTest;
}
- (void)viewDidLoad{
    self.view.backgroundColor = [UIColor grayColor];
    [self addSubView];
    [self timerStart];
}
//添加subview
- (void)addSubView{
    NSString * strDay = [GlobalMethod exchangeDate:[NSDate date] formatter:TIME_DAY_SHOW];
   

    self.date0 = [GlobalMethod exchangeStringToDate:[NSString stringWithFormat:@"%@ %@",strDay,TIME0] formatter:TIME_ALL_SHOW];
    self.date1 = [GlobalMethod exchangeStringToDate:[NSString stringWithFormat:@"%@ %@",strDay,TIME1] formatter:TIME_ALL_SHOW];
    self.date2 = [GlobalMethod exchangeStringToDate:[NSString stringWithFormat:@"%@ %@",strDay,TIME2] formatter:TIME_ALL_SHOW];
    self.date3 = [GlobalMethod exchangeStringToDate:[NSString stringWithFormat:@"%@ %@",strDay,TIME3] formatter:TIME_ALL_SHOW];
    
    self.time0.text = [GlobalMethod exchangeDate:self.date0 formatter:TIME_ALL_SHOW];
    self.time1.text = [GlobalMethod exchangeDate:self.date1 formatter:TIME_ALL_SHOW];
    self.time2.text = [GlobalMethod exchangeDate:self.date2 formatter:TIME_ALL_SHOW];
    self.time3.text = [GlobalMethod exchangeDate:self.date3 formatter:TIME_ALL_SHOW];

    [self.view addSubview:self.time0];
    [self.view addSubview:self.time1];
    [self.view addSubview:self.time2];
    [self.view addSubview:self.time3];
    [self.view addSubview:self.timeCurrent];
//    [self.view addSubview:self.btnTest];
    
    //初始化页面
    [self resetViewWithModel:nil];
}

#pragma mark 刷新view
- (void)resetViewWithModel:(id)model{
    //刷新view
    
    self.time0.frame = CGRectMake(40, 40, 320, 40);
    self.time1.frame = CGRectMake(40, 40*2, 320, 40);
    self.time2.frame = CGRectMake(40, 40*3, 320, 40);
    self.time3.frame = CGRectMake(40, 40*4, 320, 40);
    
    self.timeCurrent.frame = CGRectMake(40, 40*5, 320, 140);
    
    self.btnTest.frame = CGRectMake(40, 40*5+140, 320, 40);
    
}

#pragma mark 定时器相关
- (void)timerStart{
    //开启定时器
    if (_timer == nil) {
        _timer =[NSTimer scheduledTimerWithTimeInterval:6 target:self selector:@selector(timerRun) userInfo:nil repeats:YES];
    }
    
}

- (void)timerRun{
    double interval0 = self.date0.timeIntervalSinceNow;
    double interval1 = self.date1.timeIntervalSinceNow;
    double interval2 = self.date2.timeIntervalSinceNow;
    double interval3 = self.date3.timeIntervalSinceNow;
    
    self.timeCurrent.text = [NSString stringWithFormat:@"%@\n%.f\n%.f\n%.f\n%.f",[GlobalMethod exchangeDate:[NSDate date] formatter:TIME_ALL_SHOW],interval0/60.0,interval1/60.0,interval2/60.0,interval3/60.0];
    
    
    
    if (interval0<0 ) {
        NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + 86400 * 1;
          NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
        NSString * nextDay = [GlobalMethod exchangeDate:newDate formatter:TIME_DAY_SHOW];
        self.date0 = [GlobalMethod exchangeStringToDate:[NSString stringWithFormat:@"%@ %@",nextDay,TIME0] formatter:TIME_ALL_SHOW];
        int min = random()%5;
        self.date0 = [self.date0 dateByAddingTimeInterval:min*60];
        self.time0.text = [GlobalMethod exchangeDate:self.date0 formatter:TIME_ALL_SHOW];
        [self jumpToDing];
        return;
    }
    if (interval1<0 ) {
        NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + 86400 * 1;
          NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
        NSString * nextDay = [GlobalMethod exchangeDate:newDate formatter:TIME_DAY_SHOW];
        self.date1 = [GlobalMethod exchangeStringToDate:[NSString stringWithFormat:@"%@ %@",nextDay,TIME1] formatter:TIME_ALL_SHOW];
        self.time1.text = [GlobalMethod exchangeDate:self.date1 formatter:TIME_ALL_SHOW];
        [self jumpToDing];
        return;
    }
    if (interval2<0 ) {
        NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + 86400 * 1;
          NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
        NSString * nextDay = [GlobalMethod exchangeDate:newDate formatter:TIME_DAY_SHOW];
        self.date2 = [GlobalMethod exchangeStringToDate:[NSString stringWithFormat:@"%@ %@",nextDay,TIME2] formatter:TIME_ALL_SHOW];
        int min = random()%10;
        self.date2 = [self.date2 dateByAddingTimeInterval:min*60];
        self.time2.text = [GlobalMethod exchangeDate:self.date2 formatter:TIME_ALL_SHOW];
        [self jumpToDing];
        return;
    }
    if (interval3<0 ) {
        NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + 86400 * 1;
          NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
        NSString * nextDay = [GlobalMethod exchangeDate:newDate formatter:TIME_DAY_SHOW];
        self.date3 = [GlobalMethod exchangeStringToDate:[NSString stringWithFormat:@"%@ %@",nextDay,TIME3] formatter:TIME_ALL_SHOW];
        self.time3.text = [GlobalMethod exchangeDate:self.date3 formatter:TIME_ALL_SHOW];
        [self jumpToDing];
        return;
    }
}

- (void)timerStop{
    //停止定时器
    if (_timer != nil) {
        [_timer invalidate];
        self.timer = nil;
    }
}
#pragma mark 点击事件
- (void)jumpToDing{
    NSString *url = @"dingtalk://";
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:url]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url] options:@{} completionHandler:nil];
    }else{
        NSLog(@"打不开");
    }
}




@end
