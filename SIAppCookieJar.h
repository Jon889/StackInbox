//
//  SIAppCookieJar.h
//  StackInbox
//
//  Created by Jonathan Bailey on 27/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SIAppCookieJar : NSObject
- (id)initSingleton; // <= add these to the interface
+ (SIAppCookieJar *)sharedSIAppCookieJar;  // <= where Foo is the class name
- (NSString *) pathForCookieJar;
@property (nonatomic, retain)NSMutableArray *cookieStore;
- (void)setCookie:(NSHTTPCookie *)cookie;
- (void)removeExpiredCookies;
-(void)removeAllCookies;
@end