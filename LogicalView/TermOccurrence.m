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
//  TermOccurrence.m
//

#import "TermOccurrence.h"
#import "Model.h"
#import "ScalarViewController.h"

@implementation TermOccurrence
@dynamic order;
@dynamic term;
@dynamic list;

- (TermViewController *)layoutCellWithChangeCallback:(ChangeCallback)callback {
    return [[self term] layoutCellForOccurrence:self withChangeCallback:callback];
}

- (CGFloat)heightOfCell {
    return [ScalarViewController height];
}

// The Rule in which the term occurrence appears.
- (Rule *)enclosingRule {
    TermOccurrence *currentOccurrence = self;
    
    while (currentOccurrence != nil) {
        TermList *tl = [currentOccurrence list];
        if ([tl ruleHead] != nil) {
            return [tl ruleHead];
        } else if ([tl ruleBody] != nil) {
            return [tl ruleBody];
        } else {
            currentOccurrence = [[[tl structure] occurrences] anyObject];
        }
    }
    return nil;
}

- (void)replaceWithTermNamed:(NSString *)n {
    // Find any existing terms with the new name
    NSManagedObjectContext *context = [self managedObjectContext];
    NSEntityDescription *entityDescription = [[self term] entity];
    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
    [request setEntity:entityDescription];
    
    // Set example predicate and sort orderings... 
    NSPredicate *predicate = [NSPredicate predicateWithFormat: @"name LIKE %@", n];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *array = [context executeFetchRequest:request error:&error];
    if (array == nil) {
        NSLog(@"Error fetching term named %@: %@", n, error);
    }
    
    NSLog(@"Predicate: %@", predicate);
    NSLog(@"Found %d %@s named %@", [array count], [entityDescription name], n);
    for (NSManagedObject *obj in array) {
        NSLog(@"%@: %@", [entityDescription name], obj);
    }
    
    // Pick a Term if it is in the same rule as the existing one.
    Term *newTerm = nil;
    if ([array count] > 0) {
        Rule *currentRule = [self enclosingRule];
        // Check that the existing Term is in the right rule.
        for (Term *t in array) {
            for (TermOccurrence *to in [t occurrences]) {
                if ([to enclosingRule] == currentRule) {
                    newTerm = [to term];
                    break;
                }
            }
        }
    }
    if (newTerm == nil) {
        // Create a new Term
        newTerm = [[NSManagedObject alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:context];
        [newTerm setScalarName:n];
    }
    if (newTerm != [self term]) {
        [self setTerm:newTerm];
    }
}

- (TermOccurrence *)appendTermOfType:(Class)type named:(NSString *)n {
    // Find any existing terms with the new name
    NSManagedObjectContext *context = [self managedObjectContext];
    
    Term *newTerm = nil;
    if (type == [Atom class]) {
        NSEntityDescription *entityDescription =
        [NSEntityDescription entityForName:@"Atom" inManagedObjectContext:context];
        NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
        [request setEntity:entityDescription];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat: @"name LIKE %@", n];
        [request setPredicate:predicate];
        
        NSError *error = nil;
        NSArray *array = [context executeFetchRequest:request error:&error];
        if (array == nil) {
            NSLog(@"Error fetching term named %@: %@", n, error);
        }
        
        NSLog(@"Predicate: %@", predicate);
        NSLog(@"Found %d %@s named %@", [array count], [entityDescription name], n);
        for (NSManagedObject *obj in array) {
            NSLog(@"%@: %@", [entityDescription name], obj);
        }
        
        // Pick a Term if it is in the same rule as the existing one.
        if ([array count] > 0) {
            Rule *currentRule = [self enclosingRule];
            // Check that the existing Term is in the right rule.
            for (Term *t in array) {
                for (TermOccurrence *to in [t occurrences]) {
                    if ([to enclosingRule] == currentRule) {
                        newTerm = [to term];
                        break;
                    }
                }
            }
        }
        if (newTerm == nil) {
            // Create a new Term
            newTerm = [[NSManagedObject alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:context];
            [newTerm setScalarName:n];
        }
    } else if (type == [Variable class]) {
        NSEntityDescription *entityDescription =
        [NSEntityDescription entityForName:@"Variable" inManagedObjectContext:context];
        NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
        [request setEntity:entityDescription];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat: @"name LIKE %@", n];
        [request setPredicate:predicate];
        
        NSError *error = nil;
        NSArray *array = [context executeFetchRequest:request error:&error];
        if (array == nil) {
            NSLog(@"Error fetching term named %@: %@", n, error);
        }
        
        NSLog(@"Predicate: %@", predicate);
        NSLog(@"Found %d %@s named %@", [array count], [entityDescription name], n);
        for (NSManagedObject *obj in array) {
            NSLog(@"%@: %@", [entityDescription name], obj);
        }
        
        // Pick a Term if it is in the same rule as the existing one.
        if ([array count] > 0) {
            Rule *currentRule = [self enclosingRule];
            // Check that the existing Term is in the right rule.
            for (Term *t in array) {
                for (TermOccurrence *to in [t occurrences]) {
                    if ([to enclosingRule] == currentRule) {
                        newTerm = [to term];
                        break;
                    }
                }
            }
        }
        if (newTerm == nil) {
            // Create a new Term
            newTerm = [[NSManagedObject alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:context];
            [newTerm setScalarName:n];
        }
    } else if (type == [Structure class]) {
        NSEntityDescription *entityDescription =
        [NSEntityDescription entityForName:@"Structure" inManagedObjectContext:context];
        NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
        [request setEntity:entityDescription];
        
        // Create a new Term
        newTerm = [[NSManagedObject alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:context];
        [newTerm setScalarName:n];
    }
    
    NSLog(@"Original structure: %@", [[self term] displayString]);

    // Append the new term after self.
    Structure *structure = (Structure *)[self term];
    TermOccurrence *occurrence = [NSEntityDescription insertNewObjectForEntityForName:@"TermOccurrence"
                                                               inManagedObjectContext:context];
    [occurrence setOrder:[NSNumber numberWithInt:[[[structure arguments] elements] count]]];
    [occurrence setTerm:newTerm];
    [[structure arguments] addElementsObject:occurrence];
    [structure setArity:[NSNumber numberWithInt:[[[structure arguments] elements] count]]];
    
    NSLog(@"Updated structure: %@", [[self term] displayString]);
    return occurrence;
}

- (void)removeFromList {
    // Remove self from its TermList and renumber the remaining occurrences.
    for (TermOccurrence *remaining in [[self list] elements]) {
        NSNumber *remainingOrder = [remaining order];
        if ([remainingOrder integerValue] > [[self order] integerValue]) {
            [remaining setOrder:[NSNumber numberWithInt:[remainingOrder integerValue] - 1]];
        }
    }
    [[self list] removeElementsObject:self];
}

- (NSIndexPath *)indexPath {
    TermList *containingList = [self list];
    if ([containingList ruleHead] != nil) {
        return [NSIndexPath indexPathForRow:[[self order] unsignedIntegerValue] inSection:0];
    } else if ([containingList ruleBody] != nil) {
        return [NSIndexPath indexPathForRow:[[self order] unsignedIntegerValue] inSection:1];        
    }
    return nil;
}

- (NSString *)getScalarName {
    return [[self term] getScalarName];
}

- (void)setScalarName:(NSString *)n {
    if (![[[self term] getScalarName] isEqualToString:n]) {
        if ([[self term] isKindOfClass:[Structure class]]) {
            // Just change the functor name, there is no sharing.
            [[self term] setScalarName:n];
        } else {
            // Search for existing atoms or variables in this rule with the same name.
            [self replaceWithTermNamed:n];
        }
    }    
}

- (NSString *)description {
    NSMutableString *desc = [[[NSMutableString alloc] initWithFormat:@"TermOccurrence:  Term ID %@, order %@\nTermList ID %@", [[self term] objectID], [self order], [[self list] objectID]] autorelease];
    return desc;
}

@end
