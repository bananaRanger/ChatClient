//
//  CCClientDelegate.h
//  ChatClient
//
//  Created by Anthony on 24.07.16.
//  Copyright © 2016 Anthony. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CCClientDelegate <NSObject>

- (void) read : (BOOL) flag dataErrorWithErrorInfo : (int) error;
- (void) socketConnectionIsBroken;
- (void) errorMessageFromServer : (NSString *) message;
- (void) connectionError : (NSString *) message;

@end
