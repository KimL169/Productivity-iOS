//
//  Goal.h
//  Productivity2
//
//  Created by Kim on 07/06/15.
//  Copyright (c) 2015 Kim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Goal : NSManagedObject

@property (nonatomic, retain) NSNumber * mode;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * sessionTimeInSeconds;
@property (nonatomic, retain) NSNumber * totalTimeInSeconds;
@property (nonatomic, retain) NSNumber * goalNumber;
@property (nonatomic, retain) NSDate * dateCreated;
@property (nonatomic, retain) NSNumber * rounds;
@property (nonatomic, retain) NSNumber * plannedRounds;
@property (nonatomic, retain) NSNumber * plannedSessionTime;

typedef NS_ENUM(NSUInteger, goalMode){
    GoalTaskMode,
    GoalStopWatchMode,
    GoalCountDownMode
};

@end
