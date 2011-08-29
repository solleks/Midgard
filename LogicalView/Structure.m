//
//  Structure.m
//  LogicalView
//
//  Created by Charles Garrett on 7/23/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Structure.h"
#import "Rule.h"
#import "TermList.h"
#import "NewTermViewController.h"
#import "StructureViewController.h"
#import "ViewConstants.h"


@implementation Structure
@dynamic arity;
@dynamic functor;
@dynamic arguments;

- (NSString *)functorAndArity {
    return [NSString stringWithFormat:@"%@/%@", [self functor], [self arity]];
}

- (NSString *)displayString {
    NSMutableString *result = [NSMutableString stringWithCapacity:80];
    [result appendFormat:@"%@(", [self functor]];
    
    NSArray *terms = [[self arguments] termsInOrder];
    for (int i = 0; i < [terms count]; i++) {
        if (i < [terms count] - 1) {
            [result appendFormat:@"%@, ", [[terms objectAtIndex:i] displayString]];
        } else {
            [result appendFormat:@"%@", [[terms objectAtIndex:i] displayString]];            
        }
    }

    [result appendString:@")"];
    return result;
}

- (TermViewController *)layoutCellForOccurrence:(TermOccurrence *)occurrence
                             withChangeCallback:(ChangeCallback)callback {
    return [[[StructureViewController alloc]
             initWithTermOccurrence:occurrence withChangeCallback:callback] autorelease];
}

- (CGFloat)heightOfCell {
    CGFloat height = [StructureViewController height];
    
    NSArray *terms = [[self arguments] termsInOrder];
    for (int i = 0; i < [terms count]; i++) {
        CGFloat termHeight = [[terms objectAtIndex:i] heightOfCell];

        if (i == 0) {
            height = MAX(height, termHeight);
        } else {
            height += termHeight + TERM_SPACING;
        }
    }
    // For blank term text fields.
    height += [NewTermViewController height] + TERM_SPACING;
    
    return height;
}

- (NSString *)getScalarName {
    return [self functor];
}

- (void)setScalarName:(NSString *)n {
    [self setFunctor:n];
}

- (NSString *)description {
    NSMutableString *desc = [[[NSMutableString alloc] initWithFormat:@"Structure %@\n", [self displayString]] autorelease];
    [desc appendString:[super description]];
    return desc;
}

@end
