//
//  CoreDataViewController.h
//  Productivity2
//
//  Created by Kim on 08/06/15.
//  Copyright (c) 2015 Kim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "AppDelegate.h"
#import "Goal.h"
#import "Session.h"

@interface CoreDataViewController : UIViewController <NSFetchedResultsControllerDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) NSManagedObjectContext *context;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (NSManagedObjectContext *)managedObjectContext;
- (void)saveManagedObjectContext;
- (void)performFetch;

@end
