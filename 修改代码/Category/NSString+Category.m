//
//  NSString+Category.m
//  Json2ObjFile
//
//  Created by 隋林栋 on 2017/8/14.
//  Copyright © 2017年 YunFeng. All rights reserved.
//

#import "NSString+Category.h"

@implementation NSString (Category)
//has string in self
- (BOOL)hasString:(NSString *)str{
    if (!isStr(str)) return false;
    NSRange range = [self rangeOfString:str];
    return range.location != NSNotFound;
}
@end
