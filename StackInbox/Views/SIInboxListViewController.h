//
//  SIInboxListViewController.h
//  StackInbox
//
//  Created by Jonathan Bailey on 11/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PXListView.h"
#import "SIViewController.h"
@interface SIInboxListViewController : SIViewController <PXListViewDelegate>
@property (assign) IBOutlet PXListView *listView;
@property (nonatomic, retain) NSArray *itemsToList;
@end
