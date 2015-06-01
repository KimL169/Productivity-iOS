//
//  MainGoalTimerCell.m
//  Productivity2
//
//  Created by Kim on 03/04/15.
//  Copyright (c) 2015 Kim. All rights reserved.
//

#import "MainGoalTimerCell.h"

@implementation MainGoalTimerCell

- (void)awakeFromNib {
    
    //Initialize the timer here so that every cell has its own timer running when pressed.
    self.timer = [[CountDownTimer alloc]init:10 rounds:1];
}

- (void)updateTimeLabel {
    //while there are still seconds left, keep updating the label
    while (self.timer.secondsLeft != 0) {
        int tempSec = self.timer.secondsLeft;
        if (tempSec > self.timer.secondsLeft) {
            self.timeLabel.text = [NSString stringWithFormat:@"%d", self.timer.secondsLeft];
        }
        
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



@end
