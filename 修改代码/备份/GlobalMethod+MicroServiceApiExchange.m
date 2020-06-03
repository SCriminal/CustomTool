//
//  GlobalMethod+MicroServiceApiExchange.m
//  Json2ObjFile
//
//  Created by 隋林栋 on 2018/3/6.
//  Copyright © 2018年 YunFeng. All rights reserved.
//

#import "GlobalMethod+MicroServiceApiExchange.h"


NSString * const kDescription = @"@apiDescription";
NSString * const kParameter = @"@apiParam";
NSString * const kFormatLeft = @"<#";
NSString * const kFormatRight = @"#>";

typedef NS_ENUM(NSUInteger, ENUM_PARAMETER_TYPE) {
    ENUM_PARAMETER_TYPE_DOUBLE,
    ENUM_PARAMETER_TYPE_STRING,
    ENUM_PARAMETER_TYPE_ERROR
};
typedef NS_ENUM(NSUInteger, ENUM_REQUEST_TYPE) {
    ENUM_REQUEST_TYPE_GET,
    ENUM_REQUEST_TYPE_GET_URL,//get方式 并且拼接参数
    ENUM_REQUEST_TYPE_POST,
    ENUM_REQUEST_TYPE_PUT,
    ENUM_REQUEST_TYPE_DELETE,
    ENUM_REQUEST_TYPE_PATCH,
    ENUM_REQUEST_TYPE_ERROR
};


@implementation GlobalMethod (MicroServiceApiExchange)
//转换请求数据
+ (NSString *)exchangeMicroServiceApi:(NSString *)strOrigin{
    if (!isStr(strOrigin)) {
        return @"";
    }
    //移除全部$符
    strOrigin = [strOrigin stringByReplacingOccurrencesOfString:@"#" withString:@""];
    //替换**/为}
    strOrigin = [strOrigin stringByReplacingOccurrencesOfString:@"*/" withString:@"#"];
    //正则搜索
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"/\\*\\*[^#]*#" options:NSRegularExpressionCaseInsensitive error:nil];
    
    NSArray *array = [regex matchesInString:strOrigin options:0 range:NSMakeRange(0, strOrigin.length)];
    NSMutableArray * aryObjects = [NSMutableArray new];
    for (NSTextCheckingResult *item in array) {
        NSString *str = [strOrigin substringWithRange:item.range];
        [aryObjects addObject:str];
    }
    //拼接方法名
    NSMutableString * strReturn = [NSMutableString new];
    for (NSString * strItem in aryObjects) {
        [strReturn appendString:[self exchangeItem:strItem]];
    }
    return strReturn;
}


+ (NSString *)exchangeItem:(NSString *)strItem{
    //断言
    if ([strItem rangeOfString:@"@api "].location == NSNotFound) {
        return @"";
    }
    NSMutableString * strReturn = [NSMutableString new];
    //description
    {
        NSString * strDescription = @"\n";
        if ([strItem rangeOfString:kDescription].location != NSNotFound) {
            NSArray * aryTmp = [strItem componentsSeparatedByString:kDescription];
            NSString * strDes = [aryTmp.lastObject componentsSeparatedByString:@"\n"].firstObject;
            strDescription = [NSString stringWithFormat:@"/**\n%@\n*/\n",strDes];
        }
        [strReturn appendFormat:@"%@",strDescription];
    }

    //parameter
    
    NSMutableString * strParameter = [[NSMutableString alloc]initWithString:@"+(void)request"];
    NSMutableString * strMethodBody = [[NSMutableString alloc]initWithString:@"        NSDictionary *dic = @{"];
    {
        NSMutableArray * aryParameter = [strItem componentsSeparatedByString:kParameter].mutableCopy;
        //移除分组
        for (NSString * strItem in aryParameter.copy) {
            NSArray * aryTmp = [strItem componentsSeparatedByString:@"{"];
            if ([aryTmp.firstObject rangeOfString:@"("].location != NSNotFound) {
                [aryParameter removeObject:strItem];
                continue;
            }
            if (!isStr([self fetchParameterName:strItem])) {
                [aryParameter removeObject:strItem];
                continue;
            }
            //except token
            if ([[self fetchParameterName:strItem].lowercaseString isEqualToString:@"token"]) {
                [aryParameter removeObject:strItem];
                continue;
            }
        }
        [strParameter appendFormat:@"%@请求名称%@With",kFormatLeft,kFormatRight];
        if (aryParameter.count >= 2) {
            for (int i = 1; i< aryParameter.count; i++) {
                NSString * strItem = aryParameter[i];
                [strParameter appendFormat:@"%@%@:(%@)%@\n",i==1?@"":@"                ",i==1?[self fetchParameterName:strItem].capitalizedString :[self fetchParameterName:strItem],[self fetchParameterTypeString:strItem],[self fetchParameterName:strItem]];
                [strMethodBody appendFormat:@"%@@\"%@\":%@,\n",i==1?@"":@"                           ",[self fetchParameterName:strItem],[self fetchRequestParameterValue:strItem]];
            }
        }
        [strParameter appendFormat:@"%@:(id <RequestDelegate>)delegate\n                success:(void (^)(NSDictionary * response, id mark))success\n                failure:(void (^)(NSString * errorStr, id mark))failure{\n",aryParameter.count>=2?@"                delegate":@"Delegate"];

        
        strMethodBody =  [strMethodBody substringToIndex:strMethodBody.length - 2].mutableCopy;
        [strMethodBody appendString:@"};\n"];
        [strMethodBody appendFormat:@"        [self %@:@\"%@\".configURLHead(ENUM_REQUEST_CLASSIFICATION_CROP).replaceSubparameter(dic) delegate:delegate parameters:dic success:success failure:failure];",[self fetchRequestTypeString:strItem],[self fetchRequestURL:strItem]];
    }
    [strReturn appendString:strParameter];
    [strReturn appendString:strMethodBody];
    //request type
    [strReturn appendString:@"\n}\n"];
    
    return strReturn;
}


+(NSString *)fetchParameterTypeString:(NSString *)strItem{
    NSString * strType = [strItem componentsSeparatedByString:@"}"].firstObject;
    switch ([self fethchParameterType:strType]) {
        case ENUM_PARAMETER_TYPE_DOUBLE:
            return @"double";
            break;
        case ENUM_PARAMETER_TYPE_STRING:
            return @"NSString *";
            break;
        case ENUM_PARAMETER_TYPE_ERROR:
            return @"ERROR";
            break;
        default:
            break;
    }
    return @"ERROR";
}
+(NSString *)fetchRequestParameterValue:(NSString *)strItem{
    NSString * strType = [strItem componentsSeparatedByString:@"}"].firstObject;
    switch ([self fethchParameterType:strType]) {
        case ENUM_PARAMETER_TYPE_DOUBLE:
            return [NSString stringWithFormat:@"NSNumber.dou(%@)",[self fetchParameterName:strItem]];
            break;
        case ENUM_PARAMETER_TYPE_STRING:
            return [NSString stringWithFormat:@"UnPackStr(%@)",[self fetchParameterName:strItem]];
            break;
        case ENUM_PARAMETER_TYPE_ERROR:
            return @"ERROR";
            break;
        default:
            break;
    }
    return @"ERROR";
    
}
+(NSString *)fetchParameterName:(NSString *)strItem{
    NSArray * aryPar = [strItem componentsSeparatedByString:@"}"];
    NSString * strParameter = [aryPar objectAtIndex:0];
    for (int i = 1; i<aryPar.count; i++) {
        NSString * strTmp = [aryPar objectAtIndex:i];
        if (strTmp.length > 1) {
            strParameter = strTmp;
            break;
        }
    }
    NSArray * aryParameter = [strParameter componentsSeparatedByString:@" "];
    for (NSString * strTmp in aryParameter) {
        NSString * strFilter = [self removeChinaCharacter:strTmp];
        if (isStr(strFilter)) {
            NSString * strReturn = [strFilter stringByReplacingOccurrencesOfString:@"[" withString:@""];
            strReturn = [strReturn stringByReplacingOccurrencesOfString:@"]" withString:@""];
            if ([strReturn rangeOfString:@"."].location != NSNotFound) {
                return @"";
            }
            return strReturn;
        }
    }
    return @"";
}


#pragma mark fetch request type
+ (ENUM_REQUEST_TYPE)fethchRequestType:(NSString *)item{
    if ([item.uppercaseString rangeOfString:@"{GET}"].location != NSNotFound ) {
        return ENUM_REQUEST_TYPE_GET;
    }
    if ([item.uppercaseString rangeOfString:@"{POST}"].location != NSNotFound) {
        return ENUM_REQUEST_TYPE_POST;
    }
    if ([item.uppercaseString rangeOfString:@"{PUT}"].location != NSNotFound) {
        return ENUM_REQUEST_TYPE_PUT;
    }
    if ([item.uppercaseString rangeOfString:@"{DELETE}"].location != NSNotFound) {
        return ENUM_REQUEST_TYPE_DELETE;
    }
    if ([item.uppercaseString rangeOfString:@"{PATCH}"].location != NSNotFound) {
        return ENUM_REQUEST_TYPE_PATCH;
    }
    return ENUM_REQUEST_TYPE_ERROR;
}
+ (NSString *)fetchRequestTypeString:(NSString*)strItem{
    switch ([self fethchRequestType:strItem]) {
        case ENUM_REQUEST_TYPE_GET:
            return @"get";
            break;
        case ENUM_REQUEST_TYPE_POST:
            return @"post";
            break;
        case ENUM_REQUEST_TYPE_PUT:
            return @"put";
            break;
        case ENUM_REQUEST_TYPE_DELETE:
            return @"delete";
            break;
        case ENUM_REQUEST_TYPE_PATCH:
            return @"patch";
            break;
        default:
            break;
    }
    return @"error";
}
#pragma mark fetch request url
+(NSString *)fetchRequestURL:(NSString *)strItem{
    NSArray * aryTmp = [strItem componentsSeparatedByString:@"@api {"];
    if (aryTmp.count<2) {
        return @"ERROR";
    }
    aryTmp = [aryTmp.lastObject componentsSeparatedByString:@"}"];
    aryTmp = [[aryTmp objectAtIndex:1] componentsSeparatedByString:@" "];
    for (NSString * strURL in aryTmp) {
        if (isStr(strURL)) {
            return strURL;
        }
    }
    return @"";
}
#pragma mark fetch parameter type
+ (ENUM_PARAMETER_TYPE)fethchParameterType:(NSString *)strType{
    if ([strType.lowercaseString rangeOfString:@"long"].location != NSNotFound) {
        return ENUM_PARAMETER_TYPE_DOUBLE;
    }
    if ([strType.lowercaseString rangeOfString:@"int"].location != NSNotFound) {
        return ENUM_PARAMETER_TYPE_DOUBLE;
    }
    if ([strType.lowercaseString rangeOfString:@"decimal"].location != NSNotFound) {
        return ENUM_PARAMETER_TYPE_DOUBLE;
    }
    if ([strType.lowercaseString rangeOfString:@"integer"].location != NSNotFound) {
        return ENUM_PARAMETER_TYPE_DOUBLE;
    }
    if ([strType.lowercaseString rangeOfString:@"bigdecimal"].location != NSNotFound) {
        return ENUM_PARAMETER_TYPE_DOUBLE;
    }
    if ([strType.lowercaseString rangeOfString:@"string"].location != NSNotFound) {
        return ENUM_PARAMETER_TYPE_STRING;
    }
    if ([strType.lowercaseString rangeOfString:@"json"].location != NSNotFound) {
        return ENUM_PARAMETER_TYPE_STRING;
    }
    if ([strType.lowercaseString rangeOfString:@"date"].location != NSNotFound) {
        return ENUM_PARAMETER_TYPE_STRING;
    }
    
    return ENUM_PARAMETER_TYPE_ERROR;
}

#pragma mark remove china character

+ (NSString *)removeChinaCharacter:(NSString *)strItem{
    if (!isStr(strItem)) {
        return @"";
    }
    NSMutableString * strReturn = [NSMutableString new];
    NSRegularExpression *regular = [NSRegularExpression regularExpressionWithPattern:@"[a-zA-Z0-9]+" options:0 error:NULL];
    NSArray *array = [regular matchesInString:strItem options:0 range:NSMakeRange(0, strItem.length)];
    for (NSTextCheckingResult *item in array) {
        [strReturn appendString:[strItem substringWithRange:item.range]];
    }
//    NSMutableArray * aryObjects = [NSMutableArray new];
//    for (NSTextCheckingResult *item in array) {
//
//    NSString * result = [regular stringByReplacingMatchesInString:strItem options:0 range:NSMakeRange(0, [strItem length]) withTemplate:@""];
    
    return strReturn;
}
@end
