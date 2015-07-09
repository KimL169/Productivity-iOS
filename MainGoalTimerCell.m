//
//  MainGoalTimerCell.m
//  Productivity2
//
//  Created by Kim on 03/04/15.
//  Copyright (c) 2015 Kim. All rights reserved.
//

#import "MainGoalTimerCell.h"

@implementation MainGoalTimerCell

- (void)changeClockViewColorForGoal:(Session *)session {
   //TODO
    if ([session.goal.mode integerValue] == GoalStopWatchMode) {
        self.clockView.fillColor = [UIColor lightGrayColor];
    }
}

- (void)awakeFromNib {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
