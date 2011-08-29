//
//  FunctorView.h
//  LogicalView
//
//  Created by Charles Garrett on 8/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
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
