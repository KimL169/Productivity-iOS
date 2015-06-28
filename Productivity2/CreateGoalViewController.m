//
//  CreateGoalViewController.m
//  Productivity2
//
//  Created by Kim on 04/06/15.
//  Copyright (c) 2015 Kim. All rights reserved.
//

#import "CreateGoalViewController.h"
#import "Goal+Helper.h"

@interface CreateGoalViewController ()
@property (weak, nonatomic) IBOutlet UITextField *goalNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *hoursTextField;
@property (weak, nonatomic) IBOutlet UITextField *minutesTextField;
@property (weak, nonatomic) IBOutlet UITextField *secondsTextField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *goalModeSegmentControl;

@end

@implementation CreateGoalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _addGoal = [NSEntityDescription insertNewObjectForEntityForName:@"Goal" inManagedObjectContext:[self managedObjectContext]];
    // Do any additional setup after loading the view.
}
- (IBAction)cancelButton:(UIBarButtonItem *)sender {
    
    [[self managedObjectContext] rollback];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)saveButton:(UIBarButtonItem *)sender {
    
    
    if (![self setGoalValues]) {
        
    }
#warning learn about custom getters and setters to immediately change the textfield input to seconds upon entering.
    [self saveManagedObjectContext];
    [self dismissViewControllerAnimated:YES completion:nil];

}

- (BOOL)setGoalValues{
    _addGoal.name = _goalNameTextField.text;
    _addGoal.mode = [NSNumber numberWithInt:(int)_goalModeSegmentControl.selectedSegmentIndex];
    _addGoal.plannedRounds = [NSNumber numberWithInt:5];
    _addGoal.plannedSessionTime = [NSNumber numberWithInt:10];
    _addGoal.totalTimeInSeconds = [NSNumber numberWithInt:0];
    return true;
}

- (IBAction)goalModeSegmentControl:(UISegmentedControl *)sender {
    NSLog(@"goalMode changed");
    switch (sender.selectedSegmentIndex) {
        case GoalCountDownMode:
            //change the UI to the correct type of setting
            break;
        case GoalStopWatchMode:
            //change the UI to the correct type of setting
            break;
        case GoalTaskMode:
            //change the UI to the correct type of setting
            break;
            
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
