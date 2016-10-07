//
//  CCClient.h
//  ChatClient
//
//  Created by Anthony on 24.07.16.
//  Copyright © 2016 Anthony. All rights reserved.
//

#import <CoreFoundation/CoreFoundation.h>
#import "CCClientDelegate.h"
#import <sys/socket.h>
#import <netinet/in.h>
#import "CCSettings.h"

static const int amount = 2048 * 8;

@interface CCClient : NSObject
{
    int clientSocket;
    __weak id<CCClientDelegate> delegate;
    NSString *errorMessage;
}

@property (nonatomic, weak) id<CCClientDelegate> delegate;

- (BOOL) startClient;
- (void) closeClient;

- (BOOL) loginUser : (NSString *) user;
- (NSArray *) getUsersList;
- (BOOL) sendMessage : (NSString *) message;
- (NSArray *) getMessageListFromID : (NSInteger) ID;

- (NSString *) getError;

@end
