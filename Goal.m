//
//  Goal.m
//  Productivity2
//
//  Created by Kim on 09/06/15.
//  Copyright (c) 2015 Kim. All rights reserved.
//

#import "Goal.h"
#import "Session.h"
#import "NSDate+helper.h"


@implementation Goal

@dynamic dateCreated;
@dynamic goalNumber;
@dynamic mode;
@dynamic name;
@dynamic plannedRounds;
@dynamic plannedSessionTime;
@dynamic totalTimeInSeconds;
@dynamic sessions;


- (Session *)returnCurrentOrNewSession {
    //first check if there is an active session
    // if there is an active session -> check if the date has expired or not.
    // if the date has expired, throw away the session and start a new one.
    Session * currentSession = [self fetchCurrentSessionForGoal:self];
    
    if (currentSession) {
        if ([NSDate daysBetweenDate:currentSession.date andDate:[NSDate date]] == 0) {
            return currentSession;
        }
    }
    
    Session *newSession = [NSEntityDescription insertNewObjectForEntityForName:@"Session" inManagedObjectContext:[super managedObjectContext]];
    newSession.date = [NSDate setDateToMidnight:[NSDate date]];
    
    return newSession;
}

- (Session *)fetchCurrentSessionForGoal:(Goal *)goal {
    return [[self fetchAllSessionsForGoal:goal] lastObject];
}

- (NSArray *)fetchAllSessionsForGoal:(Goal *)goal {
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Session" inManagedObjectContext:[self managedObjectContext]];
    [fetchRequest setEntity:entity];
    
    // Specify how the fetched objects should be sorted
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date"
    ascending:YES];
    
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];

    NSError *error = nil;
    NSArray *fetchedObjects = [[self managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects == nil) {
        NSLog(@"no fetched objects %@", [error localizedDescription]);
    }
    
    return fetchedObjects;
}

@end
