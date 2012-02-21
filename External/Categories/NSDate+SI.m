//
//  NSDate+SI.m
//  StackInbox
//
//  Created by Jonathan Bailey on 28/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "NSDate+SI.h"

@implementation NSDate (SI)
+(NSString *)highestSignificantComponentStringFromDate:(NSDate *)date toDate:(NSDate *)toDate {
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit |NSSecondCalendarUnit
                                                                   fromDate:date
                                                                     toDate:toDate
                                                                    options:0];
    if ([components year] != 0) {
        return [NSString stringWithFormat:@"%iy", components.year];
    }
    if ([components month] != 0) {
        return [NSString stringWithFormat:@"%im", components.month];
    }
    if ([components day] != 0) {
        if ([components hour] > 12) {
            return [NSString stringWithFormat:@"%id", components.day + 1];
        } else {
            return [NSString stringWithFormat:@"%id", components.day];
        }
    }
    if ([components  hour] != 0) {
        return [NSString stringWithFormat:@"%ih", components.hour];
    }
    if ([components minute] != 0) {
        return [NSString stringWithFormat:@"%im", components.minute];
    }
    if ([components second] != 0) {
        return [NSString stringWithFormat:@"%is", components.second];
    }
    return @"0s";
}
@end
