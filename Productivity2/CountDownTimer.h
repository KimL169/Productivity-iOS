//
//  CountDownTimer.h
//  Productivity2
//
//  Created by Kim on 03/04/15.
//  Copyright (c) 2015 Kim. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CountDownTimer : NSObject

//init method
- (id)init: (NSInteger)startingSecondsLeft rounds:(NSInteger)rounds;

@property (nonatomic) NSNumber *secondsLeft;
@property (nonatomic) int startingSecondsLeft;
@property (nonatomic) int startingRounds;
@property (nonatomic) int roundsLeft;
@property (nonatomic, weak) NSTimer *timer;

//hours minutes, seconds
@property (nonatomic) int hours;
@property (nonatomic) int minutes;
@property (nonatomic) int seconds;

- (void)startTimer;
- (void)resetTimer;
- (int)roundsLeft;

@end
