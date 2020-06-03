//
//  GlobalMethod.m
//  DingHelper
//
//  Created by 隋林栋 on 2020/4/26.
//Copyright © 2020 隋林栋. All rights reserved.
//

#import "GlobalMethod.h"

@implementation GlobalMethod

#pragma mark =======Code Here

//设置日期格式
+ (NSString *)exchangeDate:(NSDate *)date formatter:(NSString *)formate{
    if (date == nil || formate == nil) {
        return @"";
    }
    
    NSMutableDictionary *threadDictionary = [[NSThread currentThread] threadDictionary];
    NSDateFormatter *dateFormatter = threadDictionary[@"myDateFormatter"];
    if(!dateFormatter){
        @synchronized(self){
            if(!dateFormatter){
                dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setAMSymbol:@"上午"];
                [dateFormatter setPMSymbol:@"下午"];
                threadDictionary[@"myDateFormatter"] = dateFormatter;
            }
        }
    }
    // 必填字段
    //    static NSDateFormatter *dateFormatter = nil;
    //    if (dateFormatter == nil) {
    //        dateFormatter = [[NSDateFormatter alloc] init];
    //        [dateFormatter setAMSymbol:@"上午"];
    //        [dateFormatter setPMSymbol:@"下午"];
    //    }
    //    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:formate];
    //用[NSDate date]可以获取系统当前时间
    NSString *currentDateStr = [dateFormatter stringFromDate:date];
    return currentDateStr;
}

+ (NSDate *)exchangeStringToDate:(NSString *)string formatter:(NSString *)formate{
    
    NSMutableDictionary *threadDictionary = [[NSThread currentThread] threadDictionary];
    NSDateFormatter *dateFormatter = threadDictionary[@"myStrToDateformatter"];
    if(!dateFormatter){
        @synchronized(self){
            if(!dateFormatter){
                dateFormatter = [[NSDateFormatter alloc] init];
                threadDictionary[@"myStrToDateformatter"] = dateFormatter;
            }
        }
    }
    //    // 必填字段
    //    static NSDateFormatter *dateFormatter = nil;
    //    if (dateFormatter == nil) {
    //        dateFormatter = [[NSDateFormatter alloc] init];
    //    }
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:formate];
    //用[NSDate date]可以获取系统当前时间
    return [dateFormatter dateFromString:string];
}

@end
