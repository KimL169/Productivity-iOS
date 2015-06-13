//
//  Goal+Helper.h
//  Productivity2
//
//  Created by Kim on 12/06/15.
//  Copyright (c) 2015 Kim. All rights reserved.
//

#import "Goal.h"

@interface Goal (Helper)

- (Session *)fetchCurrentSessionForGoal;
- (Session *)returnCurrentOrNewSession;

@end
