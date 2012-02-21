//
//  SIWindow.m
//  StackInbox
//
//  Created by Jonathan Bailey on 20/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SIWindow.h"

@implementation SIWindow
@synthesize titlebarRefreshSpinner;
-(void)keyUp:(NSEvent *)theEvent {
    NSLog(@"%@", self.delegate);
}
-(void)awakeFromNib {
    self.delegate = self;
    self.titleBarHeight = 46;
    NSProgressIndicator *refreshSpinner = [[NSProgressIndicator alloc] initWithFrame:NSMakeRect(self.titleBarView.bounds.size.width - 30,
                                                                                                CGRectGetMidY(self.titleBarView.bounds) - 10, 
                                                                                                20.0f, 
                                                                                                20.0f)];
	refreshSpinner.style=NSProgressIndicatorSpinningStyle;
    refreshSpinner.displayedWhenStopped = NO;
    [refreshSpinner setDoubleValue:50];
	refreshSpinner.indeterminate=YES;
	refreshSpinner.bezeled=YES;
    [refreshSpinner setAutoresizingMask:NSViewMinXMargin | NSViewMaxXMargin | NSViewMinYMargin | NSViewMaxYMargin];
    [self.titleBarView addSubview:refreshSpinner];
    self.titlebarRefreshSpinner = refreshSpinner;
    [refreshSpinner release];
    
    NSTextField *titleText = [[NSTextField alloc] initWithFrame:NSMakeRect(0, CGRectGetMidY(self.titleBarView.bounds) -5, self.titleBarView.bounds.size.width, 15)];
    [titleText setBezeled:NO];
    [titleText setAlignment:NSCenterTextAlignment];
    [titleText setBackgroundColor:[NSColor clearColor]];
    [titleText setAutoresizingMask:NSViewMinXMargin | NSViewMaxXMargin | NSViewMinYMargin | NSViewMaxYMargin];
    [titleText setStringValue:@"StackExchange Inbox"];
    [titleText setSelectable:NO];
    [titleText setEditable:NO];
    
    [self.titleBarView addSubview:titleText];
    [titleText release];
}
-(NSRect)window:(NSWindow *)window willPositionSheet:(NSWindow *)sheet usingRect:(NSRect)rect {
    rect.origin.y -= 24;
    return rect;
}
@end
