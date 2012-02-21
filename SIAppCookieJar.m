//
//  SIAppCookieJar.m
//  StackInbox
//
//  Created by Jonathan Bailey on 27/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SIAppCookieJar.h"
#import "CKSingleton.h"
#import "NSHTTPCookie+Testing.h"

@implementation SIAppCookieJar
@synthesize cookieStore;
$singleton(SIAppCookieJar);     

- (id)initSingleton {
    cookieStore = [[NSKeyedUnarchiver unarchiveObjectWithFile:[self pathForCookieJar]] retain];
    if (cookieStore == nil) {
        cookieStore = [[NSMutableArray arrayWithCapacity:0] retain];
    }
    return self;
}

- (NSString *) pathForCookieJar
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *folder = [@"~/Library/Application Support/StackInbox/" stringByExpandingTildeInPath];
    
    if ([fileManager fileExistsAtPath: folder] == NO)
    {
        [fileManager createDirectoryAtPath:folder withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    return [folder stringByAppendingPathComponent: @"cookies"];    
}


-(void)syncCookieJar {
    if (![NSKeyedArchiver archiveRootObject:cookieStore toFile:[self pathForCookieJar]]) {
        NSLog(@"Error saving cookies");
    }
}
- (void)removeExpiredCookies
{
    NSMutableArray *copyOfCookieStore = [cookieStore copy];
	for (NSHTTPCookie *aCookie in copyOfCookieStore) {
		if ([aCookie isExpired]) {
			[cookieStore removeObject:aCookie];
		}
	}
    [copyOfCookieStore release];
    [self syncCookieJar];
}

- (void)setCookie:(NSHTTPCookie *)cookie
{

    //	NSLog(@"should be setting cookie with name '%@' and value '%@' for URL '%@'",
    //		  [cookie name], [cookie value], [url absoluteString]);
	if (cookie) {
		[cookieStore removeObject:cookie];
		[cookieStore addObject:cookie];
	}
	[self removeExpiredCookies];
}
-(void)removeAllCookies {
    [self.cookieStore removeAllObjects];
    [self syncCookieJar];
}

@end
