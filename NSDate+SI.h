//
//  NSDate+SI.h
//  StackInbox
//
//  Created by Jonathan Bailey on 28/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (SI)
+(NSString *)highestSignificantComponentStringFromDate:(NSDate *)date toDate:(NSDate *)toDate;
@end
