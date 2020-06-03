//
//  GlobalMethod+AnalyseData.m
//  Json2ObjFile
//
//  Created by 隋林栋 on 2018/7/12.
//  Copyright © 2018年 YunFeng. All rights reserved.
//

#import "GlobalMethod+AnalyseData.h"

@implementation GlobalMethod (AnalyseData)
//转换请求数据
+ (NSString *)analyseData:(NSString *)str{
    
    NSString * requestJson = [str componentsSeparatedByString:@"***"].firstObject;
    NSString * strModel = [str componentsSeparatedByString:@"***"].lastObject;
    
    NSDictionary * dicJson = [NSJSONSerialization JSONObjectWithData:[requestJson dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
    dicJson = [NSJSONSerialization JSONObjectWithData:[dicJson[@"res_body"] dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
    NSDictionary * dicData = dicJson[@"properties"];
    if (dicData[@"data"]) {
        dicData = dicData[@"data"];
        if (dicData[@"properties"]) {
            dicData = dicData[@"properties"];
        }
    }
    if (dicData[@"list"]) {
        dicData = dicData[@"list"];
        if (dicData[@"items"]) {
            dicData = dicData[@"items"];
        }
        if (dicData[@"properties"]) {
            dicData = dicData[@"properties"];
        }
    }
    
    NSLog(@"%@",dicData);
    NSMutableArray * aryReturn = [NSMutableArray array];
    for (NSString * strProperty in [strModel componentsSeparatedByString:@"\n"]) {
        if (![strProperty hasPrefix:@"@property"]) {
            [aryReturn addObject:strProperty];
            continue;
        }
        NSString * strKey = [[strProperty componentsSeparatedByString:@";"].firstObject componentsSeparatedByString:@" "].lastObject;
        strKey = [strKey stringByReplacingOccurrencesOfString:@"*" withString:@""];
        if ([dicData objectForKey:strKey]) {
            NSDictionary * dicDes = dicData[strKey];
            if ([dicDes objectForKey:@"description"]) {
                [aryReturn addObject:[NSString stringWithFormat:@"%@%@%@",strProperty,[strProperty rangeOfString:@"//"].location!= NSNotFound?@";":@"//",[dicDes objectForKey:@"description"]]];
                continue;
            }
        }
        [aryReturn addObject:strProperty];
    }
    return [aryReturn componentsJoinedByString:@"\n"];
}
@end
