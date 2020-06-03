//
//  GlobalMethod+AnalyseApiOfLiuyu.h
//  Json2ObjFile
//
//  Created by 隋林栋 on 2018/8/15.
//  Copyright © 2018年 YunFeng. All rights reserved.
//

#import "GlobalMethod.h"
//header
#import "RequestHeader.h"

@interface GlobalMethod (AnalyseApiOfLiuyu)
//转换请求数据
+ (NSString *)analyseApiOfLiuyu:(NSString *)str;

@end
