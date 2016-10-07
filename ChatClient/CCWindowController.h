//
//  CCWindowController.h
//  ChatClient
//
//  Created by Anthony on 28.07.16.
//  Copyright © 2016 Anthony. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CCWindowControllerDelegate.h"

static NSString *CCToolbarIdentifier                    = @"CCToolbarIdentifier";
static NSString *CCToolbarUserNameIdentifier            = @"CCToolbarUserNameIdentifier";
static NSString *CCToolbarProgressIndicatorIdentifier   = @"CCToolbarProgressIndicatorIdentifier";
static NSString *CCToolbarSettingsItemIdentifier        = @"CCToolbarSettingsItemIdentifier";
static NSString *CCToolbarExitItemIdentifier            = @"CCToolbarExitItemIdentifier";

@interface CCWindowController : NSWindowController <NSToolbarDelegate>
{
    NSTextField *userName;
    NSProgressIndicator *progress;
    NSToolbar *toolbar;
    __weak id<CCWindowControllerDelegate> delegate;
}

@property (nonatomic, weak) id<CCWindowControllerDelegate> delegate;

- (void) settingsItemClick;
- (void) exitItemClick;
- (void) setUserName : (NSString *) name;

- (void) settingsOnly;
- (void) exitOnly;

- (void) startProgressIndicator;

@end
