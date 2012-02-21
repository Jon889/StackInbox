//
//  SILoginViewController.h
//  StackInbox
//
//  Created by Jonathan Bailey on 11/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SIViewController.h"


@protocol SILoginViewControllerDelegate <NSObject>
-(void)loginButtonPressed;
@end

@interface SILoginViewController : SIViewController
@property (assign) BOOL loginState;
@property (assign) IBOutlet NSButton *loginButton;
@property (assign) IBOutlet NSProgressIndicator *progressBar;
@property (assign) id<SILoginViewControllerDelegate> delegate;
- (IBAction)login:(NSButton *)sender;
-(void)setLoginState:(BOOL)loggingIn;
@end
