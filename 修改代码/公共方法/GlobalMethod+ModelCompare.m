//
//  GlobalMethod+ModelCompare.m
//  Json2ObjFile
//
//  Created by 隋林栋 on 2017/2/22.
//  Copyright © 2017年 YunFeng. All rights reserved.
//

#import "GlobalMethod+ModelCompare.h"

@implementation GlobalMethod (ModelCompare)

+ (NSString *)compareModel:(NSString *)strText{
    
    NSString * strReturn = @"";
    if (!isStr(strText)) {
        return strReturn;
    }
    strText = ^(){
        
        NSArray * aryRemoveEmpty = [strText componentsSeparatedByString:@"\n"];
        NSMutableArray * muAry = [NSMutableArray array];
        for (NSString * str in aryRemoveEmpty) {
            NSString * strTmp = [GlobalMethod getOffBlank:str];
            if (![strTmp hasPrefix:@"//"]&& strTmp.length > 0) {
                [muAry addObject:strTmp];
            }
        }
        return [muAry componentsJoinedByString:@"\n"];
    }();
   
    //去{} 中间
    NSArray * ary  = [strText componentsSeparatedByString:@"}"];
    //区分json  model
    NSString * strJson = ary.firstObject;
    NSString * strModel = ary.lastObject;
    
    NSArray * aryLeft = [strJson componentsSeparatedByString:@"{"];
    strJson = aryLeft.lastObject;
    if ([aryLeft.firstObject length]> strModel.length) {
        strModel = aryLeft.firstObject;
    }

    
    //提取json
    if (isStr(strJson)) {
        ary = [strJson componentsSeparatedByString:@"{"];
        strJson = ary.lastObject;
    }else{
        return  strReturn;
    }
    
    strJson = [GlobalMethod getOffLineBreak:strJson];
    strJson = [strJson stringByReplacingOccurrencesOfString:@"null" withString:@"\"\""];
    strModel = [GlobalMethod getOffLineBreak:strModel];

    NSMutableArray * aryJson = [NSMutableArray arrayWithArray:[strJson componentsSeparatedByString:@"\n"]];
    NSMutableArray * aryModel = [NSMutableArray arrayWithArray:[strModel componentsSeparatedByString:@"\n"]];
    
    NSArray * aryJsonTmp = [NSArray arrayWithArray:aryJson];
    NSArray * aryModelTmp = [NSArray arrayWithArray:aryModel];
    
    for (NSString * strJsonItem in aryJsonTmp) {
        NSString * strJsonKey = [self fetchJsonKey:strJsonItem];
        for (NSString * strModelItem in aryModelTmp) {
           NSRange range = [strModelItem rangeOfString:[NSString stringWithFormat:@"\"%@\"",strJsonKey]];
            if (range.location != NSNotFound) {
                [aryJson removeObject:strJsonItem];
                [aryModel removeObject:strModelItem];
                break;
            }
        }
    }
    return [NSString stringWithFormat:@"json:\n{\n%@\n}\n\nmodel:\n%@",[aryJson componentsJoinedByString:@"\n"],[aryModel componentsJoinedByString:@"\n"]];
}

+ (NSString *)compareModelWithModel:(NSString *)strText{
    NSString * strReturn = @"";
    if (!isStr(strText)) {
        return strReturn;
    }
    strText = ^(){
        
        NSArray * aryRemoveEmpty = [strText componentsSeparatedByString:@"\n"];
        NSMutableArray * muAry = [NSMutableArray array];
        for (NSString * str in aryRemoveEmpty) {
            NSString * strTmp = [GlobalMethod getOffBlank:str];
            if (![strTmp hasPrefix:@"//"]&& strTmp.length > 0) {
                [muAry addObject:strTmp];
            }
        }
        return [muAry componentsJoinedByString:@"\n"];
    }();
    
    //去{} 中间
    NSArray * ary  = [strText componentsSeparatedByString:@"}"];
    //区分json  model
    NSString * strJson = ary.firstObject;
    NSString * strModel = ary.lastObject;
    
    NSArray * aryLeft = [strJson componentsSeparatedByString:@"{"];
    strJson = aryLeft.lastObject;
    if ([aryLeft.firstObject length]> strModel.length) {
        strModel = aryLeft.firstObject;
    }
    
    
    //提取json
    if (isStr(strJson)) {
        ary = [strJson componentsSeparatedByString:@"{"];
        strJson = ary.lastObject;
    }else{
        return  strReturn;
    }
    
    strJson = [GlobalMethod getOffLineBreak:strJson];
    strJson = [strJson stringByReplacingOccurrencesOfString:@"null" withString:@"\"\""];
    strModel = [GlobalMethod getOffLineBreak:strModel];
    
    NSMutableArray * aryJson = [NSMutableArray arrayWithArray:[strJson componentsSeparatedByString:@"\n"]];
    NSMutableArray * aryModel = [NSMutableArray arrayWithArray:[strModel componentsSeparatedByString:@"\n"]];
    
    NSArray * aryJsonTmp = [NSArray arrayWithArray:aryJson];
    NSArray * aryModelTmp = [NSArray arrayWithArray:aryModel];
    
    for (NSString * strJsonItem in aryJsonTmp) {
        NSString * strJsonKey = [self fetchJsonKey:strJsonItem];
        for (NSString * strModelItem in aryModelTmp) {
            NSRange range = [strModelItem rangeOfString:[NSString stringWithFormat:@"\"%@\"",strJsonKey]];
            if (range.location != NSNotFound) {
                [aryJson removeObject:strJsonItem];
                [aryModel removeObject:strModelItem];
                break;
            }
        }
    }
    return [NSString stringWithFormat:@"json:\n{\n%@\n}\n\nmodel:\n%@",[aryJson componentsJoinedByString:@"\n"],[aryModel componentsJoinedByString:@"\n"]];
}
+ (NSString *)fetchModelName:(NSString *)strText{
    if (!isStr(strText)) {
        return @"";
    }
    strText = ^(){
        
        NSArray * aryRemoveEmpty = [strText componentsSeparatedByString:@"\n"];
        NSMutableArray * muAry = [NSMutableArray array];
        for (NSString * str in aryRemoveEmpty) {
            NSString * strTmp = [GlobalMethod getOffBlank:str];
            if (![strTmp hasPrefix:@"//"]&& strTmp.length > 0) {
                [muAry addObject:strTmp];
            }
        }
        return [muAry componentsJoinedByString:@"\n"];
    }();
    

    //去{} 中间
    NSArray * ary  = [strText componentsSeparatedByString:@"}"];
    
    //区分json  model
    NSString * strJson = ary.firstObject;
    NSString * strModel = ary.lastObject;
    
    NSArray * aryLeft = [strJson componentsSeparatedByString:@"{"];
    strJson = aryLeft.lastObject;
    if ([aryLeft.firstObject length]> strModel.length) {
        strModel = aryLeft.firstObject;
    }
    
    
    strModel = [GlobalMethod getOffLineBreak:strModel];
    
    NSMutableArray * aryModel = [NSMutableArray arrayWithArray:[strModel componentsSeparatedByString:@"\n"]];
    for (int i = 0; i< aryModel.count; i++) {
        NSString * strTmp = aryModel[i];
        NSArray * ary = [strTmp componentsSeparatedByString:@" "];
        if (ary.count > 2) {
            [aryModel replaceObjectAtIndex:i withObject:ary[2]];
        }
    }
    for (int i = 1; i < 100; i++) {
        NSString * strReturn = [aryModel.lastObject substringToIndex:i];
        for (NSString * strTmp in aryModel) {
            if (![strTmp hasPrefix:strReturn]) {
                return [[strReturn substringToIndex:strReturn.length -1]substringFromIndex:1];
            }
        }
    }
    
    return @"";

}

+ (NSString *)fetchJsonKey:(NSString *)str{
    str =  [GlobalMethod getOffBlank:str];
    NSArray * ary = [str componentsSeparatedByString:@"\""];
    for (NSString * str in ary) {
        if (isStr(str)) {
            return str;
        }
    }
    return @"";
}



@end
