//
//  CCLogin.m
//  ChatClient
//
//  Created by Anthony on 24.07.16.
//  Copyright © 2016 Anthony. All rights reserved.
//

#import "CCLogin.h"

@interface CCLogin ()

@end

@implementation CCLogin

@synthesize loginTextField;
@synthesize messageTextField;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self->dataSource = [[CCDataSourceForTableView alloc] init];
    
    NSTableColumn *column1 = [[NSTableColumn alloc] initWithIdentifier:@"Column"];
    [self->tableView addTableColumn:column1];
    self->tableView.toolTip = @"Аватар пользователя";
    
    self->tableView.dataSource = self->dataSource;
    self->tableView.delegate = self->dataSource;
}

- (IBAction) loginButtonClick : (id) sender {
    NSInteger row = self->tableView.selectedRow;
    
    if (row == -1) { row = 0; }
    
    NSString *imageName = [self->dataSource userAvatarByIndex:row];
    NSDictionary *dictionary = [NSDictionary dictionaryWithObject:imageName forKey:@"img"];
    [[NSNotificationCenter defaultCenter] postNotificationName:CCLoginClickNotification object:imageName userInfo:dictionary];
}

- (void) allToEnabled : (BOOL) flag {
    self->loginTextField.enabled = flag;
    self->loginButton.enabled = flag;
    self->messageTextField.enabled = flag;
    self->tableView.enabled = flag;
}

@end
