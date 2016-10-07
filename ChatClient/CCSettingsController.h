//
//  CCSettingsController.h
//  ChatClient
//
//  Created by Anthony on 03.08.16.
//  Copyright © 2016 Anthony. All rights reserved.
//

#import "CCSettings.h"
#import <Cocoa/Cocoa.h>
#import "CCIntegerValueFormatter.h"

static const NSInteger okButtonCode = 100;
static const NSInteger cancelButtonCode = 200;

static NSString *regExpPattern = @"^(([0-9]{1}|[0-9]{2}|1[0-9][0-9]|2[0-5][0-5])\\.){3}([0-9]{1}|[0-9]{2}|1[0-9][0-9]|2[0-5][0-5])$";

@interface CCSettingsController : NSViewController
{
    CCSettings *settings;
    __weak IBOutlet NSTextField *ipTextField;
    __weak IBOutlet NSTextField *portTextField;
    __weak IBOutlet NSTextField *message;
    __weak IBOutlet NSButton *cancelButton;
    __weak IBOutlet NSButton *okButton;
}

- (IBAction) okButtonClicked : (id) sender;
- (IBAction) cancelButtonClicked : (id) sender;

@end
