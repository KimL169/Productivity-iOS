//
//  CountDownTimer.m
//  Productivity2
//
//  Created by Kim on 03/04/15.
//  Copyright (c) 2015 Kim. All rights reserved.
//

#import "GoalTimer.h"

@implementation GoalTimer


int hours, minutes, seconds;

- (id)init: (NSInteger)startingSecondsLeft rounds:(NSInteger)rounds{
    
    if (self = [super init]) {
        
        //get the users prefered seconds left and the user's prefered round count.
        self.startingSecondsLeft = (int)startingSecondsLeft;
        [self setValue:[NSNumber numberWithInt:(int)startingSecondsLeft] forKey:@"countingSeconds"];
        self.startingRounds = (int)rounds;
        self.roundsLeft = (int)rounds;
        
        NSLog(@"secondsLeft: %d", [self.countingSeconds intValue]);
        //set the hours/minutes/seconds
        self.hours = self.minutes = self.seconds = 0;
    }
    
    return self;
}

- (int)roundsLeft { return self.roundsLeft; }

- (void)startTimerWithCount:(int)seconds mode:(goalMode)mode{
    
    if (!seconds) {seconds = 0;}
    self.hours = self.minutes = self.seconds = 0;
   
    switch (mode) {
        case GoalStopWatchMode:
            self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(stopWatchTimerUpdate) userInfo:nil repeats:YES];
            self.countingSeconds = [NSNumber numberWithInt:seconds];
            break;
        case GoalCountDownMode:
            self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countDownTimerUpdate) userInfo:nil repeats:YES];
            self.countingSeconds = [NSNumber numberWithInt:seconds];
            break;
        default:
            self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(stopWatchTimerUpdate) userInfo:nil repeats:YES];
            self.countingSeconds = [NSNumber numberWithInt:seconds];
            break;
    }
   [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}


- (void)countDownTimerUpdate {
//TODO: is this right?
    int secondsLeft = [self.countingSeconds intValue];
    if ([self.countingSeconds integerValue]> 0) {
        secondsLeft--;
        [self setValue:[NSNumber numberWithInt:secondsLeft] forKey:@"countingSeconds"];
    }
}

- (void)stopWatchTimerUpdate {
    int count = [[self valueForKey:@"countingSeconds"] intValue];
    [self setValue:[NSNumber numberWithInt:++count] forKey:@"countingSeconds"];
    NSLog(@"count: %d", count);
}

- (NSInteger)minutesLeft {
    return ([_countingSeconds intValue] % 3600) / 60;
}

- (NSInteger)hoursLeft {
    return [_countingSeconds intValue] / 3600;
}

@end
