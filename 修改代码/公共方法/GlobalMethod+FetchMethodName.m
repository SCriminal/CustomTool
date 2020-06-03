//
//  GlobalMethod+FetchMethodName.m
//  Json2ObjFile
//
//  Created by 隋林栋 on 2017/6/23.
//  Copyright © 2017年 YunFeng. All rights reserved.
//

#import "GlobalMethod+FetchMethodName.h"

@implementation GlobalMethod (FetchMethodName)

//提取.m方法名
+ (NSString *)fetchMethodName:(NSString *)string regex:(NSString *)regexStr{
    NSMutableString * strMu = [NSMutableString stringWithString:string];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexStr options:NSRegularExpressionCaseInsensitive error:nil];
    NSArray *array = [regex matchesInString:strMu options:0 range:NSMakeRange(0, string.length)];
    while (array.count) {
        for (NSTextCheckingResult *item in array.reverseObjectEnumerator.allObjects) {
            NSString *str = [string substringWithRange:item.range];
            NSLog(@"%@",str);
            [strMu replaceCharactersInRange:item.range withString:@";"];

        }
        array = [regex matchesInString:strMu options:0 range:NSMakeRange(0, strMu.length)];
    }
    [strMu stringByReplacingOccurrencesOfString:@"\n;" withString:@";"];
    return strMu;
}

@end
