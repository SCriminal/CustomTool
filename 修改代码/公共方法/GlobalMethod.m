//
//  GlobalMethod.m
//  Json2ObjFile
//
//  Created by 隋林栋 on 2016/12/23.
//  Copyright © 2016年 YunFeng. All rights reserved.
//

#import "GlobalMethod.h"

@implementation GlobalMethod
#pragma mark 去掉空格
+ (NSString *)getOffBlank:(NSString *)str{
    
    NSArray * ary = [str componentsSeparatedByString:@" "];
    NSMutableArray * muAry = [NSMutableArray array];
    for (int i = 0; i< ary.count; i++) {
        NSString * strTmp = ary[i];
        if (strTmp.length > 0) {
            [muAry addObject:strTmp];
        }
    }
    NSString * strReturn = [muAry componentsJoinedByString:@" "];
    strReturn = [strReturn stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    return strReturn;
}
#pragma mark 去掉换行
+ (NSString *)getOffLineBreak:(NSString *)str{
    NSArray * ary = [str componentsSeparatedByString:@"\n"];
    NSMutableArray * muAry = [NSMutableArray array];
    for (int i = 0; i< ary.count; i++) {
        NSString * strTmp = [self getOffBlank:ary[i]];
        if (strTmp.length > 0) {
            [muAry addObject:strTmp];
        }
    }
    return [muAry componentsJoinedByString:@"\n"];
}
#pragma mark 转换str to ary
+ (NSArray *)exchangeStrToModelAry:(NSString *)str{
    NSMutableArray * aryReturn = [NSMutableArray array];
    NSString * upviewName = nil;
    for (NSString * strItem in [str componentsSeparatedByString:@"\n"]) {
        NSArray * aryModels = [self exchangeStrToModel:strItem upViewName:upviewName];
        if (aryModels.count > 0) {
            upviewName = [aryModels.lastObject strLeftOriginViewName];
            [aryReturn addObjectsFromArray: aryModels];
        }
    }
    return aryReturn;
}

+ (NSArray *)exchangeStrToModel:(NSString *)str upViewName:(NSString *)upViewName{
    NSMutableArray * aryReturn = [NSMutableArray array];
    NSArray * ary = [str componentsSeparatedByString:@";"];
    NSString * strLeftOrigin = nil;
    NSString * strLeft = nil;
    for ( int i = 0; i< ary.count; i++) {
        NSString * strItem = ary[i];
        ModelProperty * model = [ModelProperty new];
        model.strName = [self fetchStrName:strItem];
        if (!isStr(model.strName)) {
            break;
        }
        model.strClass = [self fetchStrClass:strItem];
        model.strUpViewName = upViewName;
        model.strLeftViewName = strLeft;
        strLeft = model.strName;
        if (!isStr(strLeftOrigin)) {
            strLeftOrigin = model.strName;
        }
        model.strLeftOriginViewName = strLeftOrigin;
        [aryReturn addObject:model];
    }
    
    return aryReturn;
}
#pragma mark 获取属性名
+ (NSString *)fetchStrName:(NSString *)str{
    if (str == nil || str.length == 0) {
        return @"";
    }
    NSArray * arySlope = [str componentsSeparatedByString:@"//"];
    str = arySlope.firstObject;
    NSArray * arySByEmpty = [str componentsSeparatedByString:@" "];
    if (arySByEmpty.count < 2) {
        return @"";
    }
    NSString * strName = arySByEmpty.lastObject;
    if ([strName hasSuffix:@";"]) {
        strName = [strName substringToIndex:strName.length - 1];
    }
    if ([strName hasPrefix:@"*"]) {
        strName = [strName substringFromIndex:1];
    }
    return strName;
}
#pragma mark 获取类名
+ (NSString *)fetchStrClass:(NSString *)str{
    if (str == nil || str.length == 0) {
        return @"";
    }
    NSArray * arySlope = [str componentsSeparatedByString:@"//"];
    str = arySlope.firstObject;
    NSArray * arySByEmpty = [str componentsSeparatedByString:@" "];
    if (arySByEmpty.count < 2) {
        return @"";
    }
    NSString * strClass = arySByEmpty[arySByEmpty.count - 2];
    if ([strClass isEqualToString:@"*"]) {
        strClass = arySByEmpty[arySByEmpty.count - 3];
    }
    return  strClass;
}
#pragma mark 替换string
+ (NSString *)replaceInString:(NSString *)stringOrigin replaceString:(NSString *)stringOld withString:(NSString *)strNew{
    NSArray * ary = [stringOrigin componentsSeparatedByString:stringOld];
    NSString * strReturn = [ary componentsJoinedByString:strNew];
    return strReturn;
}
#pragma mark 改变大小写
+ (NSString *)changeFirstCase:(NSString *)str{
    NSString * strFirst = [str substringToIndex:1];
    return [NSString stringWithFormat:@"%@%@",[strFirst uppercaseString],[str substringFromIndex:1]];
}

#pragma mark 读取init文件
+ (NSString *)readFile:(NSString *)fileName{
    NSString * strPath = [[NSBundle mainBundle]pathForResource:fileName ofType:@"json"];
    NSString * strFile = [NSString stringWithContentsOfFile:strPath encoding:NSUTF8StringEncoding error:nil];
    return strFile!=nil?strFile:@"";
}

#pragma mark 获取指定字符串后面的第一个字符串
+ (NSString *)fetchSpecific:(NSString *)str inFile:(NSString *)strFile block:(void (^)(NSString * strChange))changeStr{
    NSArray * ary = [strFile componentsSeparatedByString:[NSString stringWithFormat:@"%@:",str]] ;
    NSArray * arySeparateByEmpty = [ary.lastObject componentsSeparatedByString:@"\n"];
    NSString * strFirst = [arySeparateByEmpty.firstObject componentsSeparatedByString:@" "].firstObject;
    strFile = [GlobalMethod replaceInString:strFile replaceString:[NSString stringWithFormat:@"//%@:%@\n",str,strFirst] withString:@""];
    changeStr(strFile);
    return strFirst;
}

#pragma mark 不是UIKit元素
+ (BOOL)isNotUIKit:(NSString *)strClass{
    NSArray * aryPre = [NSArray arrayWithObjects:@"NS",@"Bool",@"float",@"double",@"int",@"CG",nil];
    for (NSString * strPre in aryPre) {
        NSRange range = [strClass rangeOfString:strPre];
        if (range.length > 0) {
            return true;
        }
    }
    return  false;
}

#pragma mark 是assign 元素
+ (BOOL)isAssign:(NSString *)strClass{
    NSArray * aryPre = [NSArray arrayWithObjects:@"CG",@"Bool",@"float",@"double",@"int",@"NSInteger",@"NSUInteger",nil];
    for (NSString * strPre in aryPre) {
        NSRange range = [strClass rangeOfString:strPre];
        if (range.length > 0) {
            return true;
        }
    }
    return  false;
}

#pragma mark  is has Class
+ (BOOL)isHasClass:(NSString *)strClass ary:(NSArray *)ary{
    for (NSString * str in ary) {
        NSString * strClassName = [self fetchStrClass:str];
        if ([strClassName  hasPrefix:strClass]) {
            return true;
        }
    }
    return false;
    
}

@end
