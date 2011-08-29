//
//  Structure.h
//  LogicalView
//
//  Created by Charles Garrett on 7/23/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Term.h"

@class Rule, TermList;

@interface Structure : Term {
@private
}
@property (nonatomic, retain) NSNumber * arity;
@property (nonatomic, retain) NSString * functor;
@property (nonatomic, retain) TermList * arguments;

- (NSString *)functorAndArity;
- (NSString *)displayString;
- (TermViewController *)layoutCellForOccurrence:(TermOccurrence *)occurrence
                             withChangeCallback:(ChangeCallback)callback;
- (CGFloat)heightOfCell;

- (NSString *)getScalarName;
- (void)setScalarName:(NSString *)n;

- (NSString *)description;

@end
