//
//  TermOccurrence.h
//  LogicalView
//
//  Created by Charles Garrett on 7/23/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#import "Term.h"

@class Rule, TermList, TermViewController;

@interface TermOccurrence : NSManagedObject {
@private
}
@property (nonatomic, retain) NSNumber * order;
@property (nonatomic, retain) Term * term;
@property (nonatomic, retain) TermList * list;

- (TermViewController *)layoutCellWithChangeCallback:(ChangeCallback)callback;
- (CGFloat)heightOfCell;

// The Rule in which the term occurrence appears.
- (Rule *)enclosingRule;
- (void)replaceWithTermNamed:(NSString *)n;
- (TermOccurrence *)appendTermOfType:(Class)type named:(NSString *)n;
- (void)removeFromList;

// Section and row of the term in a table view.
- (NSIndexPath *)indexPath;

- (NSString *)getScalarName;
- (void)setScalarName:(NSString *)n;

- (NSString *)description;

@end
