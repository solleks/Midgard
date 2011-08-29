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
//  TermOccurrence.h
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
