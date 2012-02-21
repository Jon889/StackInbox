//
//  SIDownloadingViewController.h
//  StackInbox
//
//  Created by Jonathan Bailey on 11/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SIViewController.h"
@interface SIDownloadingViewController : SIViewController
@property (assign) IBOutlet NSProgressIndicator *activity;
@property (assign) IBOutlet NSProgressIndicator *progressBar;

@end
