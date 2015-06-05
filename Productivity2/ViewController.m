//
//  ViewController.m
//  Productivity2
//
//  Created by Kim on 03/04/15.
//  Copyright (c) 2015 Kim. All rights reserved.
//

#import "ViewController.h"
#import "MainGoalTimerCell.h"
#import "GoalTimer.h"
#import "Goal.h"

@interface ViewController ()

@property (nonatomic, strong) GoalTimer *timer;
@property (nonatomic, strong) NSIndexPath *activeGoalIndex;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) NSManagedObjectContext *context;

#define CELL_HEIGHT 120

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.timer = [[GoalTimer alloc]init];
    
//TODO: we need to specify a context?
    [self.timer addObserver:self forKeyPath:@"countingSeconds" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    
//    insert a test goal
//    Goal *newGoal = [NSEntityDescription insertNewObjectForEntityForName:@"Goal" inManagedObjectContext:[self managedObjectContext]];
//    newGoal.name = @"Play Guitar";
//    newGoal.mode = [NSNumber numberWithInt:GoalCountDownMode];
//    newGoal.sessionTimeInSeconds = [NSNumber numberWithInt:1000];
    
//    if ([self.managedObjectContext hasChanges]){
//        if (![self.managedObjectContext save: &error]) {//save failed
//            NSLog(@"Save failed: %@", [error localizedDescription]);
//        } else {
//            NSLog(@"Save succesfull");
//        }
//    }
    
    NSError *error = nil;
    if (![[self fetchedResultsController] performFetch:&error]) {
        NSLog(@"Error fetching: %@", error);
        abort();
    }
    
    
}
//TODO: save method needs to be somewhere else!
- (void)viewDidDisappear:(BOOL)animated {
        
    NSError *error = nil;
    if ([self.managedObjectContext hasChanges]){
        if (![self.managedObjectContext save: &error]) {//save failed
            NSLog(@"Save failed: %@", [error localizedDescription]);
        } else {
            NSLog(@"Save succesfull");
        }
    }
}


#pragma mark - timer methods
/**********
* Observes the changes in the states of keyvalue objects
* Specifically the Timer changes are monitored here.
*******/
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if (object == self.timer && [keyPath isEqualToString:@"countingSeconds"]){
        //grab the active cell and adjust the label
        [self updateCellTimerLabel];
        
        //get the active goal and adjust the time value
        Goal* activeGoal = [self.fetchedResultsController objectAtIndexPath:_activeGoalIndex];
       
        activeGoal.sessionTimeInSeconds = self.timer.countingSeconds;
    }
    
}

- (void)deallocTimerObserver {
    [self.timer removeObserver:self forKeyPath:@"countingSeconds"];
}

- (void)updateCellTimerLabel {
    
    //get the active goal from the active cell property.
    MainGoalTimerCell *cell = (MainGoalTimerCell *)[self.tableView cellForRowAtIndexPath:_activeGoalIndex];
    cell.timeLabel.text = [NSString stringWithFormat:@"%d", [self.timer.countingSeconds intValue]];
    
}

#pragma mark - Tableview methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections]objectAtIndex:section];
    // Return the number of rows in the section.
    return [sectionInfo numberOfObjects];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    //return the number of sections in both the bodystat and diet plan fetchedresultscontroller.
    return [[self.fetchedResultsController sections]count];
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
        
        //first store the previous session time in the previous active goal.
        Goal *activeGoal = [self.fetchedResultsController objectAtIndexPath:_activeGoalIndex];
        activeGoal.sessionTimeInSeconds = self.timer.countingSeconds;
       //append the new active goal to the active goal property
        
        //make the newly selected goal the active goal
        _activeGoalIndex = [self.tableView indexPathForCell:cell];
        activeGoal = [self.fetchedResultsController objectAtIndexPath:_activeGoalIndex];
        
        //initialize a new timer for the goal that was clicked
        [self.timer startTimerWithCount:[activeGoal.sessionTimeInSeconds intValue] mode:[activeGoal.mode intValue]];
    }
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(MainGoalTimerCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    Goal *goal = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.nameLabel.text = goal.name;
    if (goal.sessionTimeInSeconds) {
        cell.timeLabel.text = [NSString stringWithFormat:@"%d", [goal.sessionTimeInSeconds intValue]];
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

- (NSFetchedResultsController *)fetchedResultsController {
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    
    _context = [self managedObjectContext];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Goal" inManagedObjectContext:_context];
    
    //set the fetch request to the Patient entity
    [fetchRequest setEntity:entity];
    
    //sort on patients last name, ascending;
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]initWithKey:@"name" ascending:YES];
    
    //make an array of the descriptor because the fetchrequest argument takes an array.
    NSArray *sortDescriptors = [[NSArray alloc]initWithObjects:sortDescriptor, nil];
    
    //now assign the sort descriptors to the fetchrequest.
    fetchRequest.sortDescriptors = sortDescriptors;
    
    _fetchedResultsController = [[NSFetchedResultsController alloc]initWithFetchRequest:fetchRequest managedObjectContext:_context sectionNameKeyPath:nil cacheName:nil];
    
    _fetchedResultsController.delegate = self;
    
    return _fetchedResultsController;
}

@end
