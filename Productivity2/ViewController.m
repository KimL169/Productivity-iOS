//
//  ViewController.m
//  Productivity2
//
//  Created by Kim on 03/04/15.
//  Copyright (c) 2015 Kim. All rights reserved.
//

#import "ViewController.h"
#import "MainGoalTimerCell.h"
#import "CountDownTimer.h"
@interface ViewController ()

@property (nonatomic, strong) CountDownTimer *timer;
@property (nonatomic, strong) NSIndexPath *activeGoalIndex;

#define CELL_HEIGHT 120

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.timer = [[CountDownTimer alloc]init:10 rounds:1];
    
//TODO: we need to specify a context?
    [self.timer addObserver:self forKeyPath:@"secondsLeft" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 10;
}

/**********
* Observes the changes in the states of keyvalue objects
* Specifically the Timer changes are monitored here.
*******/
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if (object == self.timer && [keyPath isEqualToString:@"secondsLeft"]){
        //grab the active cell and adjust the label
        [self updateCellTimerLabel];
    }
    
}

- (void)deallocTimerObserver {
    [self.timer removeObserver:self forKeyPath:@"secondsLeft"];
}

- (void)updateCellTimerLabel {
    
    //get the active goal from the active cell property.
    MainGoalTimerCell *cell = (MainGoalTimerCell *)[self.tableView cellForRowAtIndexPath:_activeGoalIndex];
    cell.timeLabel.text = [NSString stringWithFormat:@"%d", [self.timer.secondsLeft integerValue]];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"timerCell";
    
    MainGoalTimerCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"MainGoalTimerCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return CELL_HEIGHT;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MainGoalTimerCell *cell = (MainGoalTimerCell *)[self.tableView cellForRowAtIndexPath:indexPath];

    //check if a timer is running, if it is, stop the timer and save the timer data to the active goal.
    //if it's not, restart a new timer for the goal that is clicked.
    if ([self.timer.timer isValid]) {
        
        //stop the timer
        [self.timer.timer invalidate];
        
    } else {
        //save the previous time to the relevant goal  (???YES??)
        
       //append the new active goal to the active goal property
        _activeGoalIndex = [self.tableView indexPathForCell:cell];
        
        //initialize a new timer
        [self deallocTimerObserver];
        self.timer = [[CountDownTimer alloc] init:10 rounds:1];
        
        //start the timer for the newly selected goal.
        [self.timer startTimer];
    }
    
}

@end
