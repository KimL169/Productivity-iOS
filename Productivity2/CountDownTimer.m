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
        self.secondsLeft = self.startingSecondsLeft;
        self.startingRounds = rounds;
        self.roundsLeft = rounds;
        
        //set the hours/minutes/seconds
        self.hours = self.minutes = self.seconds = 0;
    }
    
    return self;
}

- (void)resetCounter {
    //reset the secondsLeftCounter and update the counter.
    self.secondsLeft = self.startingSecondsLeft;
    self.hours = self.minutes = self.seconds = 0;
    [self startTimer];
}

- (int)roundsLeft { return self.roundsLeft; }

-(void)startTimer {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateCounter) userInfo:nil repeats:YES];
   [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}


- (void)updateCounter {
    
    if (self.secondsLeft > 0) {
        self.secondsLeft --;
        
        self.hours = self.secondsLeft / 3600;
        self.minutes = (self.secondsLeft % 3600) / 60;
        self.seconds = (self.secondsLeft % 3600) % 60;
    }
}

@end
