//
//  TermList.h
//  LogicalView
//
//  Created by Charles Garrett on 7/23/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Rule, Structure, Term, TermOccurrence;

@interface TermList : NSManagedObject {
@private
}
@property (nonatomic, retain) NSSet* elements;
@property (nonatomic, retain) Structure * structure;
@property (nonatomic, retain) Rule * ruleHead;
@property (nonatomic, retain) Rule * ruleBody;

- (void)addElementsObject:(TermOccurrence *)value;
- (void)removeElementsObject:(TermOccurrence *)value;

- (TermOccurrence *)termOccurrenceAtIndex:(NSUInteger)index;
- (NSArray *)termOccurrencesInOrder;
- (Term *)termAtIndex:(NSUInteger)index;
- (NSArray *)termsInOrder;

- (NSString *)description;

@end
