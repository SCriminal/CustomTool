//
//  GlobalMethod+ModelCompare.h
//  Json2ObjFile
//
//  Created by 隋林栋 on 2017/2/22.
//  Copyright © 2017年 YunFeng. All rights reserved.
//

/*
 NSString *const kModelCustomerCertificateUrl = @"certificateUrl";
 NSString *const kModelCustomerLocation = @"location";
 NSString *const kModelCustomerBirthday = @"birthday";
 NSString *const kModelCustomerWeChat = @"weChat";
 NSString *const kModelCustomerLogoUrl = @"logoUrl";
 NSString *const kModelCustomerGender = @"gender";
 NSString *const kModelCustomerNatives = @"natives";
 NSString *const kModelCustomerInitial = @"initial";
 NSString *const kModelCustomerIdentityIdentification = @"identityIdentification";
 NSString *const kModelCustomerName = @"name";
 NSString *const kModelCustomerIdCardFrontUrl = @"idCardFrontUrl";
 NSString *const kModelCustomerChannelType = @"channelType";
 NSString *const kModelCustomerHome = @"home";
 NSString *const kModelCustomerNumber = @"number";
 NSString *const kModelCustomerCompanyNumber = @"companyNumber";
 {
 "certificateUrl":"",
 "location":"",
 "logoUrl":"",
 "natives":"",
 "idCardFrontUrl":"",

 }
 
 */

#import "GlobalMethod.h"

@interface GlobalMethod (ModelCompare)

+ (NSString *)compareModel:(NSString *)str;
+ (NSString *)fetchModelName:(NSString *)strText;
+ (NSString *)compareModelWithModel:(NSString *)str;
@end
