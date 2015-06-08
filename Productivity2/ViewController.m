//
//  ViewController.m
//  Productivity2
//
//  Created by Kim on 03/04/15.
//  Copyright (c) 2015 Kim. All rights reserved.
//

#import "ViewController.h"
#import "GoalTimer.h"
#import "Goal.h"
#import "CreateGoalViewController.h"
#import "NSNumber+time.h"
#import "MainGoalTimerCell.h"

@interface ViewController ()

@property (nonatomic, strong) GoalTimer *timer;
@property (nonatomic, strong) NSIndexPath *activeGoalIndex;

#define CELL_HEIGHT 120

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.timer = [[GoalTimer alloc]init];
    
//TODO: we need to specify a context?
    [self.timer addObserver:self forKeyPath:@"countingSeconds" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    
    Goal *newGoal = [NSEntityDescription insertNewObjectForEntityForName:@"Goal" inManagedObjectContext:[super managedObjectContext]];
    newGoal.name = @"Workout";
    newGoal.mode = [NSNumber numberWithInt:GoalStopWatchMode];
    newGoal.rounds = [NSNumber numberWithInt:0];
    newGoal.plannedRounds = [NSNumber numberWithInt:5];
    newGoal.plannedSessionTime = [NSNumber numberWithInt:0];
    newGoal.sessionTimeInSeconds = [NSNumber numberWithInt:0];
    
    [self saveManagedObjectContext];
    [self performFetch];
}

#pragma mark - timer methods
/**********
* Observes the changes in the states of keyvalue objects
* Specifically the Timer changes are monitored here.
*******/
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if (object == self.timer && [keyPath isEqualToString:@"countingSeconds"]){
        
        //get the active goal and adjust the time value
        Goal* activeGoal = [self.fetchedResultsController objectAtIndexPath:_activeGoalIndex];
       
        //update session and total time.
        activeGoal.sessionTimeInSeconds = self.timer.countingSeconds;
        
        //if it's a countdownTimer update the rounds
        if ([activeGoal.mode intValue] == GoalCountDownMode && [self.timer.countingSeconds intValue]== 0) {
            activeGoal.rounds = [NSNumber numberWithInt:[activeGoal.rounds intValue] + 1];
            activeGoal.sessionTimeInSeconds = activeGoal.plannedSessionTime;
            
            [self.timer.timer invalidate];
        }
        
        int newTotalTime = [activeGoal.totalTimeInSeconds intValue] + 1;
        activeGoal.totalTimeInSeconds = [NSNumber numberWithInt:newTotalTime];
    }
}

- (void)deallocTimerObserver {
    [self.timer removeObserver:self forKeyPath:@"countingSeconds"];
}


#pragma mark - Tableview methodscontext	void *	NULL	0x0000000000000000



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return CELL_HEIGHT;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //check if a timer is running, if it is, stop the timer and save the timer data to the active goal.
    //if it's not, restart a new timer for the goal that is clicked.
    if ([self.timer.timer isValid] && indexPath == _activeGoalIndex) {
        
        [self stopTimerForIndexPath:indexPath];
        
    } else if ([self.timer.timer isValid] && indexPath != _activeGoalIndex){
        
//TODO: notifiy user that he cannot press the tableview because another is busy..
    } else {
        
        //start a new timer
        [self startNewGoalTimerForIndexPath:indexPath];
    }
}

- (void)startNewGoalTimerForIndexPath:(NSIndexPath*)indexPath {
    
    MainGoalTimerCell *cell = (MainGoalTimerCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    cell.playPauseLabel.text = @"◼︎";
    
    //make the newly selected goal the active goal
    _activeGoalIndex = [self.tableView indexPathForCell:cell];
    Goal *activeGoal = [self.fetchedResultsController objectAtIndexPath:_activeGoalIndex];
    
    switch ([activeGoal.mode intValue]) {
        case GoalCountDownMode:
            if (activeGoal.sessionTimeInSeconds == 0) {
                activeGoal.sessionTimeInSeconds = activeGoal.plannedSessionTime;
            }
            break;
        case GoalStopWatchMode:
            
            break;
        default:
            break;
    }
    
    //initialize a new timer for the goal that was clicked
    [self.timer startTimerWithCount:[activeGoal.sessionTimeInSeconds intValue] mode:[activeGoal.mode intValue]];
}

- (void)stopTimerForIndexPath:(NSIndexPath *)indexPath {
        MainGoalTimerCell *cell = (MainGoalTimerCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        cell.playPauseLabel.text = @"▶︎";
        
        //stop the timer
        [self.timer.timer invalidate];
    
//TODO: if countdown it needs to finish the session in order to be counted!!
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(MainGoalTimerCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    Goal *goal = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.nameLabel.text = goal.name;
    if (goal.sessionTimeInSeconds) {
        cell.timeLabel.text = [NSString stringWithFormat:@"%.2d:%.2d:%.2d", [goal.sessionTimeInSeconds hours], [goal.sessionTimeInSeconds minutesMinusHours], [goal.sessionTimeInSeconds secondsMinusMinutesMinutesHours]];
    }
    
    if ([goal.mode intValue] == GoalCountDownMode) {
        cell.roundsLabel.text = [NSString stringWithFormat:@"%d / %d",[goal.rounds intValue], [goal.plannedRounds intValue]];
    } else {
        cell.roundsLabel.text = @"";
    }
    
    cell.totalTimeLabel.text = [NSString stringWithFormat:@"%dh %dm", [goal.totalTimeInSeconds hours], [goal.totalTimeInSeconds minutesMinusHours]];
    
    if (indexPath == _activeGoalIndex && [self.timer.timer isValid]) {
        cell.playPauseLabel.text = @"◼︎";
    } else {
        cell.playPauseLabel.text = @"▶︎";
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObjectContext *context = [super managedObjectContext];
        Goal *goalToDelete = [self.fetchedResultsController objectAtIndexPath:indexPath];
        [context deleteObject:goalToDelete];

//TODO: moet dit hier wel?
#warning deze save zit hier verkeerd? download de XTDO plugin voor xcode om //TODO messages in warnings te veranderen.
        NSError *error = nil;
        if (![context save:&error]) {
            NSLog(@"Error saving delete %@", error);
        }
    }
}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}



#pragma mark - segue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    //segue to the viewcontroller for adding goals.
    if ([[segue identifier] isEqualToString:@"addGoal"]) {
        
        UINavigationController *navigationController = segue.destinationViewController;
        CreateGoalViewController *vc = (CreateGoalViewController *)navigationController.topViewController;
        Goal *addGoal = [NSEntityDescription insertNewObjectForEntityForName:@"Goal" inManagedObjectContext:[self managedObjectContext]];
        vc.addGoal = addGoal;
    }
}

@end
