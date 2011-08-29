//
//  Atom.m
//  LogicalView
//
//  Created by Charles Garrett on 7/23/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Atom.h"
#import "ScalarViewController.h"

@implementation Atom
@dynamic name;

- (NSString *)displayString {
    return [self name];
}

- (TermViewController *)layoutCellForOccurrence:(TermOccurrence *)occurrence
                             withChangeCallback:(ChangeCallback)callback {
    return [[[ScalarViewController alloc] initWithTermOccurrence:occurrence] autorelease];
}

- (CGFloat)heightOfCell {
    return [ScalarViewController height];
}

- (NSString *)getScalarName {
    return [self name];
}

- (void)setScalarName:(NSString *)n {
    [self setName:n];
}

- (NSString *)description {
    NSMutableString *desc = [[[NSMutableString alloc] initWithFormat:@"Atom %@\n", [self name]] autorelease];
    [desc appendString:[super description]];
    return desc;
}

@end
