//
//  CCDataSource.m
//  ChatClient
//
//  Created by Anthony on 24.07.16.
//  Copyright © 2016 Anthony. All rights reserved.
//

#import "CCDataSource.h"

@implementation CCDataSource
{
    NSInteger index;
}

@synthesize currentMessageID;

- (instancetype) init {
    self = [super init];
    if (self != nil) {
        self->users = [NSMutableArray array];
        self->message = [NSMutableArray array];
        self->currentMessageID = -1;
        self->index = 0;
    }
    return self;
}

- (void) addUsers : (NSArray *) usersList {
    
    NSMutableArray *array = (NSMutableArray *)usersList;
    self->users = array;
}

- (BOOL) addMessages : (NSArray *) messagesList {
    
    NSMutableArray *array = (NSMutableArray *)[self sortingArray:messagesList by:@"ID"];
    if (array.count > 0) {
        if (self->currentMessageID == -1) {
            self->currentMessageID = 0;
        }
        for (NSDictionary *item in array) {
            [self->message addObject:item];
        }
        self->index += messagesList.count;
        self->currentMessageID += array.count;
        return true;
    }
    return false;
}

- (NSInteger)lastMessageRowNumber {
    return self->message.count - 1;
}

- (NSRange) range {
    return NSMakeRange(self->index, self->message.count);
}

- (NSArray *) sortingArray : (NSArray *) array by : (NSString *) key{
    
    NSArray *result = [array sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        if ([obj1 objectForKey:key] < [obj2 objectForKey:key]) {
            return NSOrderedAscending;
        } else if ([obj1 objectForKey:key] > [obj2 objectForKey:key]) {
            return NSOrderedDescending;
        } else {
            return NSOrderedSame;
        }
    }];
    return result;
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    if (tableView.tag == CCTableViewWithMessagesTag) {
        return (self->message.count == 0)?1:self->message.count;
    } else if (tableView.tag == CCTableViewWithUsersTag) {
        return self->users.count;
    }
    return 0;
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row {
    return 48;
}

- (NSView *) tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    
    NSView *view = [[NSView alloc] initWithFrame:NSMakeRect(0, 0, tableColumn.width, 48)];
    NSImageView *imageView = [[NSImageView alloc] initWithFrame:NSMakeRect(0, 5, 48, 48)];
    
    
    if (tableView.tag == CCTableViewWithMessagesTag) {

        if (self->message.count == 0) {
            NSTextField *noMessages = [self textFieldByRect:NSMakeRect(0, 6, tableColumn.width, 28)];
            noMessages.stringValue = @"Сообщений еще нет";
            noMessages.alignment = NSCenterTextAlignment;
            [view addSubview:noMessages];
            return view;
        }
        
        NSTextField *nameField = [self textFieldByRect:NSMakeRect(50, 20, 100, 28)];
        nameField.textColor = [NSColor controlShadowColor];
        
        NSTextField *messageField = [self textFieldByRect:NSMakeRect(50, 3, 300, 28)];
        
        NSTextField *timeField = [self textFieldByRect:NSMakeRect(50, 0, 100, 12)];
        [timeField setFont:[NSFont systemFontOfSize:9]];
        timeField.textColor = [NSColor controlShadowColor];
        
        NSDictionary *dictionary = [self->message objectAtIndex:row];
        messageField.stringValue = [dictionary objectForKey:@"text"];
        imageView.image = [NSImage imageNamed:[dictionary objectForKey:@"img"]];
        nameField.stringValue = [dictionary objectForKey:@"name"];
        timeField.stringValue = [dictionary objectForKey:@"time"];
        [view addSubview:imageView];
        [view addSubview:nameField];
        [view addSubview:messageField];
        [view addSubview:timeField];
        
    } else if (tableView.tag == CCTableViewWithUsersTag) {
        
        NSTextField *textField = [self textFieldByRect:NSMakeRect(50, 0, 100, 32)];
        NSDictionary *dictionary = [self->users objectAtIndex:row];
        textField.stringValue = [dictionary objectForKey:@"name"];
        imageView.image = [NSImage imageNamed:[dictionary objectForKey:@"img"]];
        [view addSubview:imageView];
        [view addSubview:textField];
    }
    return view;
}

- (NSTextField *) textFieldByRect : (NSRect) rect {

    NSTextField *label = [[NSTextField alloc] initWithFrame:rect];
    label.bordered = false;
    label.editable = false;
    label.drawsBackground = false;
    label.backgroundColor = nil;
    return label;
}

@end
