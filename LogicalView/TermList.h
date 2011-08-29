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
//  TermList.h
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Rule, Structure, Term, TermOccurrence;

@interface TermList : NSManagedObject {
@private
}
@property (nonatomic, retain) NSSet* elements;
@property (nonatomic, retain) Structure * structure;
@property (nonatomic, retain) Rule * ruleHead;
@property (nonatomic, retain) Rule * ruleBody;

- (void)addElementsObject:(TermOccurrence *)value;
- (void)removeElementsObject:(TermOccurrence *)value;

- (TermOccurrence *)termOccurrenceAtIndex:(NSUInteger)index;
- (NSArray *)termOccurrencesInOrder;
- (Term *)termAtIndex:(NSUInteger)index;
- (NSArray *)termsInOrder;

- (NSString *)description;

@end
