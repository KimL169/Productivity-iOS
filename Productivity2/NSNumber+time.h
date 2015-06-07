//
//  NSNumber+time.h
//  Productivity2
//
//  Created by Kim on 06/06/15.
//  Copyright (c) 2015 Kim. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNumber (time)

- (int)hours;
- (int)minutes;
- (int)minutesMinusHours;
- (int)secondsMinusMinutesMinutesHours;

@end
