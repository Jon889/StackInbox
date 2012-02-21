//
//  SIListViewCell.h
//  StackInbox
//
//  Created by Jonathan Bailey on 19/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "PXListViewCell.h"
#import "EGOImageView.h"

@interface SIListViewCell : PXListViewCell
@property (nonatomic, retain) IBOutlet NSTextField *textLabel;
@property (nonatomic, retain) IBOutlet EGOImageView *imageView;
@property (nonatomic, retain) NSColor *backgroundColor;
@property (nonatomic, retain) IBOutlet NSTextField *detailTextLabel;
@property (assign) IBOutlet NSTextField *timeField;
@end
