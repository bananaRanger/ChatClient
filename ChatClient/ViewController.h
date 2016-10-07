//
//  ViewController.h
//  ChatClient
//
//  Created by Anthony on 23.07.16.
//  Copyright © 2016 Anthony. All rights reserved.
//

#import "CCSettingsController.h"
#import "CCWindowController.h"
#import "CCDataSource.h"
#import "CCAnimator.h"
#import "CCClient.h"
#import "CCThread.h"
#import "CCLogin.h"

static NSString *const CCSettingsFileName = @"/Users/Tony/Desktop/settings.dat";

@interface ViewController : NSViewController <CCWindowControllerDelegate, CCClientDelegate, CCThreadDelegate>
{
    IBOutlet NSTableView *messageTableView;
    IBOutlet NSTableView *usersTableView;
    IBOutlet NSTextField *textField;
    IBOutlet NSButton *sendButton;
    IBOutlet NSTextField *messageField;
    
    CCWindowController *windowController;
    CCDataSource *dataSource;
    CCAnimator *animator;
    CCClient *client;
    CCThread *ccthread;
    NSThread *thread;
}

- (IBAction) sendButtonClick : (id) sender;

@end

