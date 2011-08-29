//
//  Rule.m
//  LogicalView
//
//  Created by Charles Garrett on 7/23/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Rule.h"
#import "Program.h"
#import "Structure.h"
#import "TermList.h"


@implementation Rule
@dynamic order;
@dynamic body;
@dynamic program;
@dynamic head;

- (NSString *)description {
    NSMutableString *desc = [[[NSMutableString alloc] initWithFormat:@"Rule ID %@", [self objectID]] autorelease];
    [desc appendFormat:@"Order %@\n", [self order]];
    [desc appendFormat:@"Program %@\n", [[self program] objectID]];
    [desc appendFormat:@"Rule head TermList %@\n", [[self head] objectID]];
    if ([self body] != nil) {
        [desc appendFormat:@"Rule body TermList %@\n", [[self body] objectID]];
    }
    return desc;
}

@end
