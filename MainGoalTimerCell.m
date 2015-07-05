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
    
    self.optionsButton.showsTouchWhenHighlighted = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
