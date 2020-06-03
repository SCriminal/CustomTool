//
//  GlobalMethod.h
//  Json2ObjFile
//
//  Created by 隋林栋 on 2016/12/23.
//  Copyright © 2016年 YunFeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GlobalMethod : NSObject

#pragma mark 获取属性名
+ (NSString *)fetchStrName:(NSString *)str;
#pragma mark 获取类名
+ (NSString *)fetchStrClass:(NSString *)str;
#pragma mark 去掉换行
+ (NSString *)getOffLineBreak:(NSString *)str;
#pragma mark 转换str to ary
+ (NSArray *)exchangeStrToModelAry:(NSString *)str;
#pragma mark 去掉空格
+ (NSString *)getOffBlank:(NSString *)str;
#pragma mark 替换string
+ (NSString *)replaceInString:(NSString *)stringOrigin replaceString:(NSString *)stringOld withString:(NSString *)strNew;
#pragma mark 改变大小写
+ (NSString *)changeFirstCase:(NSString *)str;
#pragma mark 读取init文件
+ (NSString *)readFile:(NSString *)fileName;
#pragma mark 获取指定字符串后面的第一个字符串
+ (NSString *)fetchSpecific:(NSString *)str inFile:(NSString *)strFile block:(void (^)(NSString * strChange))changeStr;
#pragma mark 不是UIKit元素
+ (BOOL)isNotUIKit:(NSString *)strClass;
#pragma mark 是assign 元素
+ (BOOL)isAssign:(NSString *)strClass;
#pragma mark is has Class
+ (BOOL)isHasClass:(NSString *)strClass ary:(NSArray *)ary;
@end
