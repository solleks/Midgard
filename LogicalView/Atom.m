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
//  Atom.m
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
