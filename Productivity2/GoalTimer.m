//
//  CountDownTimer.m
//  Productivity2
//
//  Created by Kim on 03/04/15.
//  Copyright (c) 2015 Kim. All rights reserved.
//

#import "GoalTimer.h"

@interface GoalTimer()
@property (nonatomic) goalMode mode;
@end

@implementation GoalTimer


int hours, minutes, seconds;

- (id)init: (NSInteger)startingSecondsLeft rounds:(NSInteger)rounds{
    
    if (self = [super init]) {
        
        //get the users prefered seconds left and the user's prefered round count.
        self.startingSecondsLeft = (int)startingSecondsLeft;
        [self setValue:[NSNumber numberWithInt:(int)startingSecondsLeft] forKey:@"countingSeconds"];
        self.startingRounds = (int)rounds;
        self.roundsLeft = (int)rounds;
        self.hours = self.minutes = self.seconds = 0;
    }
    
    return self;
}

- (int)roundsLeft { return self.roundsLeft; }

- (void)startTimerWithCount:(int)seconds mode:(goalMode)mode{
    _mode = mode;
    
    if (!seconds) {seconds = 0;}
    self.hours = self.minutes = self.seconds = 0;
    self.countingSeconds = [NSNumber numberWithInt:seconds];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerUpdate) userInfo:nil repeats:YES];
    
   [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)timerUpdate {
    
    int count = [self.countingSeconds intValue];
    switch (_mode) {
        case GoalStopWatchMode:
            [self setValue:[NSNumber numberWithInt:++count] forKey:@"countingSeconds"];
            break;
        case GoalCountDownMode:
            [self setValue:[NSNumber numberWithInt:--count] forKey:@"countingSeconds"];
            break;
        default:
            break;
    }
}

- (NSInteger)minutesLeft {
    return ([_countingSeconds intValue] % 3600) / 60;
}

- (NSInteger)hoursLeft {
    return [_countingSeconds intValue] / 3600;
}

@end
