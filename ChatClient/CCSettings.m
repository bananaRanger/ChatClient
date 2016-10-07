//
//  CCSettings.m
//  ChatClient
//
//  Created by Anthony on 03.08.16.
//  Copyright © 2016 Anthony. All rights reserved.
//

#import "CCSettings.h"

@implementation CCSettings

@synthesize ipAddress;
@synthesize port;

+ (instancetype) sharedInstance {
    
    static CCSettings *settings = nil;
    @synchronized (self) {
        if (settings == nil) {
            settings = [[self alloc] init];
        }
    }
    return settings;
}

- (instancetype) init {
    self = [super init];
    if (self != nil) {

        self->ipAddress = [NSString stringWithFormat:@"192.168.1.102"];
        self->port = 4000;
    }
    return self;
}

- (instancetype) initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self != nil) {
        self->ipAddress = [aDecoder decodeObjectForKey:ipAddressKey];
        self->port = [aDecoder decodeIntegerForKey:portKey];
    }
    return self;
}

- (void) encodeWithCoder:(NSCoder *)aCoder {

    [aCoder encodeObject:self->ipAddress forKey:ipAddressKey];
    [aCoder encodeInteger:self->port forKey:portKey];
}

- (unsigned int) getIP {
    
    unsigned int address = 0;
    
    if (self->ipAddress != nil) {
        NSArray *array = [self->ipAddress componentsSeparatedByString:@"."];
        if (array.count == 4) {
            address = [[array objectAtIndex:3] intValue] << 24 |
            [[array objectAtIndex:2] intValue] << 16 |
            [[array objectAtIndex:1] intValue] << 8  |
            [[array objectAtIndex:0] intValue];
        }
    }
    return address;
}

@end
