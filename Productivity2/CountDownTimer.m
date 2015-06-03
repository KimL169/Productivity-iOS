//
//  CountDownTimer.m
//  Productivity2
//
//  Created by Kim on 03/04/15.
//  Copyright (c) 2015 Kim. All rights reserved.
//

#import "CountDownTimer.h"

@implementation CountDownTimer

int hours, minutes, seconds;

- (id)init: (NSInteger)startingSecondsLeft rounds:(NSInteger)rounds{
    
    if (self = [super init]) {
        
        //get the users prefered seconds left and the user's prefered round count.
        self.startingSecondsLeft = startingSecondsLeft;
        [self setValue:[NSNumber numberWithInt:startingSecondsLeft] forKey:@"secondsLeft"];
        self.startingRounds = rounds;
        self.roundsLeft = rounds;
        
        NSLog(@"secondsLeft: %d", [self.secondsLeft intValue]);
        //set the hours/minutes/seconds
        self.hours = self.minutes = self.seconds = 0;
    }
    
    return self;
}

- (void)resetTimer {
    //reset the secondsLeftCounter and update the counter.
    [self setValue:[NSNumber numberWithInt:self.startingSecondsLeft] forKey:@"secondsLeft"];
    self.hours = self.minutes = self.seconds = 0;
    [self.timer invalidate];
    [self startTimer];
}

- (int)roundsLeft { return self.roundsLeft; }

-(void)startTimer {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateCounter) userInfo:nil repeats:YES];
   [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}


- (void)updateCounter {
    
    int secondsLeft = [self.secondsLeft intValue];
    if ([self.secondsLeft integerValue]> 0) {
        secondsLeft--;
        [self setValue:[NSNumber numberWithInt:secondsLeft] forKey:@"secondsLeft"];
//        int hours = secondsLeft / 3600;
//        int minutes = (secondsLeft % 3600) / 60;
//        int seconds = (secondsLeft % 3600) % 60;
//        
//        self.hours = secondsLeft / 3600;
//        self.minutes = (secondsLeft % 3600) / 60;
//        self.seconds = (secondsLeft % 3600) % 60;
    }
    
}

- (NSInteger)minutesLeft {
    return ([_secondsLeft intValue] % 3600) / 60;
}

- (NSInteger)hoursLeft {
    return [_secondsLeft intValue] / 3600;
}

@end
