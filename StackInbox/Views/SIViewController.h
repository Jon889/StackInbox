//
//  SIViewController.h
//  
//
//  Created by Jonathan Bailey on 11/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#define performDelegateSelector(sel) if ([delegate respondsToSelector:sel]) { [delegate performSelector:sel]; }
@class SIAppDelegate;
@interface SIViewController : NSViewController
-(id)init;
@property (assign) SIAppDelegate *parentContainer;
@property (assign) BOOL isCurrent;
-(void)viewControllerWillMoveFromParent;
@end
