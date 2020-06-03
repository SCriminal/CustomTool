//
//  GlobalMethod+MicroServiceApiExchange.h
//  Json2ObjFile
//
//  Created by 隋林栋 on 2018/3/6.
//  Copyright © 2018年 YunFeng. All rights reserved.
//

#import "GlobalMethod.h"

@interface GlobalMethod (MicroServiceApiExchange)
//转换请求数据
+ (NSString *)exchangeMicroServiceApi:(NSString *)str;

@end
