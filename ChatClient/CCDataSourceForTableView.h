//
//  CCDataSourceForTableView.h
//  ChatClient
//
//  Created by Anthony on 26.07.16.
//  Copyright © 2016 Anthony. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface CCDataSourceForTableView : NSObject <NSTableViewDataSource, NSTableViewDelegate>
{
    NSArray<NSString *> *avatarsNames;
}

- (NSString *) userAvatarByIndex : (NSInteger) index;

@end
