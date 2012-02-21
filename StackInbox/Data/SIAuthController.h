//
//  SIAuthController.h
//  StackInbox
//
//  Created by Jonathan Bailey on 28/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IGIsolatedCookieWebView.h"
@protocol SIAuthControllerDelegate <NSObject>
-(void)authPercentageProgressChanged:(float)percent;
-(void)authCompletedSuccessfully;
-(void)authFailed;
@end

@interface SIAuthController : NSObject
@property (nonatomic, retain) NSString *accessToken;
@property (assign) id<SIAuthControllerDelegate> delegate;

-(void)startAuth;
-(BOOL)hasAccessToken;
@end
