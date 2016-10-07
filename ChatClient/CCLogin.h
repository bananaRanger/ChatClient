//
//  CCLogin.h
//  ChatClient
//
//  Created by Anthony on 24.07.16.
//  Copyright © 2016 Anthony. All rights reserved.
//

#import "CCDataSourceForTableView.h"

static NSString *CCLoginClickNotification = @"CCLoginClickNotification";

@interface CCLogin : NSViewController
{
    CCDataSourceForTableView *dataSource;
    
    __weak IBOutlet NSTextField *loginTextField;
    __weak IBOutlet NSButton *loginButton;
    __weak IBOutlet NSTextField *messageTextField;
    __weak IBOutlet NSTableView *tableView;
}

@property (weak) IBOutlet NSTextField *loginTextField;
@property (weak) IBOutlet NSTextField *messageTextField;

- (IBAction) loginButtonClick : (id) sender;
- (void) allToEnabled : (BOOL) flag;

@end
