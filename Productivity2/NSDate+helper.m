//
//  NSDate+helper.m
//  Productivity2
//
//  Created by Kim on 09/06/15.
//  Copyright (c) 2015 Kim. All rights reserved.
//

#import "NSDate+helper.h"

@implementation NSDate (helper)

+ (NSInteger)daysBetweenDate:(NSDate*)fromDateTime andDate:(NSDate*)toDateTime {
    
    
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorianCalendar components:NSCalendarUnitDay
                                                        fromDate:fromDateTime
                                                          toDate:toDateTime
                                                         options:0];
    
    return [components day];
}

@end
