//
//  GlobalMethod+MicroServiceApiExchange.m
//  Json2ObjFile
//
//  Created by 隋林栋 on 2018/3/6.
//  Copyright © 2018年 YunFeng. All rights reserved.
//

#import "GlobalMethod+MicroServiceApiExchange.h"

#define UnPackStr(T)     (((T)&&([(T) isKindOfClass:NSString.class]||[(T) isKindOfClass:NSNumber.class]))?(T):@"")







@implementation GlobalMethod (MicroServiceApiExchange)
//转换请求数据
+ (NSString *)exchangeMicroServiceApi:(NSString *)strOrigin prefix:(NSString *)prefix{
    if (!isStr(strOrigin)) {
        return @"";
    }
    NSArray * aryAll = [NSJSONSerialization JSONObjectWithData:[strOrigin dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
    NSMutableArray * aryList = [NSMutableArray array];
    for (NSDictionary * dicItem in aryAll) {
        [aryList addObjectsFromArray:dicItem[@"list"]];
    }
    //拼接方法名
    NSMutableString * strReturn = [NSMutableString new];
    for (NSDictionary * dicItem in aryList) {
        [strReturn appendString:[self exchangeMicroServiceItem:dicItem prefix:prefix]];
    }
    return strReturn;
}


+ (NSString *)exchangeMicroServiceItem:(NSDictionary *)dicRequest prefix:(NSString *)prefix{
    
    NSMutableString * strReturn = [NSMutableString new];
    //description
    {
        
        NSString * strDescription = @"\n";
        NSString * strDes = dicRequest[@"title"];
        if ([strDes isKindOfClass:NSString.self] && strDes.length > 0) {
            strDescription = [NSString stringWithFormat:@"/**\n%@\n*/\n",dicRequest[@"title"]];
        }
        [strReturn appendFormat:@"%@",strDescription];
    }

    //parameter
    
    NSMutableString * strParameter = [[NSMutableString alloc]initWithString:@"+(void)request"];
    NSMutableString * strMethodBody = [[NSMutableString alloc]initWithString:@"        NSDictionary *dic = @{"];
    {
        NSMutableArray * aryParameter = [(NSArray *)dicRequest[@"req_body_form"] mutableCopy];
        //添加get
        if ([dicRequest[@"req_params"] isKindOfClass:[NSArray class]]) {
            [aryParameter addObjectsFromArray:dicRequest[@"req_params"]];
        }
        if ([dicRequest[@"req_query"] isKindOfClass:[NSArray class]]) {
            [aryParameter addObjectsFromArray:dicRequest[@"req_query"]];
        }
     
        //移除token 和 子类
        for (NSDictionary * dicItem in aryParameter.copy) {
            //except token
            NSString * strName = dicItem[@"name"];
            if ([[strName lowercaseString] isEqualToString:@"token"]) {
                [aryParameter removeObject:dicItem];
                continue;
            }
            if ([strName rangeOfString:@"."].location != NSNotFound) {
                [aryParameter removeObject:dicItem];
                continue;
            }
        }
        //添加参数
        [strParameter appendFormat:@"%@请求名称%@With",kFormatLeft,kFormatRight];
            for (int i = 0; i< aryParameter.count; i++) {
                NSDictionary * dicItem = aryParameter[i];
                [strParameter appendFormat:@"%@%@:(%@)%@\n",i==0?@"":@"                ",i==0?((NSString *)dicItem[@"name"]).capitalizedString :(NSString *)dicItem[@"name"],[self fetchParameterTypeString:dicItem],(NSString *)dicItem[@"name"]];
                [strMethodBody appendFormat:@"%@@\"%@\":%@,\n",i==0?@"":@"                           ",(NSString *)dicItem[@"name"],[self fetchRequestParameterValue:dicItem]];
            }
        [strParameter appendFormat:@"%@:(id <RequestDelegate>)delegate\n                success:(void (^)(NSDictionary * response, id mark))success\n                failure:(void (^)(NSString * errorStr, id mark))failure{\n",aryParameter.count>0?@"                delegate":@"Delegate"];

        if (aryParameter.count > 0) {
            strMethodBody =  [strMethodBody substringToIndex:strMethodBody.length - 2].mutableCopy;
        }
        [strMethodBody appendString:@"};\n"];
        [strMethodBody appendFormat:@"        [self %@Url:@\"%@%@\" delegate:delegate parameters:dic success:success failure:failure];",[self fetchRequestTypeString:dicRequest[@"method"]],isStr(prefix)?prefix:@"",dicRequest[@"path"]];
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

    NSString * strType = dic[@"type"];
    if (strType.length > 30) {//json 串
        return ENUM_PARAMETER_TYPE_STRING;
    }
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
//
//    NSString * result = [regular stringByReplacingMatchesInString:strItem options:0 range:NSMakeRange(0, [strItem length]) withTemplate:@""];
    
    return strReturn;
}
@end
