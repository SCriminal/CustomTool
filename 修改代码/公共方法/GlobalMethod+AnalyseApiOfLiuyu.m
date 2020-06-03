//
//  GlobalMethod+AnalyseApiOfLiuyu.m
//  Json2ObjFile
//
//  Created by 隋林栋 on 2018/8/15.
//  Copyright © 2018年 YunFeng. All rights reserved.
//

#import "GlobalMethod+AnalyseApiOfLiuyu.h"
#import "GlobalMethod+MicroServiceApiExchange.h"

@implementation GlobalMethod (AnalyseApiOfLiuyu)

#define UnPackString(T)     (((T)&&([(T) isKindOfClass:NSString.class]||[(T) isKindOfClass:NSNumber.class]))?(T):@"")

/*
 static NSString * const  kDescription = @"@apiDescription";
 static NSString * const  kParameter = @"@apiParam";
 static NSString * const  kFormatLeft = @"<#";
 static NSString * const  kFormatRight = @"#>";
 
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

 */

//转换请求数据
+ (NSString *)analyseApiOfLiuyu:(NSString *)strOrigin{
    if (!isStr(strOrigin)) {
        return @"";
    }
    strOrigin = [GlobalMethod getOffLineBreak:strOrigin];
    //拼接
    NSMutableString * strReturn = [NSMutableString new];
    for (NSString * strItem in [strOrigin componentsSeparatedByString:@"#### 简要描述"]) {
        [strReturn appendString:[self exchangeHongjiafuApiItem:strItem]];
    }
    return strReturn;
}

+ (NSString *)exchangeHongjiafuApiItem:(NSString *)strRequest{
    if (!isStr([self fetchUrl:strRequest])) {
        return @"";
    }
    NSMutableString * strReturn = [NSMutableString new];
    //description
    {
        NSString * strDescription = [NSString stringWithFormat:@"/**\n%@\n*/\n",[self fetchString:strRequest separated:@"\n" index:1]];
        [strReturn appendFormat:@"%@",strDescription];
    }
    
    //parameter
    
    NSMutableString * strParameter = [[NSMutableString alloc]initWithString:@"+(void)request"];
    NSMutableString * strMethodBody = [[NSMutableString alloc]initWithString:@"        NSDictionary *dic = @{"];
    {
        //请求参数
        
        NSArray * aryParameter = [self fetchParameter:strRequest];
       
        //添加参数
        [strParameter appendFormat:@"%@请求名称%@With",kFormatLeft,kFormatRight];
        for (int i = 0; i< aryParameter.count; i++) {
            NSDictionary * dicItem = aryParameter[i];
            NSString * explain = dicItem[@"explain"];
            NSString * strExplain =isStr(explain)?[NSString stringWithFormat:@"//%@",explain]:@"";
            [strParameter appendFormat:@"%@%@:(%@)%@%@\n",i==0?@"":@"                ",i==0?((NSString *)dicItem[@"name"]).capitalizedString :(NSString *)dicItem[@"name"],[self fetchParameterTypeString:dicItem],(NSString *)dicItem[@"name"],strExplain];
            [strMethodBody appendFormat:@"%@@\"%@\":%@,\n",i==0?@"":@"                           ",(NSString *)dicItem[@"name"],[self fetchRequestParameterValue:dicItem]];
        }
        [strParameter appendFormat:@"%@:(id <RequestDelegate>)delegate\n                success:(void (^)(NSDictionary * response, id mark))success\n                failure:(void (^)(NSString * errorStr, id mark))failure{\n",aryParameter.count>0?@"                delegate":@"Delegate"];
        
        if (aryParameter.count > 0) {
            strMethodBody =  [strMethodBody substringToIndex:strMethodBody.length - 2].mutableCopy;
        }
        [strMethodBody appendString:@"};\n"];
        [strMethodBody appendFormat:@"        [self postUrl:@\"%@\" delegate:delegate parameters:dic success:success failure:failure];",[self fetchUrl:strRequest]];
    }
    [strReturn appendString:strParameter];
    [strReturn appendString:strMethodBody];
    //request type
    [strReturn appendString:@"\n}\n"];
    
    return strReturn;
}


+(NSString *)fetchParameterTypeString:(NSDictionary *)dicItem{
    switch ([self fethchParameterType:dicItem]) {
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
+(NSString *)fetchRequestParameterValue:(NSDictionary *)dictItem{
    switch ([self fethchParameterType:dictItem]) {
        case ENUM_PARAMETER_TYPE_DOUBLE:
            return [NSString stringWithFormat:@"NSNumber.dou(%@)",dictItem[@"name"]];
            break;
        case ENUM_PARAMETER_TYPE_STRING:
            return [NSString stringWithFormat:@"RequestStrKey(%@)",dictItem[@"name"]];
            break;
        case ENUM_PARAMETER_TYPE_ERROR:
            return @"ERROR";
            break;
        default:
            break;
    }
    return @"ERROR";
    
}


#pragma mark fetch request type
+ (ENUM_REQUEST_TYPE)fethchRequestType:(NSString *)item{
    if ([item.uppercaseString rangeOfString:@"GET"].location != NSNotFound ) {
        return ENUM_REQUEST_TYPE_GET;
    }
    if ([item.uppercaseString rangeOfString:@"POST"].location != NSNotFound) {
        return ENUM_REQUEST_TYPE_POST;
    }
    if ([item.uppercaseString rangeOfString:@"PUT"].location != NSNotFound) {
        return ENUM_REQUEST_TYPE_PUT;
    }
    if ([item.uppercaseString rangeOfString:@"DELETE"].location != NSNotFound) {
        return ENUM_REQUEST_TYPE_DELETE;
    }
    if ([item.uppercaseString rangeOfString:@"PATCH"].location != NSNotFound) {
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

#pragma mark fetch parameter type
+ (ENUM_PARAMETER_TYPE)fethchParameterType:(NSDictionary *)dic{
    
    NSString * strType = dic[@"desc"];
    if (!isStr(strType)) {
        strType = dic[@"example"];
    }
//    if (strType.length > 30) {//json 串
//        return ENUM_PARAMETER_TYPE_STRING;
//    }
    NSString * strName = dic[@"name"];
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
    if ([strType.lowercaseString rangeOfString:@"text"].location != NSNotFound) {
        return ENUM_PARAMETER_TYPE_STRING;
    }
    if ([strType.lowercaseString rangeOfString:@"json"].location != NSNotFound) {
        return ENUM_PARAMETER_TYPE_STRING;
    }
    if ([strType.lowercaseString rangeOfString:@"date"].location != NSNotFound) {
        return ENUM_PARAMETER_TYPE_STRING;
    }
    if ([strType.lowercaseString rangeOfString:@"字符串"].location != NSNotFound) {
        return ENUM_PARAMETER_TYPE_STRING;
    }
    if ([strType.lowercaseString rangeOfString:@"数字"].location != NSNotFound) {
        return ENUM_PARAMETER_TYPE_DOUBLE;
    }
    //判断是否是数字
    strType = [GlobalMethod getOffLineBreak:strType];
    strType = [GlobalMethod getOffBlank:strType];
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:@"1234567890. f"] invertedSet];
    NSArray * aryTmp = [strType componentsSeparatedByCharactersInSet:cs];
    NSString *filtered = [aryTmp componentsJoinedByString:@""]; //按cs分离出数组,数组按@""分离出字符串
    if ([filtered rangeOfString:@"."].location != NSNotFound) {
        return ENUM_PARAMETER_TYPE_DOUBLE;
    }
    if (filtered.length > 5 ) {
        return ENUM_PARAMETER_TYPE_STRING;
    }
    return filtered.length == strType.length?ENUM_PARAMETER_TYPE_DOUBLE :ENUM_PARAMETER_TYPE_STRING;
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
    //    NSString * result = [regular stringByReplacingMatchesInString:strItem options:0 range:NSMakeRange(0, [strItem length]) withTemplate:@""];
    return strReturn;
}

#pragma mark fetch string
+ (NSString *)fetchString:(NSString *)strData separated:(NSString *)components index:(NSInteger)index{
    NSArray * aryAll = [strData componentsSeparatedByString:components];
    if (aryAll.count >index) {
        return [aryAll objectAtIndex:index];
    }
    return @"";
}

#pragma mark fetch parameter
+ (NSArray *)fetchParameter:(NSString *)strData{
    strData = [strData stringByReplacingOccurrencesOfString:@"#### 请求参数" withString:@"SLD_Replace"];
    strData = [strData stringByReplacingOccurrencesOfString:@"#### 返回示例" withString:@"SLD_Replace"];
    NSString * strPara = [self fetchString:strData separated:@"SLD_Replace" index:1];
    NSMutableArray * aryPara = [strPara componentsSeparatedByString:@"\n"].mutableCopy;
    if (aryPara.count < 3) {
        return @[];
    }
    [aryPara removeObjectAtIndex:0];
    [aryPara removeObjectAtIndex:0];
    [aryPara removeObjectAtIndex:0];

    NSMutableArray * aryReturn = [NSMutableArray new];
    for (NSString * strPara in aryPara) {
        if ([strPara rangeOfString:@"|"].location == NSNotFound) {
            continue;
        }
        //name
        NSString * strName = [self fetchString:strPara separated:@"|" index:1];
        //type
        NSString * strType = [self fetchString:strPara separated:@"|" index:3];
        //explain
        NSString * strExplain = [self fetchString:strPara separated:@"|" index:4];
        [aryReturn addObject:@{@"name":[GlobalMethod getOffBlank:strName],@"type":[GlobalMethod getOffBlank:strType],@"explain":[GlobalMethod getOffBlank:strExplain]}];
    }
    return aryReturn;
}

#pragma mark fetch url
+ (NSString *)fetchUrl:(NSString *)strData{
    strData = [strData stringByReplacingOccurrencesOfString:@"#### 请求URL" withString:@"SLD_Replace"];
    strData = [strData stringByReplacingOccurrencesOfString:@"#### 请求方式" withString:@"SLD_Replace"];
    NSString * strReturn = [self fetchString:strData separated:@"SLD_Replace" index:1];
    strReturn = [self fetchString:strReturn separated:@"\n" index:1];
    NSMutableArray * aryTmp = [strReturn componentsSeparatedByString:@"/"].mutableCopy;
    if (aryTmp.count < 3) {
        return @"";
    }
    [aryTmp removeObjectAtIndex:0];
    [aryTmp removeObjectAtIndex:0];
    [aryTmp removeObjectAtIndex:0];
    return [NSString stringWithFormat:@"/%@",[aryTmp componentsJoinedByString:@"/"]];
}
@end
