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
//  StructureViewController.m
//

#import "StructureViewController.h"
#import "NewTermViewController.h"
#import "ViewConstants.h"
#import <QuartzCore/CALayer.h>


@implementation StructureViewController

@synthesize container;
@synthesize functorView;
@synthesize occurrence;
@synthesize argViews;
@synthesize changeCallback;

+ (CGFloat)height {
    return LABEL_HEIGHT;
}

- (id)initWithTermOccurrence:(TermOccurrence *)to withChangeCallback:(ChangeCallback)cb {
    [self setOccurrence:to];
    [self setParentView:nil];
    [self setChangeCallback:cb];
    
    [self setFunctorView:[[[ScalarViewController alloc] initWithTermOccurrence:to] autorelease]];
    [functorView setParentView:self];

    [self setContainer:[[[UIView alloc] initWithFrame:CGRectZero] autorelease]];
    [container setOpaque:YES];
    [[container layer] setBackgroundColor:[UIColor whiteColor].CGColor];
    [container addSubview:[functorView textField]];
    
    Structure *structure = (Structure *)[occurrence term];
    NSArray *termOccurrences = [[structure arguments] termOccurrencesInOrder];
    [self setArgViews:[NSMutableArray arrayWithCapacity:[termOccurrences count]]];
    for (int i = 0; i < [termOccurrences count]; i++) {
        TermViewController *termView = [[termOccurrences objectAtIndex:i] layoutCellWithChangeCallback:changeCallback];
        [termView setParentView:self];
        [argViews addObject:termView];
        [container addSubview:[termView uiView]];
    }
    NewTermViewController *newView = [[NewTermViewController alloc] init];
    [newView setParentView:self];
    [argViews addObject:newView];
    [container addSubview:[newView uiView]];
    
    [container setUserInteractionEnabled:YES];

    [functorView resize];
    [self resize];

    return self;
}

- (void)dealloc {
    [occurrence release];
    [container release];
    [functorView release];
    [super dealloc];
}

- (void)resize {
    CGFloat width = [functorView textField].frame.size.width;
    
    NSLog(@"Functor %@ center (%.1f, %.1f), bounds (%.1f, %.1f, %.1f, %.1f)",
          [[functorView textField] text],
          [[functorView textField] center].x, [[functorView textField] center].y,
          [[functorView textField] bounds].origin.x, [[functorView textField] bounds].origin.y,
          [[functorView textField] bounds].size.width, [[functorView textField] bounds].size.height);
    
    // Expand the container's bounds to include the label.
    CGRect containerBounds = [functorView textField].bounds;
    [container setFrame:containerBounds];
    
    for (int i = 0; i < [argViews count]; i++) {
        UIView *argView = [[argViews objectAtIndex:i] uiView];
        CGRect argBounds = [argView bounds];
        if (i == 0) {
            // Put the first term on the same line as the functor.
            [argView setCenter:CGPointMake(argBounds.size.width/2 + width + TERM_SPACING,
                                           argBounds.size.height/2)];
            // Expand the container's bounds to include the term.
            containerBounds.size.width = MAX(containerBounds.size.width,
                                             argBounds.size.width + width + TERM_SPACING);
            containerBounds.size.height = MAX(containerBounds.size.height,
                                              argBounds.size.height);
        } else {
            // Move the term's view below any earlier views.
            [argView setCenter:CGPointMake(argBounds.size.width/2 + width + TERM_SPACING,
                                           argBounds.size.height/2 + containerBounds.size.height + TERM_SPACING)];
            // Expand the container's bounds to include the term.
            containerBounds.size.width = MAX(containerBounds.size.width, argBounds.size.width + width + TERM_SPACING);
            containerBounds.size.height += argBounds.size.height + TERM_SPACING;
        }
        NSLog(@"Argument %d center (%.1f, %.1f), bounds (%.1f, %.1f, %.1f, %.1f)",
              i,
              [argView center].x, [argView center].y,
              [argView bounds].origin.x, [argView bounds].origin.y,
              [argView bounds].size.width, [argView bounds].size.height);
    }
    
    [container setCenter:CGPointMake(containerBounds.size.width/2, containerBounds.size.height/2)];
    [container setBounds:containerBounds];    

    NSLog(@"Structure %@ center (%.1f, %.1f), bounds (%.1f, %.1f, %.1f, %.1f)",
          [[[self occurrence] term] displayString],
          [container center].x, [container center].y,
          [container bounds].origin.x, [container bounds].origin.y,
          [container bounds].size.width, [container bounds].size.height);
}

- (void)setNeedsDisplay {
    [container setNeedsDisplay];
}

- (UIView *)uiView {
    return container;
}

// Insert the new term occurrence at the end of the arguments and before the
// new term placeholder.  The term should already be part of the actual Structure
// corresponding to the view.
- (void)appendTermOccurrence:(TermOccurrence *)newOccurrence {
    TermViewController *termView = [newOccurrence layoutCellWithChangeCallback:changeCallback];
    [termView setParentView:self];
    
    NSUInteger size = [argViews count];
    NewTermViewController *placeholder = [argViews objectAtIndex:size - 1];
    [argViews removeObjectAtIndex:size - 1];
    [argViews addObject:termView];
    [argViews addObject:placeholder];
    [container addSubview:[termView uiView]];
    
    [self contentDidChange];
}

- (void)contentDidChange {
    if (changeCallback != nil) {
        changeCallback();
    }    
}

@end
