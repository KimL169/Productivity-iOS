//
//  NSNumber+time.m
//  Productivity2
//
//  Created by Kim on 06/06/15.
//  Copyright (c) 2015 Kim. All rights reserved.
//

#import "NSNumber+time.h"

@implementation NSNumber (time)

- (int)hours {
    int hours = [self intValue] / 3600;
    return hours;
}

- (int)minutes {
    int minutes = [self intValue] % 3600 / 60;
    return minutes;
}

- (int)minutesMinusHours {
    int hours = [self hours];
    int remainingSeconds = [self intValue] - (hours * 3600);
    return remainingSeconds % 3600 / 60;
}

- (int)secondsMinusMinutesMinutesHours{
    int remainingSeconds = [self intValue];
    remainingSeconds -= ([self hours] * 3600);
    remainingSeconds -= ([self minutes] * 60);
    
    return remainingSeconds;
}

@end
