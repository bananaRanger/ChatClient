//
//  CCHeaderView.m
//  ChatClient
//
//  Created by Anthony on 28.07.16.
//  Copyright © 2016 Anthony. All rights reserved.
//

#import "CCView.h"

@implementation CCView

- (void)drawRect:(NSRect)dirtyRect {
    
    [[NSColor gridColor] setFill];
    NSRectFill(dirtyRect);
    [super drawRect:dirtyRect];
}

@end
