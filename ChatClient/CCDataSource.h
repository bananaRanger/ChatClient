//
//  CCDataSource.h
//  ChatClient
//
//  Created by Anthony on 24.07.16.
//  Copyright © 2016 Anthony. All rights reserved.
//

#import <Cocoa/Cocoa.h>

static NSString *CCTableViewWithMessagesIdentifier = @"MessageID";
static NSString *CCTableViewWithUsersIdentifier    = @"UsersID";

static NSInteger CCTableViewWithMessagesTag = 1;
static NSInteger CCTableViewWithUsersTag    = 2;

@interface CCDataSource : NSObject <NSTableViewDataSource, NSTableViewDelegate>
{
    NSMutableArray *users;
    NSMutableArray *message;
    NSInteger currentMessageID;
}

@property (readonly) NSInteger currentMessageID;

- (instancetype) init;
- (void) addUsers : (NSArray *) usersList;
- (BOOL) addMessages : (NSArray *) messagesList;
- (NSInteger) lastMessageRowNumber;
- (NSRange) range;

@end
