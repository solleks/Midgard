//
//  Term.m
//  LogicalView
//
//  Created by Charles Garrett on 7/23/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Term.h"
#import "TermOccurrence.h"
#import "TermViewController.h"

@implementation Term
@dynamic occurrences;

- (void)addOccurrencesObject:(TermOccurrence *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"occurrences" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"occurrences"] addObject:value];
    [self didChangeValueForKey:@"occurrences" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeOccurrencesObject:(TermOccurrence *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"occurrences" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"occurrences"] removeObject:value];
    [self didChangeValueForKey:@"occurrences" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addOccurrences:(NSSet *)value {    
    [self willChangeValueForKey:@"occurrences" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"occurrences"] unionSet:value];
    [self didChangeValueForKey:@"occurrences" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeOccurrences:(NSSet *)value {
    [self willChangeValueForKey:@"occurrences" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"occurrences"] minusSet:value];
    [self didChangeValueForKey:@"occurrences" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}

- (NSString *)displayString {
    return @"<dummy term>";
}

- (TermViewController *)layoutCellForOccurrence:(TermOccurrence *)occurrence
                             withChangeCallback:(ChangeCallback)callback {
    return nil;
}

- (CGFloat)heightOfCell {
    return 0.0;
}

- (NSString *)getScalarName {
    return nil;
}

- (void)setScalarName:(NSString *)n {
}

- (NSString *)description {
    NSMutableString *desc = [[[NSMutableString alloc] initWithFormat:@"%@ ID %@.\nOccurrences:\n",
                              [self class], [self objectID]] autorelease];
    
    for (TermOccurrence *occurrence in [self occurrences]) {
        [desc appendFormat:@"ID %@, ", [occurrence objectID]];
    }
    [desc appendString:@"\n"];
    
    return desc;
}


@end
