//
//  Goal.h
//  Productivity2
//
//  Created by Kim on 03/06/15.
//  Copyright (c) 2015 Kim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Goal : NSManagedObject

@property (nonatomic, retain) NSNumber * totalTimeInSeconds;
@property (nonatomic, retain) NSString * name;

@end
