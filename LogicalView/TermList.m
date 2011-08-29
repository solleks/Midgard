//  Copyright 2011 Charlie Garrett
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
//  TermList.m
//

#import "TermList.h"
#import "Rule.h"
#import "Structure.h"
#import "TermOccurrence.h"


@implementation TermList
@dynamic elements;
@dynamic structure;
@dynamic ruleHead;
@dynamic ruleBody;

- (void)addElementsObject:(TermOccurrence *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"elements" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"elements"] addObject:value];
    [self didChangeValueForKey:@"elements" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeElementsObject:(TermOccurrence *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"elements" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"elements"] removeObject:value];
    [self didChangeValueForKey:@"elements" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addElements:(NSSet *)value {    
    [self willChangeValueForKey:@"elements" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"elements"] unionSet:value];
    [self didChangeValueForKey:@"elements" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeElements:(NSSet *)value {
    [self willChangeValueForKey:@"elements" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"elements"] minusSet:value];
    [self didChangeValueForKey:@"elements" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}

- (TermOccurrence *)termOccurrenceAtIndex:(NSUInteger)index {
    for (TermOccurrence *occurrence in [self elements]) {
        if ([[occurrence order] unsignedIntegerValue] == index) {
            return occurrence;
        }
    }
    return nil;
}

- (NSArray *)termOccurrencesInOrder {
    NSUInteger size = [[self elements] count];
    TermOccurrence *occurrences[size];
    
    for (TermOccurrence *occurrence in [self elements]) {
        NSUInteger pos = [[occurrence order] unsignedIntegerValue];
        occurrences[pos] = occurrence;
    }
    
    return [NSArray arrayWithObjects:occurrences count:size];
}

- (Term *)termAtIndex:(NSUInteger)index {
    TermOccurrence *occurrence = [self termOccurrenceAtIndex:index];
    if (occurrence != nil) {
        return [occurrence term];
    }
    return nil;
}

- (NSArray *)termsInOrder {
    NSUInteger size = [[self elements] count];
    Term *terms[size];
    
    for (TermOccurrence *occurrence in [self elements]) {
        NSUInteger pos = [[occurrence order] unsignedIntegerValue];
        Term *t = [occurrence term];
        terms[pos] = t;
    }

    return [NSArray arrayWithObjects:terms count:size];
}

- (NSString *)description {
    NSMutableString *desc = [[[NSMutableString alloc] initWithFormat:@"TermList ID %@", [self objectID]] autorelease];
    [desc appendString:@"Elements "];
    for (TermOccurrence *occurrence in [self elements]) {
        [desc appendFormat:@"ID %@,", [occurrence objectID]];
    }
    if ([self structure]) {
        [desc appendFormat:@"\nStructure ID %@", [[self structure] objectID]];
    }
    if ([self ruleBody]) {
        [desc appendFormat:@"\nRule body ID %@", [[self ruleBody] objectID]];
    }
    return desc;
}

@end
