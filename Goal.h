//
//  Goal.h
//  Productivity2
//
//  Created by Kim on 09/06/15.
//  Copyright (c) 2015 Kim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Session;

@interface Goal : NSManagedObject

@property (nonatomic, retain) NSDate * dateCreated;
@property (nonatomic, retain) NSNumber * goalNumber;
@property (nonatomic, retain) NSNumber * mode;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * plannedRounds;
@property (nonatomic, retain) NSNumber * plannedSessionTime;
@property (nonatomic, retain) NSNumber * totalTimeInSeconds;
@property (nonatomic, retain) NSSet *sessions;
@end

@interface Goal (CoreDataGeneratedAccessors)

- (void)addSessionsObject:(Session *)value;
- (void)removeSessionsObject:(Session *)value;
- (void)addSessions:(NSSet *)values;
- (void)removeSessions:(NSSet *)values;

@end
