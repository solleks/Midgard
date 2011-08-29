//
//  Program.h
//  LogicalView
//
//  Created by Charles Garrett on 7/23/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Rule;

@interface Program : NSManagedObject {
@private
}
@property (nonatomic, retain) NSSet* rules;

// Testing interface that supplies a dummy program
+ (Program *)dummyProgramInContext:(NSManagedObjectContext *)context;

- (Rule *)createRule;

- (NSString *)description;

@end
