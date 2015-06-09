//
//  Session.h
//  Productivity2
//
//  Created by Kim on 09/06/15.
//  Copyright (c) 2015 Kim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Goal;

@interface Session : NSManagedObject

@property (nonatomic, retain) NSNumber * sessionTimeInSeconds;
@property (nonatomic, retain) NSNumber * rounds;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) Goal *goal;

@end
