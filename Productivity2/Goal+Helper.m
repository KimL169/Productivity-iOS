//
//  Goal+Helper.m
//  Productivity2
//
//  Created by Kim on 12/06/15.
//  Copyright (c) 2015 Kim. All rights reserved.
//

#import "Goal+Helper.h"
#import "NSDate+helper.h"
#import "Session.h"

@implementation Goal (Helper)


- (Session *)returnCurrentOrNewSession {
    //first check if there is an active session
    // if there is an active session -> check if the date has expired or not.
    // if the date has expired, throw away the session and start a new one.
    Session * currentSession = [self fetchCurrentSessionForGoal];
    
    if (currentSession) {
        if ([NSDate daysBetweenDate:currentSession.date andDate:[NSDate date]] == 0) {
            return currentSession;
        }
    }
    
    Session *newSession = [NSEntityDescription insertNewObjectForEntityForName:@"Session" inManagedObjectContext:[super managedObjectContext]];
    newSession.date = [NSDate setDateToMidnight:[NSDate date]];
    newSession.goal = self;
    
    //check if the goal is countdown or not adjust the session.
    switch ([self.mode intValue]) {
        case GoalCountDownMode:
            newSession.sessionTimeInSeconds = self.plannedSessionTime;
            break;
        case GoalStopWatchMode:
            //TODO
            break;
        default:
            break;
    }
    
    return newSession;
}

- (Session *)fetchCurrentSessionForGoal {
    return [[self fetchAllSessionsForGoal] lastObject];
}

- (NSArray *)fetchAllSessionsForGoal {
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Session" inManagedObjectContext:[self managedObjectContext]];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"goal == %@", self];
    // Specify how the fetched objects should be sorted
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date"
    ascending:YES];
    
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
    [fetchRequest setPredicate:predicate];

    NSError *error = nil;
    NSArray *fetchedObjects = [[self managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects == nil) {
        NSLog(@"no fetched objects %@", [error localizedDescription]);
    }
    
    return fetchedObjects;
}
@end
