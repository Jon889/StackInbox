//
//  SIAppDelegate.h
//  StackInbox
//
//  Created by Jonathan Bailey on 19/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SIWindow.h"
#import <Growl/growl.h>

#import "SILoginViewController.h"
#import "SIDownloadingViewController.h"
#import "SINoInternetViewController.h"
#import "SIInboxListViewController.h"

#import "SIInboxDownloader.h"
#import "SIAuthController.h"

@interface SIAppDelegate : NSObject <NSApplicationDelegate, SIInboxDownloaderDelegate, GrowlApplicationBridgeDelegate, SILoginViewControllerDelegate, SIAuthControllerDelegate>
@property (assign) IBOutlet SIWindow *window;

@property (assign) IBOutlet NSWindow *prefsWindow;

@property (nonatomic, retain) SILoginViewController *loginViewController;
@property (nonatomic, retain) SIDownloadingViewController *downloadingViewController;
@property (nonatomic, retain) SINoInternetViewController *noInternetViewController;
@property (nonatomic, retain) SIInboxListViewController *inboxViewController;
@property (nonatomic, assign) SIViewController *currentViewController;

@property (nonatomic, retain) SIInboxDownloader *downloader;
@property (nonatomic, retain) SIAuthController *authController;

@property (nonatomic, retain) NSTimer *timer;
-(void)switchToViewController:(SIViewController *)viewController;

-(IBAction)logout:(id)sender;
-(IBAction)emptyCache:(id)sender;
-(IBAction)reportBug:(id)sender;
-(IBAction)login:(id)sender;
-(IBAction)markAllRead:(id)sender;
@end
