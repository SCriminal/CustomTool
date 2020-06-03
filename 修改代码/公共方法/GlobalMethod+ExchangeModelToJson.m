//
//  GlobalMethod+ExchangeModelToJson.m
//  Json2ObjFile
//
//  Created by 隋林栋 on 2017/8/14.
//  Copyright © 2017年 YunFeng. All rights reserved.
//

#import "GlobalMethod+ExchangeModelToJson.h"

@implementation GlobalMethod (ExchangeModelToJson)
//转换请求数据
+ (NSString *)exchangeModeltoJson:(NSString *)str{
    NSMutableString * strReturn = [NSMutableString new];
    if (!isStr(str)) {
        return strReturn;
    }
    NSMutableArray * aryItem;
    if ([str rangeOfString:@"\r"].location != NSNotFound) {
        aryItem =  [str componentsSeparatedByString:@"\r"].mutableCopy;
    }else {
        aryItem = [str componentsSeparatedByString:@"\n"].mutableCopy;
    }
    for (NSString * strItem in aryItem.copy) {
        if (strItem.length == 0) {
            [aryItem removeObject:strItem];
            continue;
        }
        if ([strItem hasPrefix:@"//"]) {
            [aryItem removeObject:strItem];
            continue;
        }
        if ([strItem hasString:@"^"]) {
            [aryItem removeObject:strItem];
            continue;
        }
        NSArray * aryTmp = [strItem componentsSeparatedByString:@"//"];
        [aryItem replaceObjectAtIndex:[aryItem indexOfObject:strItem] withObject:aryTmp.firstObject];
    }
    for (NSString * strItem in aryItem) {
        if ([strItem hasString:@"*"] ) {
            if ([strItem hasString:@"NSString"]) {
                [strReturn appendFormat:@"\"%@\":\"\",\n",[GlobalMethod fetchStrName:strItem]];
            }
        }else if([strItem hasString:@"BOOL"]||[strItem hasString:@"bool"]){
            [strReturn appendFormat:@"\"%@\":true,\n",[GlobalMethod fetchStrName:strItem]];
        }else{
            [strReturn appendFormat:@"\"%@\":1,\n",[GlobalMethod fetchStrName:strItem]];
        }
    }
    return [NSString stringWithFormat:@"{\n%@}",strReturn];
}
@end
