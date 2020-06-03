//
//  GlobalMethod+Keyboard.h
//  Json2ObjFile
//
//  Created by 隋林栋 on 2019/11/21.
//  Copyright © 2019 YunFeng. All rights reserved.
//

#import "GlobalMethod.h"

NS_ASSUME_NONNULL_BEGIN

@interface GlobalMethod (Keyboard)


/**
 add keyboard observe
 */
+ (void)addKeyboardObserve;

/**
 remove keyboard oberve
 */
+ (void)removeKeyobardObserve;
@end

NS_ASSUME_NONNULL_END
