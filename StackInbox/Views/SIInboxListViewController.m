//
//  SIInboxListViewController.m
//  StackInbox
//
//  Created by Jonathan Bailey on 11/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SIInboxListViewController.h"
#import "SIListViewCell.h"
#import "SIInboxModel.h"

@implementation SIInboxListViewController
@synthesize listView, itemsToList;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}
-(void)awakeFromNib {
    [self.listView setPostsBoundsChangedNotifications:YES];
    [self.listView setDelegate:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(boundsDidChange:) name:NSViewBoundsDidChangeNotification object:nil];
}

-(void)boundsDidChange:(NSNotification *)note {
    if (self.listView.contentView.bounds.origin.y < 10) {
        [[NSApplication sharedApplication].dockTile setBadgeLabel:nil];        
    }
}


-(NSUInteger)numberOfRowsInListView:(PXListView *)aListView {
    return [self.itemsToList count];
}


-(PXListViewCell *)listView:(PXListView *)aListView cellForRow:(NSUInteger)row {
    SIListViewCell *cell = (SIListViewCell *)[aListView dequeueCellWithReusableIdentifier:@"CellID"];
    if (cell == nil) {
        cell = [SIListViewCell cellLoadedFromNibNamed:@"CellNib" reusableIdentifier:@"CellID"];
    }
    SIInboxModel *item = [self.itemsToList objectAtIndex:row];
    
    NSString *str = item.title;
    if (item.type == SIInboxItemTypeComment) {
        str = [NSString stringWithFormat:@"comment on %@", item.title];
    } else if (item.type == SIInboxItemTypeNewAnswer) {
        str = [NSString stringWithFormat:@"new answer on %@", item.title];
    }
    [cell.textLabel setStringValue:str];
    
    
    cell.imageView.imageURL = item.siteIconURL;
    
    
    [cell.detailTextLabel setStringValue:[item.body stringByAppendingString:@"..."]];
    
    [cell.timeField setStringValue:[NSDate highestSignificantComponentStringFromDate:item.creationDate toDate:[NSDate date]]];
    if (item.isUnread) {
        cell.backgroundColor = [NSColor colorWithDeviceRed:(0xF4 / 255.0) green:(0xF2 / 255.0) blue:(0xDE / 255.0) alpha:1.0];
    }
    return cell;
}
-(CGFloat)listView:(PXListView *)aListView heightOfRow:(NSUInteger)row {
    return 65;
}

-(void)listViewSelectionDidChange:(NSNotification *)aNotification {
    SIInboxModel *item = [self.itemsToList objectAtIndex:self.listView.selectedRow];
    
    [[NSWorkspace sharedWorkspace] openURL:item.linkURL];
    [item setRead];
    [self.listView reloadData];
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"KeepInboxWhenItemOpened"]) {
        [NSApp activateIgnoringOtherApps:YES];
    }
    
}

@end
