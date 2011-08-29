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
//  Rule.m
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
