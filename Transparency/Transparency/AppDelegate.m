//
//  AppDelegate.m
//  Transparency
//
//  Created by 隋林栋 on 2018/7/31.
//  Copyright © 2018年 SCriminal. All rights reserved.
//

#import "AppDelegate.h"
#import "MasterViewController.h"
@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@property (nonatomic, strong) MasterViewController *masterVC;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    self.masterVC = [MasterViewController new];
    self.masterVC.view.frame = self.window.contentView.bounds;
    [self.window.contentView addSubview:self.masterVC.view];;
    self.window.contentView.alphaValue = 0.5;
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}


@end
