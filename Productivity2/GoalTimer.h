//
//  CountDownTimer.h
//  Productivity2
//
//  Created by Kim on 03/04/15.
//  Copyright (c) 2015 Kim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Goal.h"

@interface GoalTimer : NSObject

//GoalTimer modes
typedef NS_ENUM(NSInteger, timerMode){
    GoalTimerCountDownMode,
    GoalTimerStopWatchMode
};

//init method
- (id)init: (NSInteger)startingSecondsLeft rounds:(NSInteger)rounds;

@property (nonatomic) NSNumber *countingSeconds;

@property (nonatomic) int startingSecondsLeft;
@property (nonatomic) int startingRounds;
@property (nonatomic) int roundsLeft;
@property (nonatomic, weak) NSTimer *timer;

//hours minutes, seconds
@property (nonatomic) int hours;
@property (nonatomic) int minutes;
@property (nonatomic) int seconds;

- (void)startTimerWithCount:(int)seconds mode:(goalMode)mode;
- (void)resetTimer;
- (int)roundsLeft;

@end
