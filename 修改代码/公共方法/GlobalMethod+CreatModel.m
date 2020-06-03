//
//  GlobalMethod+CreatModel.m
//  Json2ObjFile
//
//  Created by 隋林栋 on 2016/12/26.
//  Copyright © 2016年 YunFeng. All rights reserved.
//

#import "GlobalMethod+CreatModel.h"

@implementation GlobalMethod (CreatModel)


+ (NSString *)createModel:(NSString *)str  className:(NSString *)className{
    NSMutableString * strHClassFunc = [NSMutableString string];
    NSMutableString * strHInstanceFunc = [NSMutableString string];
    NSMutableString * strMClassFunc = [NSMutableString string];
    NSMutableString * strMInstanceFunc = [NSMutableString string];

    [strHClassFunc appendString:@"\n#pragma mark 创建\n+ (instancetype)initWith"];
    [strHInstanceFunc appendString:@"\n- (void)resetWith"];
    [strMClassFunc appendString:@"\n#pragma mark 创建\n+ (instancetype)initWith"];
    [strMInstanceFunc appendString:@"\n- (void)resetWith"];

    NSArray * ary = [str componentsSeparatedByString:@"\n"];
    for (int i = 0; i < ary.count ; i++) {
        NSString * strItem = ary[i];
        NSString * strName = [GlobalMethod fetchStrName:strItem];
        NSString * strClass = [GlobalMethod fetchStrClass:strItem];
        NSString * strFinal = i == ary.count - 1 ? @"": @"\n\t";
        NSString * strObject = [strClass hasPrefix:@"NS"] ? @" *" :@"";
        [strHClassFunc appendFormat:@"%@:(%@%@)%@%@", i==0 ? [GlobalMethod changeFirstCase:strName] : strName ,strClass,strObject,strName,strFinal];
        [strHInstanceFunc appendFormat:@"%@:(%@%@)%@%@",i==0 ? [GlobalMethod changeFirstCase:strName] : strName,strClass,strObject,strName,strFinal];
        [strMClassFunc appendFormat:@"%@:(%@%@)%@%@",i==0 ? [GlobalMethod changeFirstCase:strName] : strName,strClass,strObject,strName,strFinal];
        [strMInstanceFunc appendFormat:@"%@:(%@%@)%@%@",i==0 ? [GlobalMethod changeFirstCase:strName] : strName,strClass,strObject,strName,strFinal];
        
    }
    [strHClassFunc appendString:@";\n"];
    [strHInstanceFunc appendString:@";\n"];

    [strMClassFunc appendFormat:@"\n{\n\t%@ *model = [[%@ alloc]init];\n\t[model resetWith",className,className];
    [strMInstanceFunc appendFormat:@"\n{\n\t"];

    for (int i = 0; i < ary.count ; i++) {
        NSString * strItem = ary[i];
        NSString * strName = [GlobalMethod fetchStrName:strItem];
//        NSString * strClass = [GlobalMethod fetchStrClass:strItem];
        NSString * strFinal = i == ary.count - 1 ? @"": @"\n\t";

        [strMClassFunc appendFormat:@"%@: %@%@",i==0 ? [GlobalMethod changeFirstCase:strName] : strName,strName,strFinal];
        [strMInstanceFunc appendFormat:@"self.%@ = %@;\n\t",strName,strName];

    }
    [strMClassFunc appendString:@"];\n\treturn model;\n}"];
    [strMInstanceFunc appendString:@"\n}"];

    return [NSString stringWithFormat:@"%@%@\n%@\n%@\n\n",strHClassFunc,strHInstanceFunc,strMClassFunc,strMInstanceFunc];
}
@end
