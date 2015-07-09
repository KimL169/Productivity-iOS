//
//  MainGoalTimerCell.h
//  Productivity2
//
//  Created by Kim on 03/04/15.
//  Copyright (c) 2015 Kim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoalTimer.h"
#import "Goal+Helper.h"
#import "Productivity2-Swift.h"
#import "Session.h"

@interface MainGoalTimerCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *playPauseLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalTimeLabel;
@property (weak, nonatomic) IBOutlet UIView *completionView;
@property (weak, nonatomic) IBOutlet UILabel *roundsLabel;
@property (weak, nonatomic) IBOutlet UIButton *optionsButton;
@property (strong, nonatomic) IBOutlet CountDownClockView *clockView;

- (void)changeClockViewColorForGoal:(Session *)goal;

@end
