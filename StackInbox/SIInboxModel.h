//
//  SIInboxModel.h
//  StackInbox
//
//  Created by Jonathan Bailey on 19/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


extern NSString * const SIInboxItemTypeComment;
extern NSString * const SIInboxItemTypeChatMessage;
extern NSString * const SIInboxItemTypeNewAnswer;
extern NSString * const SIInboxItemTypeCareersMessage;
extern NSString * const SIInboxItemTypeCareersInvites;
extern NSString * const SIInboxItemTypeMetaQuestion;
typedef NSString* SIInboxItemType;

@interface SIInboxModel : NSObject <NSCoding>
@property (retain) NSString *title;
@property (retain) NSString *body;
@property (retain) NSDate *creationDate;
@property (retain) NSString *link;
@property (assign) BOOL isUnread;
@property (retain) NSString *siteIconLink;
@property (retain) NSString *siteName;
@property (retain) SIInboxItemType type;
@property (assign) BOOL isAPIUnread;
-(NSNumber *)creationTINumber;
-(NSURL *)siteIconURL;
-(NSURL *)linkURL;
-(void)setUnread;
-(void)setRead;
+(SIInboxModel *)inboxItemUsingDictionary:(NSDictionary *)dict;
@end
