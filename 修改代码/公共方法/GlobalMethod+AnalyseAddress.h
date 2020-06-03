//
//  GlobalMethod+AnalyseAddress.h
//  Json2ObjFile
//
//  Created by 隋林栋 on 2018/11/7.
//  Copyright © 2018 YunFeng. All rights reserved.
//

#import "GlobalMethod.h"

NS_ASSUME_NONNULL_BEGIN

@interface GlobalMethod (AnalyseAddress)
//转换接口d里的 地址数据
+ (NSString *)analyseAddress:(NSString *)str;

@end

NS_ASSUME_NONNULL_END
