//
//  SILoginViewController.m
//  StackInbox
//
//  Created by Jonathan Bailey on 11/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SILoginViewController.h"

@implementation SILoginViewController
@synthesize loginState;
@synthesize loginButton;
@synthesize progressBar;
@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    
    return self;
}
-(void)switchToLoggingInState:(BOOL)loggingIn {
    [self setLoginState:loggingIn];
    if (loggingIn) {
        [loginButton setEnabled:NO];
        [loginButton setTitle:@"Logging in..."];
        [progressBar setIndeterminate:YES];
        [progressBar startAnimation:nil];
    } else {
        [loginButton setEnabled:YES];
        [loginButton setTitle:@"Login"];
        [progressBar setDoubleValue:0];
        [progressBar setIndeterminate:NO];
    }
}
-(void)awakeFromNib {
    [self switchToLoggingInState:self.loginState];
}
- (IBAction)login:(NSButton *)sender {
    [self switchToLoggingInState:YES];
    performDelegateSelector(@selector(loginButtonPressed))
}
-(void)viewControllerWillMoveFromParent {
    [self switchToLoggingInState:NO];
}
-(void)dealloc {
}
@end
