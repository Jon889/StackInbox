//
//  SIInboxModel.m
//  StackInbox
//
//  Created by Jonathan Bailey on 19/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SIInboxModel.h"
#import "GTMNSString+HTML.h"
NSString * const SIInboxItemTypeComment = @"comment";
NSString * const SIInboxItemTypeChatMessage = @"chat_message";
NSString * const SIInboxItemTypeNewAnswer = @"new_answer";
NSString * const SIInboxItemTypeCareersMessage = @"careers_message";
NSString * const SIInboxItemTypeCareersInvites = @"careers_invitations";
NSString * const SIInboxItemTypeMetaQuestion = @"meta_question";

@implementation SIInboxModel
@synthesize title, body, creationDate, link, isUnread, siteIconLink, siteName, type, isAPIUnread;
-(NSNumber *)creationTINumber {
    return [NSNumber numberWithDouble:[self.creationDate timeIntervalSince1970]];
}
-(NSURL *)siteIconURL {
    return [NSURL URLWithString:self.siteIconLink];
}
-(NSURL *)linkURL {
    return [NSURL URLWithString:self.link];
}
+(SIInboxModel *)inboxItemUsingDictionary:(NSDictionary *)dict {
    SIInboxModel *retItem = [[SIInboxModel alloc] init];
    retItem.title = [dict objectForKey:@"title"];
    retItem.body = [[dict objectForKey:@"body"] gtm_stringByUnescapingFromHTML];
    retItem.creationDate = [NSDate dateWithTimeIntervalSince1970:[[dict objectForKey:@"creation_date"] doubleValue]];
    retItem.link = [dict objectForKey:@"link"];
    retItem.isAPIUnread = [[dict objectForKey:@"is_unread"] boolValue];
    retItem.siteIconLink = [[dict objectForKey:@"site"] objectForKey:@"icon_url"];
    retItem.siteName = [[dict objectForKey:@"site"] objectForKey:@"name"];
    retItem.type = [dict objectForKey:@"type"];
    return [retItem autorelease];
}
-(void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeObject:self.body forKey:@"body"];
    [aCoder encodeObject:self.creationDate forKey:@"creationDate"];
    [aCoder encodeObject:self.link forKey:@"link"];
    [aCoder encodeBool:self.isUnread forKey:@"isUnread"];
    [aCoder encodeBool:self.isAPIUnread forKey:@"isAPIUnread"];
    [aCoder encodeObject:self.siteIconLink forKey:@"siteIconLink"];
    [aCoder encodeObject:self.siteName forKey:@"siteName"];
    [aCoder encodeObject:self.type forKey:@"type"];
}
-(id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [self init]) {
        self.title = [aDecoder decodeObjectForKey:@"title"];
        self.body = [aDecoder decodeObjectForKey:@"body"];
        self.creationDate = [aDecoder decodeObjectForKey:@"creationDate"];
        self.link = [aDecoder decodeObjectForKey:@"link"];
        self.isUnread = [aDecoder decodeBoolForKey:@"isUnread"];
        self.isAPIUnread = [aDecoder decodeBoolForKey:@"isAPIUnread"];
        self.siteIconLink = [aDecoder decodeObjectForKey:@"siteIconLink"];
        self.siteName = [aDecoder decodeObjectForKey:@"siteName"];
        self.type = [aDecoder decodeObjectForKey:@"type"];
    }
    return self;
}
-(void)dealloc {
    [title release];
    [body release];
    [creationDate release];
    [link release];
    [siteIconLink release];
    [siteName release];
    [type release];
    [super dealloc];
}
-(void)setUnread {
    self.isUnread = YES;
}
-(void)setRead {
    self.isUnread = NO;
}
@end
