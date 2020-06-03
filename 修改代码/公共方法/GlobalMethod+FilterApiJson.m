//
//  GlobalMethod+FilterApiJson.m
//  Json2ObjFile
//
//  Created by 隋林栋 on 2017/9/14.
//  Copyright © 2017年 YunFeng. All rights reserved.
//

#import "GlobalMethod+FilterApiJson.h"

@implementation GlobalMethod (FilterApiJson)


//转换请求数据
+ (NSString *)fliterRequestApiJson:(NSString *)str{
    //移除开头空格
    NSMutableArray * aryStandard = [NSMutableArray array];
    NSArray * aryItem;
    if ([str rangeOfString:@"\r"].location != NSNotFound) {
        aryItem = [str componentsSeparatedByString:@"\r"];
    }else {
        aryItem = [str componentsSeparatedByString:@"\n"];
    }
    for (NSString * strItemOrigin in aryItem) {
        NSString * strItem = [self removeNumPrefix:strItemOrigin];
        NSRange rangeCharacter = [strItem rangeOfString:@"{"];
        if (rangeCharacter.location != NSNotFound) {
            [aryStandard addObject:[strItem substringToIndex:rangeCharacter.location + rangeCharacter.length]];
            continue;
        }
        rangeCharacter = [strItem rangeOfString:@"["];
        if (rangeCharacter.location != NSNotFound) {
            [aryStandard addObject:[strItem substringToIndex:rangeCharacter.location + rangeCharacter.length]];
            continue;
        }

        rangeCharacter = [strItem rangeOfString:@"},"];
        if (rangeCharacter.location != NSNotFound) {
            [aryStandard addObject:[strItem substringToIndex:rangeCharacter.location + rangeCharacter.length]];
            continue;
        }
        rangeCharacter = [strItem rangeOfString:@"],"];
        if (rangeCharacter.location != NSNotFound) {
            [aryStandard addObject:[strItem substringToIndex:rangeCharacter.location + rangeCharacter.length]];
            continue;
        }
        rangeCharacter = [strItem rangeOfString:@"}"];
        if (rangeCharacter.location != NSNotFound) {
            [aryStandard addObject:[strItem substringToIndex:rangeCharacter.location + rangeCharacter.length]];
            continue;
        }
        rangeCharacter = [strItem rangeOfString:@"]"];
        if (rangeCharacter.location != NSNotFound) {
            [aryStandard addObject:[strItem substringToIndex:rangeCharacter.location + rangeCharacter.length]];
            continue;
        }
        //
        [aryStandard addObject:[self exchangeStr:strItem]];
    }
    return [aryStandard componentsJoinedByString:@"\n"];
}


+ (NSString *)removeNumPrefix:(NSString *)strOrigin{
    NSCharacterSet *setToRemove =[NSCharacterSet decimalDigitCharacterSet];
    if (strOrigin.length > 4) {
        NSString * strPrefix = [strOrigin substringToIndex:4];
        NSString *newString =
        [[strPrefix componentsSeparatedByCharactersInSet:setToRemove]componentsJoinedByString:@""];
        return [NSString stringWithFormat:@"%@%@",newString,[strOrigin substringFromIndex:4]];
    }
    return   [[strOrigin componentsSeparatedByCharactersInSet:setToRemove]componentsJoinedByString:@""];
}

+ (NSString *)exchangeStr:(NSString *)strItem{
    if (!isStr(strItem)) return @"";
    NSArray * aryComponentsSeparateByColon = [strItem componentsSeparatedByString:@":"];
    if (aryComponentsSeparateByColon.count <2) {
        return aryComponentsSeparateByColon.firstObject;
    }
    NSString * strSecond = [aryComponentsSeparateByColon objectAtIndex:1];
    strSecond = [strSecond stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([strSecond hasPrefix:@"null"]) {
        return [@[aryComponentsSeparateByColon.firstObject,@"null,"] componentsJoinedByString:@":"];
    }
    if ([strSecond hasPrefix:@"\""]) {
        return [@[aryComponentsSeparateByColon.firstObject,@"\"\","] componentsJoinedByString:@":"];
    }
    return [@[aryComponentsSeparateByColon.firstObject,@"0,"] componentsJoinedByString:@":"];
}


@end
