//
//  GlobalMethod+CopyImages.m
//  Json2ObjFile
//
//  Created by 隋林栋 on 2019/7/23.
//  Copyright © 2019 YunFeng. All rights reserved.
//

#import "GlobalMethod+CopyImages.h"

@implementation GlobalMethod (CopyImages)
+ (void)copyImages{
//    NSArray *appDirectory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSAllDomainsMask, YES);
//        NSString *path =  [appDirectory.firstObject stringByAppendingString:@"/Untitle.onecodego"];
//        if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
//                [[NSFileManager defaultManager] createFileAtPath:path contents:nil attributes:nil];
//             }
//        NSLog(@"%@",path);
    
    NSArray * aryFilse =  [ [NSFileManager defaultManager] contentsOfDirectoryAtURL:[NSURL URLWithString:@"/Users/suilindong/Desktop/20"] includingPropertiesForKeys:nil options:NSDirectoryEnumerationSkipsHiddenFiles error:nil];
    NSLog(@"%@",aryFilse);
    NSImage * image = [NSImage imageNamed:@"testimage.png"];
    NSData * dateImage = [image TIFFRepresentation];
    for (NSURL * urlFile in aryFilse) {
        NSLog(@"%@",urlFile.absoluteString);
        [dateImage writeToFile:[urlFile.absoluteString substringFromIndex:7] atomically:true];
    }
    NSLog(@"success");
}
@end
