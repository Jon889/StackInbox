//
//  SIAppDelegate.m
//  StackInbox
//
//  Created by Jonathan Bailey on 19/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SIAppDelegate.h"
#import "JSONKit.h"

#import "SIAppCookieJar.h"

#import "SIInboxModel.h"
#import "NSDate+SI.h"
#import <Growl/growl.h>

#define  MINUTES * 60


@interface SIAppDelegate ()
-(void)setupViewControllers;
-(void)setupDataControllers;
-(void)startTimer;
-(void)stopTimer;
-(void)showBarItem;
-(void)hideBarItem;
-(void)setIndicatorsRead;
@end

@implementation SIAppDelegate

@synthesize window = _window;

@synthesize prefsWindow;

@synthesize loginViewController;
@synthesize downloadingViewController;
@synthesize noInternetViewController;
@synthesize inboxViewController;
@synthesize currentViewController;

@synthesize downloader;
@synthesize authController;

@synthesize timer;

@synthesize statusItem;

#pragma mark - App Lifecycle

- (void)dealloc {
    [statusItem release];
    [timer release];
    [loginViewController release];
    [downloadingViewController release];
    [noInternetViewController release];
    [inboxViewController release];
    [authController release];
    [downloader release];
    [super dealloc];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    [self setupViewControllers];
    [self setupDataControllers];
    [self startTimer];
    
    [[NSUserDefaults standardUserDefaults] addObserver:self forKeyPath:@"SIShowStatusItem" options:0 context:nil];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"SIShowStatusItem"]) {
        [self showBarItem];
    }
    
    [GrowlApplicationBridge setGrowlDelegate:self];
    [[NSNotificationCenter defaultCenter] addObserverForName:PXListViewSelectionDidChange object:nil queue:nil usingBlock:^(NSNotification *note) {
        [self setIndicatorsRead];
    }];
    [[NSNotificationCenter defaultCenter] addObserverForName:@"SIStartAuth" object:nil queue:nil usingBlock:^(NSNotification *note) {
        [self stopTimer];
        if (!self.inboxViewController.itemsToList || [self.inboxViewController.itemsToList count] == 0) {
            [self switchToViewController:self.loginViewController];
        }
    }];
    [[NSNotificationCenter defaultCenter] addObserverForName:SIAuthSuccessful object:nil queue:nil usingBlock:^(NSNotification *note) {
        [self startTimer]; 
    }];
    [[NSNotificationCenter defaultCenter] addObserverForName:@"SIStartedDownloading" object:nil queue:nil usingBlock:^(NSNotification *note) {
        if (self.currentViewController != self.downloadingViewController) {
            [self.window.titlebarRefreshSpinner setHidden:NO];
            [self.window.titlebarRefreshSpinner startAnimation:nil];
        }
        
        if (!self.inboxViewController.itemsToList || [self.inboxViewController.itemsToList count] == 0) {
            [self switchToViewController:self.downloadingViewController];
        }
    }];
    
    if ([self.authController hasAccessToken]) {
        if (self.inboxViewController.itemsToList && self.inboxViewController.itemsToList.count > 0) {
            [self switchToViewController:self.inboxViewController];
        } else {
            [self.downloader startDownloadWithAccessToken:self.authController.accessToken];
        }
    } else {
        [self.loginViewController setLoginState:YES];
        [self.authController startAuth];
    }
}

- (BOOL)applicationShouldHandleReopen:(NSApplication *)theApplication hasVisibleWindows:(BOOL)flag {
    [self setIndicatorsRead];
    [self.window makeKeyAndOrderFront:nil];
    return YES;
}

#pragma mark - Controllers

-(void)switchToViewController:(SIViewController *)viewController {
    if (self.currentViewController == viewController) {
        return;
    }
    if (viewController == self.downloadingViewController) {
        [self.window.titlebarRefreshSpinner stopAnimation:nil];
        [self.window.titlebarRefreshSpinner setHidden:YES];
    }
    if (self.currentViewController) {
        [self.currentViewController viewControllerWillMoveFromParent];
        [self.currentViewController.view removeFromSuperview];
        [self.currentViewController setIsCurrent:NO];
    }
    [self setCurrentViewController:viewController];
    [viewController.view setFrame:NSMakeRect(0, 0, ((NSView*)self.window.contentView).frame.size.width, ((NSView*)self.window.contentView).frame.size.height)];
    [viewController.view setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];
    [self.window.contentView addSubview:viewController.view];
    [viewController setIsCurrent:YES];
}
-(void)setupViewControllers {
    SILoginViewController *loginVC = [[SILoginViewController alloc] init];
    [loginVC setDelegate:self];
    [self setLoginViewController:loginVC];
    [loginVC release];
    
    SINoInternetViewController *noInternetVC = [[SINoInternetViewController alloc] init];
    [self setNoInternetViewController:noInternetVC];
    [noInternetVC release];
    
    SIDownloadingViewController *downloadingVC = [[SIDownloadingViewController alloc] init];
    [self setDownloadingViewController:downloadingVC];
    [downloadingVC release];
    
    SIInboxListViewController *inboxVC = [[SIInboxListViewController alloc] init];
    [self setInboxViewController:inboxVC];
    [inboxVC release];
}
-(void)setupDataControllers {
    SIInboxDownloader *inboxDownloader = [[SIInboxDownloader alloc] init];
    [inboxDownloader setDelegate:self];
    [self setDownloader:inboxDownloader];
    [inboxDownloader release];
    
    SIAuthController *authCont = [[SIAuthController alloc] init];
    [authController setDelegate:self];
    [self setAuthController:authCont];
    [authCont release];
}
#pragma mark - Timer
-(void)startTimer {
    [self.timer invalidate];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:2 MINUTES target:self selector:@selector(timerFire) userInfo:nil repeats:YES];
    [self.timer fire];
}
-(void)stopTimer {
    [self.timer invalidate];
    self.timer = nil;
}
-(void)timerFire {
    [self.downloader startDownloadWithAccessToken:self.authController.accessToken];
}

#pragma mark - MenuItem

-(void)menuItemClicked {
    [[NSApplication sharedApplication] activateIgnoringOtherApps:YES];
    [self.window makeKeyAndOrderFront:nil];
}
-(void)setIndicatorsRead {
    [[NSApp dockTile] setBadgeLabel:nil];
    NSImage *icon = [NSImage imageNamed:@"StackInbox"];
    [icon setSize:NSMakeSize([[NSStatusBar systemStatusBar] thickness]-4, [[NSStatusBar systemStatusBar] thickness] -4 )];
    [self.statusItem setImage:icon];
}
-(void)showBarItem {
    self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:[[NSStatusBar systemStatusBar] thickness]];
    NSImage *icon = [NSImage imageNamed:@"StackInboxRead"];
    if ([[[NSApp dockTile] badgeLabel] isEqualToString:@"★"]) {
        icon = [NSImage imageNamed:@"StackInboxNew"];
    }
    [icon setSize:NSMakeSize([[NSStatusBar systemStatusBar] thickness]-4, [[NSStatusBar systemStatusBar] thickness] -4 )];
    [statusItem setImage:icon];
    [statusItem setHighlightMode:YES];
    [statusItem setTarget:self];
    [statusItem setAction:@selector(menuItemClicked)];
    
}
-(void)hideBarItem {
    [[NSStatusBar systemStatusBar] removeStatusItem:self.statusItem];
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"SIShowStatusItem"]) {
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"SIShowStatusItem"]) {
            [self showBarItem];
        } else {
            [self hideBarItem];
        }
    }
}


#pragma mark - Delegation 
#pragma mark LoginViewController

-(void)loginButtonPressed {
    [self.authController startAuth];
}

#pragma mark Growl

-(void)growlNotificationWasClicked:(id)clickContext {
    NSDictionary *context = clickContext;
    NSString *link = [context objectForKey:@"link"];
    NSInteger count = [[context objectForKey:@"count"] integerValue];
    
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:link]];
    if (count == 1) {
        [self setIndicatorsRead];
    }
    
}



#pragma mark Auth
-(void)authPercentageProgressChanged:(float)percent{
    [self.loginViewController.progressBar setIndeterminate:NO];
    [self.loginViewController.progressBar setDoubleValue:percent];
}
-(void)authCompletedSuccessfully{
    //as a user it has always bugged me when progress bars never fill up
    [self.loginViewController.progressBar setDoubleValue:100];
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self.downloader startDownloadWithAccessToken:self.authController.accessToken];
    });
}
-(void)authFailed{
    //why?
}

#pragma mark Download


-(void)updateProgressWithDecimalPercent:(float)percent {
    [self.downloadingViewController.progressBar setDoubleValue:percent];
}


-(void)newItemsFound:(NSArray *)newItems {
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"ShowCountInBadge"]) {
        [[NSApplication sharedApplication].dockTile setBadgeLabel:[NSString stringWithFormat:@"%i", newItems.count]];        
    } else {
        [[NSApplication sharedApplication].dockTile setBadgeLabel:@"★"];        
    }
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"PostGrowlNotfications"]) {
        NSString *link = ((SIInboxModel *)[newItems objectAtIndex:0]).link;
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:link forKey:@"link"];
        NSNumber *numb = [NSNumber numberWithInteger:[newItems count]];
        [dict setObject:numb forKey:@"count"];
                                     
        [GrowlApplicationBridge notifyWithTitle:[NSString stringWithFormat:@"%i new StackExchange Inbox item%@", [newItems count], ([newItems count] == 1) ? @"" : @"s"]
                                    description:((SIInboxModel *)[newItems objectAtIndex:0]).body
                               notificationName:@"NewInboxItemGNotification"
                                       iconData:[[NSImage imageNamed:@"StackInbox"] TIFFRepresentation]
                                       priority:0
                                       isSticky:NO
                                   clickContext:dict];
    }
    NSImage *newImage = [NSImage imageNamed:@"StackInboxNew.png"];
    [newImage setSize:NSMakeSize([[NSStatusBar systemStatusBar] thickness] -4, [[NSStatusBar systemStatusBar] thickness] -4)];
    [self.statusItem setImage:newImage];
}

-(void)finishedDownloadingJSON:(NSDictionary *)jsonObject {
    [self.window.titlebarRefreshSpinner stopAnimation:nil];
    [self.window.titlebarRefreshSpinner setHidden:YES];
    NSInteger lastDD = [[[NSUserDefaults standardUserDefaults] objectForKey:@"LastDD"] integerValue];
    //fix for unread only
    if (self.inboxViewController.itemsToList == nil) {
        self.inboxViewController.itemsToList = [NSKeyedUnarchiver unarchiveObjectWithFile:appPath()]; //TODO cache
    }
    
    if (self.inboxViewController.itemsToList == nil) {
        self.inboxViewController.itemsToList = [NSArray array];
        lastDD = 0;
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:0] forKey:@"LastDD"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    if ([[jsonObject objectForKey:@"quota_remaining"] integerValue] == 0) {
        [[NSApplication sharedApplication].dockTile setBadgeLabel:@"!"];  
        NSString *msg = @"You have managed to use your StackExchange daily quota, all ten thousand of them. You will have to wait for the quota to reset in less than 24 hours. \n\n You should never see this message, so it probably means there is an error. \n Please report it (File > Report Bug)";
        NSAlert *alert = [NSAlert alertWithMessageText:@"Quota used up!" defaultButton:@"Ok" alternateButton:nil otherButton:nil informativeTextWithFormat:msg];
        [alert runModal];
    }
    NSArray *items = [jsonObject objectForKey:@"items"];
    NSMutableArray *newItems = [NSMutableArray array];
    for (SIInboxModel *dict in items) {
        if ([dict.creationTINumber integerValue] > lastDD) {
            [dict setIsUnread:YES];
            [newItems addObject:dict];
        }
    }
    if ([newItems count] > 0) {
        
        [[NSUserDefaults standardUserDefaults] setObject:((SIInboxModel *)[newItems objectAtIndex:0]).creationTINumber forKey:@"LastDD"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self newItemsFound:newItems];
    }
    
    [self.inboxViewController.itemsToList makeObjectsPerformSelector:@selector(setRead)];
    self.inboxViewController.itemsToList = [newItems arrayByAddingObjectsFromArray:self.inboxViewController.itemsToList];
    NSLog(@"arch %i", [NSKeyedArchiver archiveRootObject:self.inboxViewController.itemsToList toFile:appPath()]);
    [self switchToViewController:self.inboxViewController];
    [self.inboxViewController.listView reloadData];
    
}
#pragma mark - Menu Actions

-(IBAction)logout:(id)sender {
    NSAlert *logoutAlert = [NSAlert alertWithMessageText:@"Logout?" defaultButton:@"Yes" alternateButton:@"No" otherButton:nil informativeTextWithFormat:@"Are you sure you want to log out? This will remove your details from this app, and you will have to log in again to start with the newest 30 items in your inbox. \n\n This will not log you out in Safari or anywhere else"];
    if ([logoutAlert runModal] == NSAlertAlternateReturn) {
        return;
    }
    [[SIAppCookieJar sharedSIAppCookieJar] removeAllCookies]; 
    //TODOInvalidate access token
    [self emptyCache:nil];
    self.authController.accessToken = nil;
    self.inboxViewController.itemsToList = nil;
    [self.inboxViewController.listView reloadData];
    [self switchToViewController:self.loginViewController];
}

- (IBAction)emptyCache:(id)sender {
    NSAlert *emptyAlert = [NSAlert alertWithMessageText:@"Empty Cache?" defaultButton:@"Yes" alternateButton:@"No" otherButton:nil informativeTextWithFormat:@"Are you sure you want to empty the cache? Next time the inbox is refreshed in this app you will only see the latest 30 items. It will not affect you inbox on the website."];
    if ([emptyAlert runModal] == NSAlertAlternateReturn) {
        return;
    }
    NSError *error = nil;
    [[NSFileManager defaultManager] removeItemAtPath:appPath() error:&error];
    if (error) {
        [[NSAlert alertWithError:error] runModal];
    }
}

-(IBAction)markAllRead:(id)sender {
    [[NSApp dockTile] setBadgeLabel:nil];
    [self.inboxViewController.itemsToList makeObjectsPerformSelector:@selector(setRead)];
    [self.inboxViewController.listView reloadData];
}
- (IBAction)reportBug:(id)sender {
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://stackapps.com/questions/2872"]];//TODO link to app
}
-(IBAction)login:(id)sender {
    [self.authController startAuth];
}
@end
