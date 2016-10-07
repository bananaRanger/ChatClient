//
//  CCThread.h
//  ChatClient
//
//  Created by Anthony on 24.07.16.
//  Copyright © 2016 Anthony. All rights reserved.
//

#import "CCThreadDelegate.h"

@interface CCThread : NSObject
{
    __weak id<CCThreadDelegate> delegate;
}

@property (nonatomic, weak) id<CCThreadDelegate> delegate;

- (void) runMethod : (NSObject *) object;

@end
