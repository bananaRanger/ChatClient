//
//  CCWindowController.m
//  ChatClient
//
//  Created by Anthony on 28.07.16.
//  Copyright © 2016 Anthony. All rights reserved.
//

#import "CCWindowController.h"

@interface CCWindowController ()

@end

@implementation CCWindowController
{
    NSArray *toolbarItemArray;
}

@synthesize delegate;

- (void)windowDidLoad {
    [super windowDidLoad];
        
    [self fillingTheToolbarItemArray];
    [self initUserNameTextField];
    [self initProgressIndicator];
    
    self.window.titleVisibility = NSWindowTitleHidden;
    self.window.minSize = NSMakeSize(460, 282);
    
    self->toolbar = [[NSToolbar alloc] initWithIdentifier:CCToolbarIdentifier];
    
    for (int i = 0; i < self->toolbarItemArray.count; i++) {
        NSString *item = [self->toolbarItemArray objectAtIndex:i];
        [self->toolbar insertItemWithItemIdentifier:item atIndex:i];
    }
    self->toolbar.delegate = self;
    self.window.toolbar = self->toolbar;
    self.window.toolbar.sizeMode = NSToolbarSizeModeSmall;
}

- (void) initUserNameTextField {
    self->userName = [[NSTextField alloc] initWithFrame:NSMakeRect(0, 0, 128, 16)];
    self->userName.bordered = false;
    self->userName.editable = false;
    self->userName.drawsBackground = false;
    self->userName.backgroundColor = nil;
    self->userName.textColor = [NSColor disabledControlTextColor];
    [self->userName setFont:[NSFont systemFontOfSize:14]];
}

- (void) initProgressIndicator {
    self->progress = [[NSProgressIndicator alloc] initWithFrame:NSMakeRect(0, 0, 200, 20)];
    self->progress.indeterminate = false;
    self->progress.usesThreadedAnimation = true;
    self->progress.displayedWhenStopped = false;
    self->progress.maxValue = 75.f;
}

- (void) fillingTheToolbarItemArray {
    self->toolbarItemArray = [NSArray arrayWithObjects: CCToolbarUserNameIdentifier,
                              NSToolbarFlexibleSpaceItemIdentifier,
                              CCToolbarProgressIndicatorIdentifier,
                              CCToolbarSettingsItemIdentifier,
                              nil];
}

- (void) settingsOnly  {
    [self->toolbar removeItemAtIndex:3];
    [self->toolbar insertItemWithItemIdentifier:CCToolbarSettingsItemIdentifier atIndex:2];
}

- (void) exitOnly {
    [self->toolbar removeItemAtIndex:3];
    [self->toolbar insertItemWithItemIdentifier:CCToolbarExitItemIdentifier atIndex:2];
}

- (NSArray<NSString *> *)toolbarDefaultItemIdentifiers:(NSToolbar *)toolbar {
    return self->toolbarItemArray;
}

- (NSArray<NSString *> *)toolbarAllowedItemIdentifiers:(NSToolbar *)toolbar {
    return self->toolbarItemArray;
}

- (nullable NSToolbarItem *)toolbar:(NSToolbar *)toolbar itemForItemIdentifier:(NSString *)itemIdentifier willBeInsertedIntoToolbar:(BOOL)flag {
    
    NSToolbarItem *item = [[NSToolbarItem alloc] initWithItemIdentifier:itemIdentifier];
    
    if ([itemIdentifier isEqualToString:CCToolbarUserNameIdentifier]) {
        item.view = self->userName;
    } else if ([itemIdentifier isEqualToString:CCToolbarProgressIndicatorIdentifier]) {
        item.view = self->progress;
    } else if ([itemIdentifier isEqualToString:CCToolbarSettingsItemIdentifier]) {
        item.label = @"Настройки";
        item.image = [NSImage imageNamed:@"SettingsImage"];
        item.toolTip = @"Открыть окно настроек";
        item.target = self;
        item.action = @selector(settingsItemClick);
    } else if ([itemIdentifier isEqualToString:CCToolbarExitItemIdentifier]) {
        item.label = @"Выход";
        item.image = [NSImage imageNamed:@"ExitImage"];
        item.toolTip = @"Завершить работу";
        item.target = self;
        item.action = @selector(exitItemClick);
    }
    return item;
}

- (void) settingsItemClick {
    [self->delegate settingsButtonIsClicked];
}

- (void) exitItemClick {
    [self->delegate exitButtonIsClicked];
}

- (void) setUserName : (NSString *) name {
    self->userName.stringValue = name;
}

- (void) startProgressIndicator {
    NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(runProgressForIndicator:) object:nil];
    [thread start];
}

- (void) runProgressForIndicator : (NSObject *) object {
    @autoreleasepool {
        for (double i = 0; i <= 75; i++) {
            
            [NSThread sleepForTimeInterval:1.0];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self->progress setDoubleValue:i];
            });
        }
        [self->progress stopAnimation:nil];
    }
}

@end
