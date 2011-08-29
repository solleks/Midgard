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
//  Program.m
//

#import "Program.h"
#import "Model.h"


// This is a category declaration that extends Program with methods visible at compile-time
// to only this file.  However, they are still callable at run-time from any file.
@interface Program ()
- (TermList *)createListWithArguments:(NSArray *)args;
- (Structure *)createStructureNamed:(NSString *)name withArguments:(NSArray *)args;
@end

@implementation Program

@dynamic rules;

- (void)addRulesObject:(Rule *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"rules" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"rules"] addObject:value];
    [self didChangeValueForKey:@"rules" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeRulesObject:(Rule *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"rules" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"rules"] removeObject:value];
    [self didChangeValueForKey:@"rules" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addRules:(NSSet *)value {    
    [self willChangeValueForKey:@"rules" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"rules"] unionSet:value];
    [self didChangeValueForKey:@"rules" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeRules:(NSSet *)value {
    [self willChangeValueForKey:@"rules" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"rules"] minusSet:value];
    [self didChangeValueForKey:@"rules" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}

+ (Program *)dummyProgramInContext:(NSManagedObjectContext *)context {
    static Program *_dummyProgram = nil;
    
    if (!_dummyProgram) {
        _dummyProgram = [NSEntityDescription insertNewObjectForEntityForName:@"Program"
                                                      inManagedObjectContext:context];
        [_dummyProgram addRules:[NSMutableSet set]];
    }
    
    return _dummyProgram;
}

- (TermList *)createListWithArguments:(NSArray *)args {
    NSManagedObjectContext *context = [self managedObjectContext];
    
    TermList *list = [NSEntityDescription insertNewObjectForEntityForName:@"TermList"
                                                   inManagedObjectContext:context];
    
    for (int n = 0; n < [args count]; n++) {
        TermOccurrence *occurrence = [NSEntityDescription insertNewObjectForEntityForName:@"TermOccurrence"
                                                                   inManagedObjectContext:context];
        [occurrence setOrder:[NSNumber numberWithInt:n]];
        [occurrence setTerm:[args objectAtIndex:n]];
        [list addElementsObject:occurrence];
    }
    
    return list;
}
    
- (Structure *)createStructureNamed:(NSString *)name withArguments:(NSArray *)args {
    NSManagedObjectContext *context = [self managedObjectContext];
    
    TermList *list = [self createListWithArguments:args];    

    Structure *structure = [NSEntityDescription insertNewObjectForEntityForName:@"Structure"
                                                         inManagedObjectContext:context];
    [structure setArity:[NSNumber numberWithInt:[args count]]];
    [structure setFunctor:name];
    [structure setArguments:list];
    
    NSLog(@"Structure arguments: %@", [structure arguments]);
    NSLog(@"List structure: %@", [list structure]);
    
    return structure;
}

// Create a dummy rule, out of a finite set.
- (Rule *)createRule {
    static NSUInteger nRules = 0;
    
    NSManagedObjectContext *context = [self managedObjectContext];
    
    Rule *rule = [NSEntityDescription insertNewObjectForEntityForName:@"Rule"
                                               inManagedObjectContext:context];
    
    switch (nRules % 3) {
        case 0: {
            // plus(N, z, N).
            Variable *nVar = [NSEntityDescription insertNewObjectForEntityForName:@"Variable"
                                                           inManagedObjectContext:context];
            [nVar setName:@"N"];
            
            Atom *zAtom = [NSEntityDescription insertNewObjectForEntityForName:@"Atom"
                                                        inManagedObjectContext:context];
            [zAtom setName:@"z"];
            
            Structure *head =
                [self createStructureNamed:@"plus" withArguments:[NSArray arrayWithObjects:nVar, zAtom, nVar, nil]];
            TermList *headList = [self createListWithArguments:[NSArray arrayWithObjects:head, nil]];
                                    
            [rule setOrder:[NSNumber numberWithInt:nRules]];
            [rule setHead:headList];
            [rule setBody:nil];
            break;
        }
        case 1: {
            // plus(M, s(N), s(T)) :- plus(M, N, T).
            Variable *mVar = [NSEntityDescription insertNewObjectForEntityForName:@"Variable"
                                                           inManagedObjectContext:context];
            [mVar setName:@"M"];
            
            Variable *nVar = [NSEntityDescription insertNewObjectForEntityForName:@"Variable"
                                                           inManagedObjectContext:context];
            [nVar setName:@"N"];
            
            Variable *tVar = [NSEntityDescription insertNewObjectForEntityForName:@"Variable"
                                                           inManagedObjectContext:context];
            [tVar setName:@"T"];
            
            Structure *sOfN = [self createStructureNamed:@"succ" withArguments:[NSArray arrayWithObjects:nVar, nil]];
            Structure *sOfT = [self createStructureNamed:@"succ" withArguments:[NSArray arrayWithObjects:tVar, nil]];
            
            Structure *head = [self createStructureNamed:@"plus" withArguments:[NSArray arrayWithObjects:mVar, sOfN, sOfT, nil]];
            TermList *headList = [self createListWithArguments:[NSArray arrayWithObjects:head, nil]];
            
            Structure *body = [self createStructureNamed:@"plus" withArguments:[NSArray arrayWithObjects:mVar, nVar, tVar, nil]];            
            TermList *bodyList = [self createListWithArguments:[NSArray arrayWithObjects:body, nil]];
            
            [rule setOrder:[NSNumber numberWithInt:nRules]];
            [rule setHead:headList];
            [rule setBody:bodyList];
            break;
        }
        case 2: {
            // father(F, C) :- parent(F, C), male(F).
            Variable *fVar = [NSEntityDescription insertNewObjectForEntityForName:@"Variable"
                                                           inManagedObjectContext:context];
            [fVar setName:@"F"];
            
            Variable *cVar = [NSEntityDescription insertNewObjectForEntityForName:@"Variable"
                                                           inManagedObjectContext:context];
            [cVar setName:@"C"];
            
            Structure *father = [self createStructureNamed:@"father" withArguments:[NSArray arrayWithObjects:fVar, cVar, nil]];
            TermList *headList = [self createListWithArguments:[NSArray arrayWithObjects:father, nil]];

            Structure *parent = [self createStructureNamed:@"parent" withArguments:[NSArray arrayWithObjects:fVar, cVar, nil]];
            
            Structure *male = [self createStructureNamed:@"male" withArguments:[NSArray arrayWithObjects:fVar, nil]];
            
            TermList *bodyList = [self createListWithArguments:[NSArray arrayWithObjects:parent, male, nil]];
            
            [rule setOrder:[NSNumber numberWithInt:nRules]];
            [rule setHead:headList];
            [rule setBody:bodyList];
            break;
        }
        default:
            break;
    }
        
    [[Program dummyProgramInContext:context] addRulesObject:rule];
    nRules++;
    
    return rule;
}

- (NSString *)description {
    NSMutableString *desc = [[[NSMutableString alloc] initWithFormat:@"Program ID %@\n", [self objectID]] autorelease];
    [desc appendString:@"Rules "];
    for (Rule *rule in [self rules]) {
        [desc appendFormat:@"ID %@", [rule objectID]];
    }
    return desc;
}

@end
