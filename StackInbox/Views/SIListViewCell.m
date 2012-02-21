//
//  SIListViewCell.m
//  StackInbox
//
//  Created by Jonathan Bailey on 19/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SIListViewCell.h"

@implementation SIListViewCell
@synthesize detailTextLabel;
@synthesize timeField;
@synthesize textLabel, imageView, backgroundColor;

-(void)dealloc {
    [textLabel release];
    textLabel = nil;
    [imageView release];
    imageView = nil;
    [detailTextLabel release];
    detailTextLabel = nil;
    [super dealloc];
}
-(void)setBackgroundColor:(NSColor *)new_value {
    if (new_value != backgroundColor) {
        [backgroundColor release];
        backgroundColor = [new_value retain];
        [self setNeedsDisplay:NO];
    }
}


-(void)prepareForReuse {
    [self setBackgroundColor:nil];
    [super prepareForReuse];
}
-(void)drawRect:(NSRect)dirtyRect {

    if (self.backgroundColor != nil) {
        [self.backgroundColor setFill];
        NSRectFill(dirtyRect);
    } else {
        [[NSColor colorWithDeviceRed:(0xED / 255.0) green:(0xED / 255.0) blue:(0xED / 255.0) alpha:1.0] setFill];
        NSRectFill(dirtyRect);
    }
    NSBezierPath *path = [NSBezierPath bezierPath];
    [path moveToPoint:NSMakePoint(0, 0)];
    [path lineToPoint:NSMakePoint(self.frame.size.width, 0)];
    [path setLineWidth:1];
    [[NSColor grayColor] setStroke];
    [path stroke];
    
    
    [super drawRect:dirtyRect];
}
@end
