//
//  GlobalMethod+RequestExchange.h
//  Json2ObjFile
//
//  Created by 隋林栋 on 2017/6/13.
//  Copyright © 2017年 YunFeng. All rights reserved.
//

#import "GlobalMethod.h"

@interface GlobalMethod (RequestExchange)
//转换请求数据
+ (NSString *)exchangeRequest:(NSString *)str;

@end
