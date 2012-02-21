//
//  SIViewController.m
//  
//
//  Created by Jonathan Bailey on 11/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SIViewController.h"
#import "SIAppDelegate.h"
@implementation SIViewController
@synthesize parentContainer;
@synthesize isCurrent;
-(id)init {
    return [self initWithNibName:NSStringFromClass([self class]) bundle:nil];
}
-(void)viewControllerWillMoveFromParent {
    //override
}
@end
