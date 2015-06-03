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
        [self.timer resetTimer];
        //start the timer for the newly selected goal.
    }
    
}

#pragma mark - NSFetchedResultsControllerDelegate

- (NSManagedObjectContext *)managedObjectContext {
    return  [(AppDelegate *)[[UIApplication sharedApplication]delegate]managedObjectContext];
    
}

- (NSArray *)performFetchWithEntityName:(NSString *)entityName
                              predicate:(NSPredicate *)predicate
                         sortDescriptor:(NSSortDescriptor *)sortDescriptor {
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    // Specify criteria for filtering which objects to fetch
    [fetchRequest setPredicate:predicate];
    // Specify how the fetched objects should be sorted
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects == nil) {
        NSLog(@"error fetching: %@", error);
    }
    
    return fetchedObjects;
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

//if changes to a section occured.
- (void)controller:(NSFetchedResultsController *)controller
  didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
		   atIndex:(NSUInteger)sectionIndex
	 forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type)
    {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

//if changes to an object occured.
- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
	   atIndexPath:(NSIndexPath *)indexPath
	 forChangeType:(NSFetchedResultsChangeType)type
	  newIndexPath:(NSIndexPath *)newIndexPath
{
    
    // responses for type (insert, delete, update, move).
    switch(type)
    {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeMove:
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}



@end
