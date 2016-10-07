//
//  ViewController.m
//  ChatClient
//
//  Created by Anthony on 23.07.16.
//  Copyright © 2016 Anthony. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController
{
    CCLogin *loginView ;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadSettings];
    
    self->dataSource = [[CCDataSource alloc] init];
    self->loginView  = [[CCLogin alloc] initWithNibName:nil bundle:nil];
    self->animator   = [[CCAnimator alloc] init];
    self->client     = [[CCClient alloc] init];
    self->ccthread   = [[CCThread alloc] init];
    self->ccthread.delegate = self;
    self->client.delegate = self;
    
    NSTableColumn *columnM = [[NSTableColumn alloc] initWithIdentifier:CCTableViewWithMessagesIdentifier];
    columnM.title = @"Massages";
    [self->messageTableView addTableColumn:columnM];
    self->messageTableView.tag = CCTableViewWithMessagesTag;
    [self->messageTableView sizeToFit];
    self->messageTableView.dataSource = self->dataSource;
    self->messageTableView.delegate = self->dataSource;
        
    NSTableColumn *columnU = [[NSTableColumn alloc] initWithIdentifier:CCTableViewWithUsersIdentifier];
    columnU.title = @"Users";
    [self->usersTableView addTableColumn:columnU];
    self->usersTableView.tag = CCTableViewWithUsersTag;
    [self->usersTableView sizeToFit];
    self->usersTableView.dataSource = self->dataSource;
    self->usersTableView.delegate = self->dataSource;
}

- (void) viewDidAppear {

    if (self.presentedViewControllers == nil) {
        [self presentViewController:self->loginView animator:self->animator];
    }
    
    self->windowController = (CCWindowController *)self.view.window.windowController;
    self->windowController.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginButtonClick:) name:CCLoginClickNotification object:nil];
    
    [self connectToServer];
}

- (void) connectToServer {
    
    if ([self->client startClient] == false) {
        [self->loginView allToEnabled:false];
        [self->windowController startProgressIndicator];
    } else {
        [self->loginView allToEnabled:true];
    }
}

- (void) loadSettings {
    
    NSMutableData *data = [NSMutableData dataWithContentsOfFile:CCSettingsFileName];
    if (data.length != 0) {
        
        CCSettings *settings = [CCSettings sharedInstance];
        NSKeyedUnarchiver *decoder = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        NSMutableArray    *array   = [[NSMutableArray alloc] init];
        CCSettings *sett = [CCSettings sharedInstance];
        
        BOOL flag = true;
        while (flag) {
            sett = [decoder decodeObject];
            if (sett != nil) {
                [array addObject:sett];
            } else {
                flag = false;
            }
        }
        settings.ipAddress = ((CCSettings *)[array firstObject]).ipAddress;
        settings.port = ((CCSettings *)[array firstObject]).port;
    }
}

- (void) saveSettings {

    NSMutableData *data = [NSMutableData dataWithCapacity:1024];
    NSKeyedArchiver *encoder = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    CCSettings *settings = [CCSettings sharedInstance];
    
    [encoder encodeObject:settings];
    [encoder finishEncoding];
    
    [data writeToFile:CCSettingsFileName atomically:false];
}

- (void) loginButtonClick : (NSNotification *) notification {
    
    NSString *avatar = (NSString *)notification.object;
    NSString *string = [NSString stringWithFormat:@"%@^%@", self->loginView.loginTextField.stringValue, avatar];
    
    BOOL result = [self->client loginUser:string];
    if (result == true) {
        
        [self->windowController exitOnly];
        
        [self dismissViewController:self->loginView];
        [self updateUsers];
        [self updateMessages];
        
        self->thread = [[NSThread alloc] initWithTarget:self->ccthread selector:@selector(runMethod:) object:nil];
        [self->thread start];
        
        [self->windowController setUserName:self->loginView.loginTextField.stringValue];
    } else {
        self->loginView.messageTextField.stringValue = [self->client getError];
        [self fadeErrorMessage:self->loginView.messageTextField];
    }
}

- (IBAction) sendButtonClick : (id) sender {
    
    NSString *message = self->textField.stringValue;
    
    if (message.length > 0) {
        BOOL result = [self->client sendMessage:message];
        if (result == true) {
            self->textField.stringValue = @"";
            [self updateMessages];
        } else {
            self->messageField.stringValue = [self->client getError];
            [self fadeErrorMessage:self->messageField];
        }
    }
}

- (void) updateUsers {
    [self->dataSource addUsers:[self->client getUsersList]];
    [self->usersTableView reloadData];
}

- (void) updateMessages {
    BOOL result = [self->dataSource addMessages:[self->client getMessageListFromID:self->dataSource.currentMessageID - 1]];
    if (result == true) {
        
        //NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:[self->dataSource range]];
        
        [self->messageTableView beginUpdates];
        [self->messageTableView reloadData];
        //[self->messageTableView insertRowsAtIndexes:indexSet withAnimation:NSTableViewAnimationEffectFade];
        [self->messageTableView endUpdates];
        [self->messageTableView scrollRowToVisible:[self->dataSource lastMessageRowNumber]];
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

- (void) alertMessage : (NSString *) message withTitle : (NSString *) title {
    
    NSAlert *alert = [[NSAlert alloc] init];
    alert.alertStyle = NSCriticalAlertStyle;
    alert.informativeText = message;
    alert.messageText = title;
    
    [alert beginSheetModalForWindow:self.view.window completionHandler:nil];
}

#pragma mark - CCWindowController -

- (void) settingsButtonIsClicked {
    
    CCSettingsController *settingsController = [[CCSettingsController alloc] initWithNibName:nil bundle:nil];
    NSWindow *window = [NSWindow windowWithContentViewController:settingsController];
    
    [self.view.window beginSheet:window completionHandler:^(NSModalResponse returnCode) {
        if (returnCode == okButtonCode) {
            [self saveSettings];
            [self->client closeClient];
            [self connectToServer];
        }
    }];
}

- (void) exitButtonIsClicked {
    if (self.presentedViewControllers == nil) {
        [self->thread cancel];
        [self->client closeClient];
        [self->windowController setUserName:@""];
        
        [self->windowController settingsOnly];
        
        [self presentViewController:self->loginView animator:self->animator];
        [self connectToServer];
    }
}

#pragma mark - CCThreadDelegate -

- (void) threadTiming {
    [self updateUsers];
    [self updateMessages];
}

#pragma mark - CCClientDelegate -

- (void) read : (BOOL) flag dataErrorWithErrorInfo : (int) error {
    
    if (flag == true) {
        NSLog(@"read error #%i", error);
    } else {
        NSLog(@"write error #%i", error);
    }
}

- (void) socketConnectionIsBroken {
    
    [self->thread cancel];
    [self->client closeClient];
    
    NSLog(@"socketConnectionIsBroken");
}

- (void) errorMessageFromServer : (NSString *) message {
    
    //[self alertMessage:message withTitle:@"Ошибка"];
    NSLog(@"%@", message);
}

- (void)connectionError:(NSString *)message {
    
    NSString *messageText = [NSString stringWithFormat:@"%@\nПроверьте настройки соединения", message];
    [self alertMessage:messageText withTitle:@"Ошибка соединения с сервером"];
}

@end
