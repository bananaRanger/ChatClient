//
//  CCWindowControllerDelegate.h
//  ChatClient
//
//  Created by Anthony on 28.07.16.
//  Copyright © 2016 Anthony. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CCWindowControllerDelegate <NSObject>

- (void) settingsButtonIsClicked;
- (void) exitButtonIsClicked;

@end
