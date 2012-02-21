//
//  SIInboxDownloader.m
//  StackInbox
//
//  Created by Jonathan Bailey on 19/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SIInboxDownloader.h"
#import "ASIHTTPRequest.h"
#import "JSONKit.h"
#import "SIInboxModel.h"

@implementation SIInboxDownloader
@synthesize json, delegate, lastDownload;

-(void)startDownloadWithAccessToken:(NSString *)accessToken {
    NSString *key = @"KEY GOES HERE";
    NSString *filter = @")w_hKtV2*GAyeu2mT7_";
    if (!accessToken || [accessToken length] == 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SINeedsAccessToken" object:self];
        return;
    }
    if ([self canStartDownload] == NO) {
        NSNumber *nowTI =[NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]];
        NSNumber *thenTI = [NSNumber numberWithDouble:self.lastDownload];
        [self.delegate downloadNotStarted:60 - ([nowTI intValue] - [thenTI intValue])];
        return;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SIStartDownload" object:nil];
    NSString *url = [NSString stringWithFormat:@"https://api.stackexchange.com/2.0/inbox?key=%@&filter=%@&access_token=%@", key, filter, accessToken];
    NSLog(@"url %@", url);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SIStartedDownloading" object:self];
    
    ASIHTTPRequest *requester = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [requester setBytesReceivedBlock:^(unsigned long long size, unsigned long long total) {
        [self.delegate updateProgressWithDecimalPercent:size/total * 100]; 
    }];
    [requester setCompletionBlock:^{
        NSString *responseString = [requester responseString];
        NSError *requestError = [requester error];
        NSMutableDictionary *jsonDictionary = [NSMutableDictionary dictionaryWithDictionary:[responseString objectFromJSONString]];
        if (requestError != nil) {
            int errorID = [[jsonDictionary objectForKey:@"error_id"] intValue];
            if (errorID == 401 || errorID == 402 || errorID == 403 || errorID == 406) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"SINeedsAccessToken" object:self];
            } else if (errorID) {
                NSLog(@"API Error recieved: %i", errorID);
            } else {
                NSAlert *failAlert = [NSAlert alertWithError:requestError];
                [failAlert runModal];
            }
        } else {
            
            NSLog(@"success");
            if ([jsonDictionary objectForKey:@"error_id"]) {
                int errorID = [[jsonDictionary objectForKey:@"error_id"] intValue];
                if (errorID == 401 || errorID == 402 || errorID == 403 || errorID == 406) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"SINeedsAccessToken" object:self];
                } else {
                    NSLog(@"API Error recieved: %i", errorID);
                }
            } else {
                NSArray *itemDicts = [[jsonDictionary objectForKey:@"items"] copy];
                NSMutableArray *items = [NSMutableArray array];
                [jsonDictionary removeObjectForKey:@"items"];
                for (NSDictionary *itemDict in itemDicts) {
                    [items addObject:[SIInboxModel inboxItemUsingDictionary:itemDict]];
                }
                [itemDicts release];
                [jsonDictionary setObject:items forKey:@"items"];
                [self.delegate finishedDownloadingJSON:jsonDictionary];
            }
        }

    }];
    [requester startAsynchronous];
    self.lastDownload = [[NSDate date] timeIntervalSince1970];
}

-(BOOL)canStartDownload {    
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
    if (now - lastDownload <= 60) {
        return NO;
    }
    lastDownload = [[NSDate date] timeIntervalSince1970];
    
    return YES;
}
@end
