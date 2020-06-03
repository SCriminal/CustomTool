//
//  GlobalMethod+Keyboard.m
//  Json2ObjFile
//
//  Created by 隋林栋 on 2019/11/21.
//  Copyright © 2019 YunFeng. All rights reserved.
//

#import "GlobalMethod+Keyboard.h"
#import <Carbon/Carbon.h>
#import <AppKit/AppKit.h>
static id eventMonitor;
static bool isObserve;

@implementation GlobalMethod (Keyboard)

/**
 add keyboard observe
 */
+ (void)addKeyboardObserve{
    if (eventMonitor) {
        isObserve = true;
        return;
    }
    if (AXIsProcessTrustedWithOptions != NULL) {
        NSDictionary *options = @{(__bridge id)kAXTrustedCheckOptionPrompt: @YES};
        BOOL accessibilityEnabled = AXIsProcessTrustedWithOptions((CFDictionaryRef)options);
        if (accessibilityEnabled) {
            isObserve = true;
            // 10.9 and later
           eventMonitor =  [NSEvent addGlobalMonitorForEventsMatchingMask:NSEventMaskKeyDown handler:^(NSEvent * e){
               if (!isObserve) {
                   return;
               }
               if (e.keyCode == 53) {
                   isObserve = !isObserve;
                   return;
               }
               NSLog(@"%d",e.keyCode);
//               return;
                if ([e.characters isEqualToString:@"f"]) {
                    CGPoint point = CGPointMake(e.locationInWindow.x,fabs(900 - e.locationInWindow.y));
                    [self postMouseEvent:kCGMouseButtonLeft type:kCGEventLeftMouseDown point:point clickCount:1];
                    [self postMouseEvent:kCGMouseButtonLeft type:kCGEventLeftMouseUp point:point clickCount:1];
                    return;
                }
               if ([e.characters isEqualToString:@"s"]) {
//                   [self upClick];
                   PostScrollWheelEvent(0,-200);
                   return;
               }
               if ([e.characters isEqualToString:@"w"]) {
                   PostScrollWheelEvent(0,200);
                   return;
               }
//               ?swswwwwwwwswsswwwfwwswssssswsssssssssswwswswsw
            }];
        }
    } else {
       // 10.8 and olderff
    }
   
}
+ (void)postMouseEvent:(CGMouseButton) button type:(CGEventType)type point:(CGPoint) point clickCount:(int) clickCount{
    NSLog(@"sld click x:%.f y:%.f",point.x,point.y);

    CGEventSourceRef source = CGEventSourceCreate(kCGEventSourceStateHIDSystemState);
    CGEventRef theEvent = CGEventCreateMouseEvent(source, type, point, button);
    CGEventSetIntegerValueField(theEvent, kCGMouseEventClickState, clickCount);
    CGEventSetType(theEvent, type);
    CGEventPost(kCGHIDEventTap, theEvent);
    CFRelease(theEvent);
    CFRelease(source);
}
+ (void)simulateMouseClick:(CGPoint )point{
    CGEventSourceRef source = CGEventSourceCreate(kCGEventSourceStatePrivate);
    CGEventRef theEvent = CGEventCreateMouseEvent(source, kCGEventLeftMouseDown,point, kCGMouseButtonLeft);
    CGEventSetIntegerValueField(theEvent, kCGMouseEventClickState, 1 );
    CGEventSetType(theEvent, kCGEventLeftMouseDown);
    CGEventPost(kCGHIDEventTap, theEvent);
    CFRelease(theEvent);
    CFRelease(source);
    [self simulateMouseClickUp:point];
}
+ (void)simulateMouseClickUp:(CGPoint)point{
    CGEventSourceRef source = CGEventSourceCreate(kCGEventSourceStatePrivate);
    CGEventSourceSetPixelsPerLine(source, 100);
    CGEventRef theEvent = CGEventCreateMouseEvent(source, kCGEventLeftMouseUp,point, kCGMouseButtonLeft);
    CGEventSetIntegerValueField(theEvent, kCGMouseEventClickState, 1 );
    CGEventSetType(theEvent, kCGEventLeftMouseUp);
    CGEventPost(kCGHIDEventTap, theEvent);
    CFRelease(theEvent);
    CFRelease(source);
    [self move:point];
}

+ (void)move:(CGPoint)point{
    NSLog(@"sld move x:%.f y:%.f",point.x,point.y);

    CGEventSourceRef source = CGEventSourceCreate(kCGEventSourceStateCombinedSessionState);
    CGEventRef mouse = CGEventCreateMouseEvent (NULL, kCGEventMouseMoved, point, 0);
    CGEventPost(kCGHIDEventTap, mouse);
    CFRelease(mouse);
    CFRelease(source);
}

void PostScrollWheelEvent(int32_t scrollingDeltaX, int32_t scrollingDeltaY)
{
    CGEventSourceRef source = CGEventSourceCreate(kCGEventSourceStatePrivate);
    CGEventRef theEvent = CGEventCreateScrollWheelEvent(source, kCGScrollEventUnitPixel, 2, scrollingDeltaY, scrollingDeltaX);
    CGEventPost(kCGHIDEventTap, theEvent);
    CFRelease(theEvent);
    CFRelease(source);
}
/**
 remove keyboard oberve
 */
+ (void)removeKeyobardObserve{
    isObserve = false;
}

+(void)upClick{
    CGEventRef event1, event2,e5;
    event1 = CGEventCreateKeyboardEvent(NULL, (CGKeyCode)126, true);//'z' keydown event
    CGEventSetFlags(event1, kCGEventFlagMaskShift);//set shift key down for above event
    CGEventPost(kCGSessionEventTap, event1);//post event
    
    event2 = CGEventCreateKeyboardEvent(NULL, (CGKeyCode)126, false);
    CGEventSetFlags(event2, kCGEventFlagMaskShift);
    CGEventPost(kCGSessionEventTap, event2);
    
//     e5 = CGEventCreateKeyboardEvent(NULL, (CGKeyCode)56, false);
//    CGEventPost(kCGSessionEventTap, e5);
    
    CFRelease(event1);
    CFRelease(event2);
//    CFRelease(e5);


}
@end
