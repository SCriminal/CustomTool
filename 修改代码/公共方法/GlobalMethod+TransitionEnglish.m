//
//  GlobalMethod+TransitionEnglish.m
//  Json2ObjFile
//
//  Created by 隋林栋 on 2020/3/25.
//  Copyright © 2020 YunFeng. All rights reserved.
//

#import "GlobalMethod+TransitionEnglish.h"

@implementation GlobalMethod (TransitionEnglish)
//转换请求数据
+ (NSString *)transitionEnglish:(NSString *)str{
    NSArray * ary = [str componentsSeparatedByString:@"\n"];
    NSMutableArray * aryChinese = [NSMutableArray array];
    NSMutableArray * aryEnglish = [NSMutableArray array];
    
    for (NSString * strItem in ary) {
        if ([self isChines:strItem]) {
            [aryChinese addObject:strItem];
        }else{
            [aryEnglish addObject:strItem];
        }
    }
    
    return [NSString stringWithFormat:@"%@\n\n\n%@",[aryChinese componentsJoinedByString:@"\n"],[aryEnglish componentsJoinedByString:@"\n"]];
}

+(BOOL)isChines:(NSString *)sentence{
    int count = 0;
    int count1 = 0;
    for (int i = 0; i<sentence.length;i++)
    {
        unichar c = [sentence characterAtIndex:i];
        if (c >=0x4E00 && c <=0x9FA5)
        {
            count ++;
        }
        else
        {
            count1 ++;
        }
    }
    
    return count>count1;
}
@end

