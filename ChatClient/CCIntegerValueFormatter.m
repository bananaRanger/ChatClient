//
//  CCIntegerValueFormatter.m
//  ChatClient
//
//  Created by Anthony on 03.08.16.
//  Copyright © 2016 Anthony. All rights reserved.
//

#import "CCIntegerValueFormatter.h"

@implementation CCIntegerValueFormatter

- (BOOL)isPartialStringValid:(NSString*)partialString newEditingString:(NSString**)newString errorDescription:(NSString**)error
{
    if([partialString length] == 0) {
        return true;
    }
    
    NSScanner* scanner = [NSScanner scannerWithString:partialString];
    
    if(!([scanner scanInt:0] && [scanner isAtEnd])) {
        return false;
    }
    return true;
}

@end
