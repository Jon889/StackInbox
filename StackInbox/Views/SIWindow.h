//
//  SIWindow.h
//  StackInbox
//
//  Created by Jonathan Bailey on 20/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <AppKit/AppKit.h>
#import "INAppStoreWindow.h"
@interface SIWindow : INAppStoreWindow <NSWindowDelegate>
@property (nonatomic, retain)NSProgressIndicator *titlebarRefreshSpinner;
@end