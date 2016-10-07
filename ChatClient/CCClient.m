//
//  CCClient.m
//  ChatClient
//
//  Created by Anthony on 24.07.16.
//  Copyright © 2016 Anthony. All rights reserved.
//

#import "CCClient.h"

@implementation CCClient

@synthesize delegate;

- (instancetype) init {
    self = [super init];
    if (self != nil) {
        self->errorMessage = [NSString string];
    }
    return self;
}

- (BOOL) startClient {

    CCSettings *settings = [CCSettings sharedInstance];
    
    self->clientSocket = socket(PF_INET, SOCK_STREAM, IPPROTO_TCP);
        
    struct sockaddr_in sin;
    
    memset(&sin, 0, sizeof(sin));
    sin.sin_len = sizeof(sin);
    sin.sin_family = AF_INET;
    sin.sin_port = htons(settings.port);
    
    //int ip[] = { 192,168,1,102 }; // 10, 3, 2, 106
    //unsigned int address = ip[3] << 24 | ip[2] << 16 | ip[1] << 8 | ip[0];
    
    sin.sin_addr.s_addr = [settings getIP];
    
    if (connect(self->clientSocket, (struct sockaddr *) &sin, sizeof(sin)) == -1) {
        [self->delegate connectionError:[NSString stringWithFormat:@"Ошибка соединения с сервером : %i", errno]];
        return false;
    }
    /*
    struct timeval Timeout;
    Timeout.tv_sec = 3;
    Timeout.tv_usec = 0;
    
    fd_set Write, Err;

    NSLog(@"%i", select(0,NULL,&Write,&Err,&Timeout));
    */
    return true;
}

- (void) closeClient {
    close(self->clientSocket);
}

- (NSString *) sendToServer : (NSString *) data {
    
    int length = amount;
    char readBuffer[length];
    const char *writeBuffer = [data cStringUsingEncoding:NSUTF8StringEncoding];
    
    long int count = 0;
    
    @synchronized (self) {
        
        count = write(clientSocket, writeBuffer, strlen(writeBuffer));

        if ([self isRead:false successfulOperationByResult:count] == false) {
            [self->delegate socketConnectionIsBroken];
            return @"";
        }
        
        count = read(clientSocket, readBuffer, length);
        
        if ([self isRead:true successfulOperationByResult:count] == false) {
            [self->delegate socketConnectionIsBroken];
            return @"";
        }
    }
    
    readBuffer[count] = 0;
    
    NSString *response = [NSString stringWithCString:readBuffer encoding:NSUTF8StringEncoding];

    return response;
}

- (NSString *) getError {
    NSString *returnString = nil;
    if (self->errorMessage != nil) {
        returnString = self->errorMessage;
        self->errorMessage = nil;
    }
    return returnString;
}

- (BOOL) isRead : (BOOL) readWriteFlag successfulOperationByResult : (long) count {
    
    if (count == -1) {
        [self->delegate read:readWriteFlag dataErrorWithErrorInfo:errno];
    }
    if (count == 0) {
        [self->delegate socketConnectionIsBroken];
        return false;
    }
    return true;
}

- (BOOL) loginUser : (NSString *) user { 
    if (user != nil) {
        NSString *string = [NSString stringWithFormat:@"LOGIN|%@", user];
        NSString *request = [self sendToServer:string];
        NSString *result = (NSString *)[self parseDataFromServer:request];
        if ([result isEqualToString:@"LOGINOK"]) {
            return true;
        } else {
            self->errorMessage = result;
        }
    }
    return false;
}

- (NSArray *) getUsersList {
    
    NSString *string = [NSString stringWithFormat:@"USERLIST|"];
    NSString *request = [self sendToServer:string];
    NSArray *result = (NSArray *)[self parseDataFromServer:request];
    return result;
}

- (BOOL) sendMessage : (NSString *) message {
    
    NSString *string = [NSString stringWithFormat:@"NEWMS|%@", message];
    NSString *request = [self sendToServer:string];
    NSString *result = (NSString *)[self parseDataFromServer:request];
    
    if ([result isEqualToString:@"NEWMSOK"]) {
        return true;
    } else {
        self->errorMessage = result;
    }
    return false;
}

- (NSArray *) getMessageListFromID : (NSInteger) ID {
    
    NSString *string = [NSString stringWithFormat:@"MSGLIST|%li", ID];
    NSString *request = [self sendToServer:string];
    NSArray *result = (NSArray *)[self parseDataFromServer:request];
    return result;
}

- (NSObject *) parseDataFromServer : (NSString *) string {
    
    NSData *data = [NSData dataWithBytes:[string UTF8String] length:[string lengthOfBytesUsingEncoding:NSUTF8StringEncoding]];
    
    id result = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    NSDictionary *dictionary = (NSDictionary *)result;

    for (NSString *key in dictionary) {
        
        if ([key isEqualToString:@"results"] || [key isEqualToString:@"error"]) {
            NSDictionary *body = [dictionary objectForKey:key];
            for (NSString *key in body) {
                NSString *message = [body objectForKey:key];
                if ([key isEqualToString:@"ERROR"]) {
                    [self->delegate errorMessageFromServer:message];
                    return message;
                }
                if ([key isEqualToString:@"command"]) {
                    return message;
                }
            }
        }
        
        if ([key isEqualToString:@"users"] || [key isEqualToString:@"messages"]) {
            NSArray *body = [dictionary objectForKey:key];
            if (body.count > 0) {
                return body;
            }
        }
    }
    return nil;
}

@end
