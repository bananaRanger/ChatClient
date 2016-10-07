//
//  CCSettingsController.m
//  ChatClient
//
//  Created by Anthony on 03.08.16.
//  Copyright © 2016 Anthony. All rights reserved.
//

#import "CCSettingsController.h"

@interface CCSettingsController ()

@end

@implementation CCSettingsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self->settings = [CCSettings sharedInstance];
    
    self->ipTextField.stringValue = self->settings.ipAddress;
    self->portTextField.integerValue = self->settings.port;
    
    CCIntegerValueFormatter *formatter = [[CCIntegerValueFormatter alloc] init];
    [self->portTextField setFormatter:formatter];
}

- (IBAction) okButtonClicked : (id) sender {
    
    NSString *string = self->ipTextField.stringValue;
    NSRegularExpression *regexp = [NSRegularExpression regularExpressionWithPattern:regExpPattern options:NSRegularExpressionCaseInsensitive error:nil];
    NSInteger count = [regexp numberOfMatchesInString:string options:0 range:NSMakeRange(0, string.length)];
        
    if (count == 1) {
        self->settings.ipAddress = self->ipTextField.stringValue;
        self->settings.port = self->portTextField.integerValue;
        [self closeWithCode:okButtonCode];
        
    } else {
        self->message.stringValue = [NSString stringWithFormat:@"Неккоректный IP"];
        [self fadeErrorMessage: self->message];
    }
}

- (IBAction) cancelButtonClicked : (id) sender {

    [self closeWithCode:cancelButtonCode];
}

- (void) closeWithCode : (NSInteger) code {
    
    if (self.view.window.sheet == true) {
        [self.view.window.sheetParent endSheet:self.view.window returnCode:code];
    } else {
        [NSApp stopModalWithCode:code];
        [self.view.window orderOut:nil];
    }
}

- (void) fadeErrorMessage : (NSTextField *) label {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [NSAnimationContext runAnimationGroup:^(NSAnimationContext * _Nonnull context) {
            context.duration = 0.5;
            label.animator.stringValue = @"";
        } completionHandler:nil];
    });
}

@end
