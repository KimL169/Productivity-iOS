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
#import "Goal+Helper.h" 
#import "Session.h"
#import "MainGoalTimerCell.h"
#import "Productivity2-Swift.h"
#import "UIView+ViewBorders.h"
#import <AudioToolbox/AudioToolbox.h>
#import <QuartzCore/QuartzCore.h>

@interface ViewController ()

@property (nonatomic, strong) GoalTimer *timer;
@property (nonatomic, strong) NSIndexPath *activeGoalIndex;
@property (nonatomic) NSUInteger selectedIndex;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *restTimerButton;
@property (weak, nonatomic) RestTimerView *restTimerView;
@property (nonatomic, weak) NSNumber *restingSeconds;
@property (nonatomic, strong) NSTimer *restTimer;

#define NUMBER_OF_SECTIONS 1;
#define CELL_HEIGHT 120
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.timer = [[GoalTimer alloc]init];
    self.tableView.delegate = self;
    self.tableView.delaysContentTouches = NO;
    
//    Goal *newGoal = [NSEntityDescription insertNewObjectForEntityForName:@"Goal" inManagedObjectContext:[super managedObjectContext]];
//    newGoal.name = @"Workout";
//    newGoal.mode = [NSNumber numberWithInt:GoalCountDownMode];
//    newGoal.plannedRounds = [NSNumber numberWithInt:5];
//    newGoal.plannedSessionTime = [NSNumber numberWithInt:10];
//    newGoal.totalTimeInSeconds = [NSNumber numberWithInt:0];
//    
//    //make a new session for the goal.
//    [newGoal returnCurrentOrNewSession];
    
   [self performFetch];
    
    _selectedIndex = -1;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //add the observer for timer
    [self.timer addObserver:self forKeyPath:@"countingSeconds" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    //remove the observer for timer
    [self.timer removeObserver:self forKeyPath:@"countingSeconds"];
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
        
        //get the current session for the goal
        Session *currentSessionForActiveGoal = [activeGoal returnCurrentOrNewSession];
       
        //update session and total time.
        currentSessionForActiveGoal.sessionTimeInSeconds = self.timer.countingSeconds;
        
        //if it's a countdownTimer update the rounds
        if ([activeGoal.mode intValue] == GoalCountDownMode && [self.timer.countingSeconds intValue]== 0) {
            currentSessionForActiveGoal.rounds = [NSNumber numberWithInt:[currentSessionForActiveGoal.rounds intValue] + 1];
            currentSessionForActiveGoal.sessionTimeInSeconds = activeGoal.plannedSessionTime;
            
            [self.timer.timer invalidate];
        }
        
        if ([self.timer.countingSeconds intValue] > 0) {
            int newTotalTime = [activeGoal.totalTimeInSeconds intValue] + 1;
            NSLog(@"newTotalTime:%d", newTotalTime);
            activeGoal.totalTimeInSeconds = [NSNumber numberWithInt:newTotalTime];
        }
        
    }
    
}

#pragma mark - Tableview methodscontext	

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    if (_selectedIndex == indexPath.row) {
        return 240;
    } else {
        return 120;
    }
}

- (void)optionsButtonWasPressed:(id)sender {
    
    //retrieve the indexpath for the button that was tapped.
    MainGoalTimerCell *clickedCell = (MainGoalTimerCell *) [[sender superview]superview];
    NSIndexPath *clickedButtonPath = [self.tableView indexPathForCell:clickedCell];
    
    if (_selectedIndex == clickedButtonPath.row) {
        _selectedIndex = -1;
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:clickedButtonPath] withRowAnimation:UITableViewRowAnimationFade];
        return;
    }
    if (_selectedIndex != -1) {
        NSIndexPath *prevPath = [NSIndexPath indexPathForRow:_selectedIndex inSection:0];
        _selectedIndex = clickedButtonPath.row;
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:prevPath] withRowAnimation:UITableViewRowAnimationFade];
        return;
    }
    
    _selectedIndex = clickedButtonPath.row;
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:clickedButtonPath] withRowAnimation:UITableViewRowAnimationFade];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //check if a timer is running, if it is, stop the timer and save the timer data to the active goal.
    //if it's not, restart a new timer for the goal that is clicked.
    if ([self.timer.timer isValid] && indexPath == _activeGoalIndex) {
        [self stopTimerForIndexPath:indexPath];
    } else if ([self.timer.timer isValid] && indexPath != _activeGoalIndex){
        
       //TODO
    } else {
        //start a new timer
        [self startNewGoalTimerForIndexPath:indexPath];
    }
    
}

- (void)startNewGoalTimerForIndexPath:(NSIndexPath*)indexPath {
    
    MainGoalTimerCell *cell = (MainGoalTimerCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    _activeGoalIndex = indexPath;
    cell.playPauseLabel.text = @"◼︎";
    
    //make the newly selected goal the active goal
    Goal *activeGoal = [self.fetchedResultsController objectAtIndexPath:_activeGoalIndex];
    //get the current session for the acitve goal
    Session *currentSessionForActiveGoal = [activeGoal returnCurrentOrNewSession];
    
    switch ([activeGoal.mode intValue]) {
        case GoalCountDownMode:
            if ([currentSessionForActiveGoal.sessionTimeInSeconds intValue] == 0) {
                currentSessionForActiveGoal.sessionTimeInSeconds = activeGoal.plannedSessionTime;
                NSLog(@"sessiontime %d", [currentSessionForActiveGoal.sessionTimeInSeconds intValue]);
            }
            break;
        case GoalStopWatchMode:
            break;
        default:
            break;
    }
    
    //initialize a new timer for the goal that was clicked
    [self.timer startTimerWithCount:[currentSessionForActiveGoal.sessionTimeInSeconds intValue] mode:[activeGoal.mode intValue]];
}

- (void)stopTimerForIndexPath:(NSIndexPath *)indexPath {
        MainGoalTimerCell *cell = (MainGoalTimerCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        cell.playPauseLabel.text = @"▶︎";
        
        //stop the timer
        [self.timer.timer invalidate];
    
//TODO: if countdown it needs to finish the session in order to be counted!!
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Goal *goalToDelete = [self.fetchedResultsController objectAtIndexPath:indexPath];
        
        [[self managedObjectContext] deleteObject:goalToDelete];
        [self saveManagedObjectContext];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"itemCell";
    
    MainGoalTimerCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"MainGoalTimerCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(MainGoalTimerCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Goal *goal = [self.fetchedResultsController objectAtIndexPath:indexPath];
    Session *currentSessionForActiveGoal = [goal returnCurrentOrNewSession];
    NSLog(@"rounds: %d", [currentSessionForActiveGoal.rounds intValue]);
    cell.nameLabel.text = goal.name;
    cell.timeLabel.text = [NSString stringWithFormat:@"%.2d:%.2d:%.2d", [currentSessionForActiveGoal.sessionTimeInSeconds hours], [currentSessionForActiveGoal.sessionTimeInSeconds minutesMinusHours], [currentSessionForActiveGoal.sessionTimeInSeconds secondsMinusMinutesMinutesHours]];
    
    if ([goal.mode intValue] == GoalCountDownMode) {
        cell.roundsLabel.text = [NSString stringWithFormat:@"%d / %d",[currentSessionForActiveGoal.rounds intValue], [goal.plannedRounds intValue]];
    } else {
        cell.roundsLabel.text = @"";
    }
    
    cell.totalTimeLabel.text = [NSString stringWithFormat:@"%dh %dm", [goal.totalTimeInSeconds hours], [goal.totalTimeInSeconds minutesMinusHours]];
    
    if (indexPath == _activeGoalIndex && [self.timer.timer isValid]) {
        cell.playPauseLabel.text = @"◼︎";
    } else {
        cell.playPauseLabel.text = @"▶︎";
    }
    [cell.optionsButton addTarget:self action:@selector(optionsButtonWasPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    //make sure the cell's UI get covered when the cell size changes.
    cell.clipsToBounds = YES;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
#warning incomplete implementation of the color change;
    //change the clockview color depending on goal completion status
    [cell changeClockViewColorForGoal:currentSessionForActiveGoal];
    
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}


- (IBAction)restTimerButtonPressed:(UIBarButtonItem *)sender {
    
    self.restTimerView = [RestTimerView instanceFromNib];
    //get the resting time from the user defaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    _restingSeconds = [defaults objectForKey:@"restTime"];
    
    //add a little edge to the view and add it to the view;
    _restTimerView.center = self.view.center;
    [_restTimerView setUI];
    [self.view addSubview:_restTimerView];
    
    _restTimerView.timerLabel.text = [NSString stringWithFormat:@"%.2d:%.2d:%.2d",[_restingSeconds hours], [_restingSeconds minutesMinusHours], [_restingSeconds secondsMinusMinutesMinutesHours]];
    
    //check if a timer is active, if so stop it to start the rest timer.
    if ([self.timer.timer isValid]) {
        [self stopTimerForIndexPath:_activeGoalIndex];
    }
    
    //start a new timer for the countdown.
    _restTimer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(restTimerCountDown) userInfo:nil repeats:YES];//Timer with interval of one second
    [[NSRunLoop mainRunLoop] addTimer:_restTimer forMode:NSDefaultRunLoopMode];
    
    //disable the user interaction in view and add a gesturecontroll to the restTimerView;
    [self.tableView setUserInteractionEnabled:NO];
    UITapGestureRecognizer *gR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissRestTimer)];
    [_restTimerView addGestureRecognizer:gR];
}

-(void)dismissRestTimer {
   //dismiss the rest timer and remove the view
    [_restTimer invalidate];
    [_restTimerView removeFromSuperview];
    //enable user interaction with the view;
    [self.tableView setUserInteractionEnabled:YES];
}
- (void)restTimerCountDown{
    _restingSeconds = [NSNumber numberWithInt:[_restingSeconds intValue]-1];
    
    if ([_restingSeconds intValue] == 0) {
        //play an alarm and change the view's UI to show the timer is finished.
        AudioServicesPlaySystemSound(1106);
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        [_restTimer invalidate];
        
        _restTimerView.backgroundColor = [UIColor whiteColor];
        [_restTimerView.timerLabel setTextColor:[UIColor blackColor]];
        [_restTimerView.tapToCloseLabel setTextColor:[UIColor blackColor]];
        _restTimerView.timerLabel.text = @"Time's up! :)";
    } else {
        _restTimerView.timerLabel.text = [NSString stringWithFormat:@"%.2d:%.2d:%.2d",[_restingSeconds hours], [_restingSeconds minutesMinusHours], [_restingSeconds secondsMinusMinutesMinutesHours]];
    }
}

#pragma mark - segue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    
    //segue to the viewcontroller for adding goals.
    if ([[segue identifier] isEqualToString:@"addGoal"]) {
        
#warning think about this do we need to save here?
        [self saveManagedObjectContext];
    }
}

@end
