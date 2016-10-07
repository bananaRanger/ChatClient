//
//  CCDataSourceForTableView.m
//  ChatClient
//
//  Created by Anthony on 26.07.16.
//  Copyright © 2016 Anthony. All rights reserved.
//

#import "CCDataSourceForTableView.h"

@implementation CCDataSourceForTableView

- (instancetype) init {
    self = [super init];
    if (self != nil) {
        self->avatarsNames = [NSArray arrayWithObjects:@"ImageAvatar1Big", @"ImageAvatar2Big", @"ImageAvatar3Big", @"ImageAvatar4Big", @"ImageAvatar5Big", @"ImageAvatar6Big", @"ImageAvatar7Big", nil];
    }
    return self;
}

- (NSInteger) numberOfRowsInTableView:(NSTableView *)tableView {
    return self->avatarsNames.count;
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row {
    return 100;
}

- (NSString *) userAvatarByIndex : (NSInteger) index {
    if (index >= 0 && index < self->avatarsNames.count) {
        return [self->avatarsNames objectAtIndex:index];
    }
    return nil;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    
    NSView *view = [[NSView alloc] initWithFrame:NSMakeRect(0, 0, 128, 128)];
    NSImageView *imageView = [[NSImageView alloc] initWithFrame:NSMakeRect(-24, 0, 128, 128)];
    imageView.image = [NSImage imageNamed:[self->avatarsNames objectAtIndex:row]];
    imageView.imageScaling = NSImageScaleProportionallyUpOrDown;
    [view addSubview:imageView];
    return view;
}

@end
