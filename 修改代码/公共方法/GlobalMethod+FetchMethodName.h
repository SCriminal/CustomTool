//
//  GlobalMethod+FetchMethodName.h
//  Json2ObjFile
//
//  Created by 隋林栋 on 2017/6/23.
//  Copyright © 2017年 YunFeng. All rights reserved.
//

#import "GlobalMethod.h"

/*
 ///账户类型
 +(void)requestBtypesWithDelegate:(id <RequestDelegate>)delegate
 success:(void (^)(NSDictionary * response, id mark))success
 failure:(void (^)(NSString * errorStr, id mark))failure{
 NSDictionary *dic = @{@"key":[GlobalData sharedInstance].GB_Key                          };
 [self postUrl:@"/api/v1/Public/Btypes" delegate:delegate parameters:dic success:success failure:failure];
 }
 ///公司账号提现
 +(void)requestCashMsgWithID:(NSString *)ID
 camont:(NSString *)camont
 delegate:(id <RequestDelegate>)delegate
 success:(void (^)(NSDictionary * response, id mark))success
 failure:(void (^)(NSString * errorStr, id mark))failure{
 NSDictionary *dic = @{@"key":[GlobalData sharedInstance].GB_Key,
 @"id":NSString.num(ID),
 @"camont":NSString.num(camont)
 };
 [self postUrl:@"/api/v1/Banks/CashMsg" delegate:delegate parameters:dic success:success failure:failure];
 }
 ///公司提现详情
 +(void)requestCashInfoWithCrid:(NSString *)crid
 delegate:(id <RequestDelegate>)delegate
 success:(void (^)(NSDictionary * response, id mark))success
 failure:(void (^)(NSString * errorStr, id mark))failure{
 NSDictionary *dic = @{@"key":[GlobalData sharedInstance].GB_Key,
 @"crid":NSString.num(crid)
 };
 [self postUrl:@"/api/v1/Banks/CashInfo" delegate:delegate parameters:dic success:success failure:failure];
 }
 */

@interface GlobalMethod (FetchMethodName)
//提取.m方法名
+ (NSString *)fetchMethodName:(NSString *)string regex:(NSString *)regexStr;
@end
