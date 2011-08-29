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
//  StructureViewController.h
//

#import <Foundation/Foundation.h>

#import "Model.h"
#import "TermViewController.h"
#import "ScalarViewController.h"

// A structure view is a container with subviews for its
// functor and arguments.  It handles modifications to the
// functor and addition or deletion of arguments.

@interface StructureViewController : TermViewController {
    
}

@property (nonatomic, retain) UIView *container;
@property (nonatomic, retain) ScalarViewController *functorView;
@property (nonatomic, retain) NSMutableArray *argViews;
@property (nonatomic, copy) ChangeCallback changeCallback;

// Views have term occurrences as properties, so that they can replace
// themselves within their parent terms or rules.
@property (nonatomic, retain) TermOccurrence *occurrence;

+ (CGFloat)height;

- (id)initWithTermOccurrence:(TermOccurrence *)to
                withChangeCallback:(ChangeCallback)callback;
- (void)resize;
- (void)setNeedsDisplay;
- (UIView *)uiView;
- (void)appendTermOccurrence:(TermOccurrence *)newOccurrence;
- (void)contentDidChange;

@end
