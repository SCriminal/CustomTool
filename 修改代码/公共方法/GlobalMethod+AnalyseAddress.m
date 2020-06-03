//
//  GlobalMethod+AnalyseAddress.m
//  Json2ObjFile
//
//  Created by 隋林栋 on 2018/11/7.
//  Copyright © 2018 YunFeng. All rights reserved.
//

#import "GlobalMethod+AnalyseAddress.h"

@implementation GlobalMethod (AnalyseAddress)
//转换请求数据
+ (NSString *)analyseAddress:(NSString *)str{
    NSArray * ary = [str componentsSeparatedByString:@"),"];
    NSMutableArray * aryAllItem = [NSMutableArray array];
    for (NSString * strItem in ary) {
        NSString * strAll = [strItem stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        NSArray * aryAll = [strAll componentsSeparatedByString:@","];
        NSString * identify = [aryAll[0] substringFromIndex:1];
        NSString * code = [self removePrefixSuffix:aryAll[1]];
        NSString * name = [self removePrefixSuffix:aryAll[2]];
        NSString * level = aryAll[3];
        NSString * cityCode = [self removePrefixSuffix:aryAll[4]];
        NSString * longitude = [self removePrefixSuffix:aryAll[5]];;
        NSString * latitude = [self removeSuffix:aryAll[6] ];
        NSString * parentId = aryAll[7];
        [aryAllItem addObject:@{@"id":identify,@"code":code,@"name":name,@"level":level,@"cityCode":cityCode,@"longitude":longitude,@"latitude":latitude,@"parentId":parentId}.mutableCopy];
    }
    NSLog(@"%@",aryAllItem);
    NSMutableArray * aryFirst = [NSMutableArray array];
    for (NSDictionary * dic in aryAllItem) {
        NSString * strLevel = dic[@"level"];
        if (strLevel.integerValue == 1) {
            [aryFirst addObject:dic];
        }
    }
    for (NSMutableDictionary * dicFrist in aryFirst) {
        NSString * identity = dicFrist[@"id"];
        NSMutableArray * aryFirst = [NSMutableArray array];
        for (NSDictionary * dic in aryAllItem) {
            if ([dic[@"parentId"] isEqualToString:identity]) {
                [aryFirst addObject:dic];
            }
        }
        [dicFrist setObject:aryFirst forKey:@"subAddress"];
    }
    for (NSMutableDictionary * dicFrist in aryFirst) {
        if (!dicFrist[@"subAddress"]) {
            continue;
        }
        for (NSMutableDictionary * dicSecond in dicFrist[@"subAddress"]) {
            NSString * identity = dicSecond[@"id"];
            NSMutableArray * arySecond = [NSMutableArray array];
            for (NSDictionary * dic in aryAllItem) {
                if ([dic[@"parentId"] isEqualToString:identity]) {
                    [arySecond addObject:dic];
                }
            }
            [dicFrist setObject:arySecond forKey:@"subAddress"];
        }
    }
//    [aryFirst writeToFile:strPath atomically:true];
    return @"";
}

+ (NSString *)removePrefixSuffix:(NSString *)str{
    NSString * strReturn = [self removePrefix:str];
    strReturn = [self removeSuffix:strReturn];
    return strReturn;
}
+ (NSString *)removePrefix:(NSString *)str{
    NSString * strReturn = [str substringFromIndex:1];
    return strReturn;
}
+ (NSString *)removeSuffix:(NSString *)str{
    NSString * strReturn = [str substringToIndex:str.length-1];
    return strReturn;
}
@end
