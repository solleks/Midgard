//
//  Rule.h
//  LogicalView
//
//  Created by Charles Garrett on 7/23/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Program, Structure, TermList;

@interface Rule : NSManagedObject {
@private
}
@property (nonatomic, retain) NSNumber * order;
@property (nonatomic, retain) TermList * body;
@property (nonatomic, retain) Program * program;
@property (nonatomic, retain) TermList * head;

- (NSString *)description;

@end
