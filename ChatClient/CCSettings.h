//
//  CCSettings.h
//  ChatClient
//
//  Created by Anthony on 03.08.16.
//  Copyright © 2016 Anthony. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *const ipAddressKey = @"ipAddressKey";
static NSString *const portKey = @"portKey";

@interface CCSettings : NSObject <NSCoding>
{
    NSString *ipAddress;
    NSInteger port;
}

@property NSString *ipAddress;
@property NSInteger port;

+ (instancetype) sharedInstance;
- (instancetype) init;

- (unsigned int) getIP;

@end
