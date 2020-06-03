//
//  MasterViewController.m
//  Transparency
//
//  Created by 隋林栋 on 2018/7/31.
//  Copyright © 2018年 SCriminal. All rights reserved.
//

#import "MasterViewController.h"
#import <WebKit/WebKit.h>
#import <AppKit/AppKit.h>
@interface MasterViewController ()

@end

@implementation MasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    NSTextField *tf = [[NSTextField alloc]initWithFrame:CGRectMake(0, 0, 100, 20)];
    tf.textColor = [NSColor blackColor];
    tf.placeholderString = @"aaaa";
    [self.view addSubview:tf];
    
}

@end
