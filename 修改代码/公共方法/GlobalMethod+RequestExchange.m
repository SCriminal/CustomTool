//
//  GlobalMethod+RequestExchange.m
//  Json2ObjFile
//
//  Created by 隋林栋 on 2017/6/13.
//  Copyright © 2017年 YunFeng. All rights reserved.
//

#import "GlobalMethod+RequestExchange.h"

@implementation GlobalMethod (RequestExchange)

//转换请求数据
+ (NSString *)exchangeRequest:(NSString *)str{
    NSMutableString * strReturn = [NSMutableString new];
    if (!isStr(str)) {
        return strReturn;
    }
    //移除开头空格
    NSMutableArray * aryStandard = [NSMutableArray array];
    NSArray * aryItem;
    if ([str rangeOfString:@"\r"].location != NSNotFound) {
        aryItem = [str componentsSeparatedByString:@"\r"];
    }else {
        aryItem = [str componentsSeparatedByString:@"\n"];
    }
    for (NSString * strItem in aryItem) {
        NSString * strRemoveEmpty = [strItem stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if (![strRemoveEmpty hasPrefix:@"key/"] && ![strRemoveEmpty hasPrefix:@"delegate"] && ![strRemoveEmpty hasPrefix:@"success"] && ![strRemoveEmpty hasPrefix:@"failure"]) {
            NSArray * aryTmp = [strRemoveEmpty componentsSeparatedByString:@" "];
            aryTmp = [aryTmp.firstObject componentsSeparatedByString:@":"];
            [aryStandard addObject:aryTmp.firstObject];
        }
    }
    NSMutableString * strhead = [NSMutableString new];
    NSMutableString * strMethod = [NSMutableString new];
    for (NSString * strTmp in aryStandard) {
        if ([strTmp isEqualToString:aryStandard.firstObject]) {
            [strhead appendFormat:@"%@:(NSString *)%@\n",[strTmp capitalizedString],strTmp];
            [strMethod appendFormat:@"@\"%@\":UnPackStr(%@),\n",strTmp,strTmp];
        }else if([strTmp isEqualToString:aryStandard.lastObject]){
            [strhead appendFormat:@"%@:(NSString *)%@",strTmp,strTmp];
            [strMethod appendFormat:@"@\"%@\":UnPackStr(%@)",strTmp,strTmp];
        }else {
            [strhead appendFormat:@"%@:(NSString *)%@\n",strTmp,strTmp];
            [strMethod appendFormat:@"@\"%@\":UnPackStr(%@),\n",strTmp,strTmp];
        }
    }
    NSString * strFile = [GlobalMethod readFile:@"LazyRequest"];
    strFile =[strFile stringByReplacingOccurrencesOfString:@"EXCHANGEHEAD" withString:strhead];
    strFile =[strFile stringByReplacingOccurrencesOfString:@"EXCHANGEMETHOD" withString:strMethod];
    return strFile;
}

@end
