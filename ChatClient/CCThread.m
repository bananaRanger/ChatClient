//
//  CCThread.m
//  ChatClient
//
//  Created by Anthony on 24.07.16.
//  Copyright © 2016 Anthony. All rights reserved.
//

#import "CCThread.h"

@implementation CCThread

@synthesize delegate;

- (void) runMethod : (NSObject *)object {
    @autoreleasepool {
        NSThread *currentThread = [NSThread currentThread];
        while (currentThread.isCancelled == false) {
            [NSThread sleepForTimeInterval:3.f];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self->delegate threadTiming];
            });
        }
    }
}

@end
