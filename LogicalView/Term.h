//
//  Term.h
//  LogicalView
//
//  Created by Charles Garrett on 7/23/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class TermOccurrence;
@class TermViewController;

@interface Term : NSManagedObject {
@private
}
@property (nonatomic, retain) NSSet* occurrences;

// The type of a function to be called when a new term is added.
typedef void (^ChangeCallback)(void);

- (NSString *)displayString;
- (TermViewController *)layoutCellForOccurrence:(TermOccurrence *)occurrence
                             withChangeCallback:(ChangeCallback)callback;
- (CGFloat)heightOfCell;

- (NSString *)getScalarName;
- (void)setScalarName:(NSString *)n;

- (NSString *)description;

@end
