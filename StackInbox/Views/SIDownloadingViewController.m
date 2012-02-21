//
//  SIDownloadingViewController.m
//  StackInbox
//
//  Created by Jonathan Bailey on 11/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SIDownloadingViewController.h"

@implementation SIDownloadingViewController
@synthesize activity;
@synthesize progressBar;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

-(void)awakeFromNib {
    [self.activity startAnimation:nil];
}
-(void)viewControllerWillMoveFromParent {
    [self.progressBar setDoubleValue:0];
}
@end
