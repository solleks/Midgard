//
//  ScalarView.m
//  LogicalView
//
//  Created by Charles Garrett on 8/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/CALayer.h>

#import "ScalarViewController.h"
#import "StructureViewController.h"
#import "ViewConstants.h"

@implementation ScalarViewController

@synthesize occurrence;
@synthesize textField;
@synthesize color;

+ (CGFloat)height {
    return LABEL_HEIGHT;
}

- (id)initWithColor:(UIColor *)c {
    [self setColor:c];
    [self setParentView:nil];
    
    [self setTextField:[[[UITextField alloc] initWithFrame:CGRectZero] autorelease]];
    [textField setFont:[UIFont boldSystemFontOfSize:LABEL_FONT_SIZE]];
    [textField setTextAlignment:UITextAlignmentCenter];
    [textField setTextColor:color];
    [textField setText:[self getTermName]];
    [textField setBorderStyle:UITextBorderStyleRoundedRect];
    [textField setOpaque:YES];
    [textField setUserInteractionEnabled:YES];
    [textField setDelegate:self];
    
    static NSInteger tagNum = 0;
    [textField setTag:tagNum++];
    
    // Border
    CALayer *layer = [textField layer];
    [layer setBorderWidth:LABEL_BORDER_WIDTH];
    [layer setBorderColor:color.CGColor];
    [layer setCornerRadius:LABEL_CORNER_RADIUS];
    
    // Keyboard behavior
    [textField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [textField setAutocorrectionType:UITextAutocorrectionTypeNo];
    
    [self resize];
    
    return self;
}

- (id)initWithTermOccurrence:(TermOccurrence *)to {
    [self setOccurrence:to];
    
    Term *term = [to term];
    if ([term isKindOfClass:[Atom class]]) {
        [self initWithColor:[UIColor redColor]];
    } else if ([term isKindOfClass:[Variable class]]) {
        [self initWithColor:[UIColor blueColor]];
    } else if ([term isKindOfClass:[Structure class]]) {
        [self initWithColor:[UIColor blackColor]];
    }
    
    return self;
}

- (void)dealloc {
    [occurrence release];
    [color release];
    [textField release];
    [super dealloc];
}

- (void)resizeForText:(NSString *)text {
    NSLog(@"Resize for %@", text);
    CGFloat width = [text sizeWithFont:[textField font]].width + 2 * LABEL_PADDING;
    if (width < MIN_WIDTH) {
        width = MIN_WIDTH;
    }
    [textField setFrame:CGRectMake(0.0, 0.0, width, LABEL_HEIGHT)];
}

- (void)resize {
    [self resizeForText:[textField text]];
}

- (void)setNeedsDisplay {
    [textField setNeedsDisplay];
}

- (UIView *)uiView {
    return textField;
}

- (NSString *)getTermName {
    return [occurrence getScalarName];
}

- (void)setTermName:(NSString *)n {
    if ([n isEqualToString:@""]) {
        // Remove empty term occurrences.
        StructureViewController *parentStructureView = (StructureViewController *)[self parentView];
        [occurrence removeFromList];
        [parentStructureView contentDidChange];
    } else {
        [occurrence setScalarName:n];
    }
}


#pragma mark UITextFieldDelegate methods
- (BOOL)textField:(UITextField *)tf shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSLog(@"%@:%d %@ should change characters in range %d+%d with %@", [self class], [tf tag], [self getTermName], range.location, range.length, string);
    NSString *newText = [[textField text] stringByReplacingCharactersInRange:range withString:string];
    // Resize this view and its ancestors and set needsDisplay on the outermost
    // view, which contains all of the children that may need to be redrawn.
    for (TermViewController *view = self; view != nil; view = [view parentView]) {
        if (view == self) {
            [view resizeForText:newText];
        } else {
            [view resize];
        }
        if ([view parentView] == nil) {
            // TODO: Adding cell padding here is unclean.
            UIView *uiView = [view uiView];
            [uiView setCenter:CGPointMake([uiView center].x + CELL_PADDING, [uiView center].y + CELL_PADDING)];
            [view setNeedsDisplay];
        }
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)tf {
    NSLog(@"%@:%d %@ DID begin editing", [self class], [tf tag], [self getTermName]);
}

- (void)textFieldDidEndEditing:(UITextField *)tf {
    NSLog(@"%@:%d %@ DID end editing", [self class], [tf tag], [self getTermName]);
    // Make sure that the text field shows the current name of the term.
    [textField setText:[self getTermName]];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)tf {
    NSLog(@"%@:%d %@ SHOULD begin editing.  %@ editing", [self class], [tf tag], [self getTermName],
          ([tf isEditing] ? @"Is" : @"Isn't"));
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)tf {
    NSLog(@"%@:%d %@ SHOULD clear", [self class], [tf tag], [self getTermName]);
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)tf {
    NSLog(@"%@:%d %@ SHOULD end editing", [self class], [tf tag], [self getTermName]);
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)tf {
    NSLog(@"%@:%d %@ should return?", [self class], [tf tag], [self getTermName]);
    
    if (![[self getTermName] isEqualToString:[textField text]]) {
        [self setTermName:[textField text]];
        // Resize this view and its ancestors and set needsDisplay on the outermost
        // view, which contains all of the children that may need to be redrawn.
        for (TermViewController *view = self; view != nil; view = [view parentView]) {
            [view resize];
            if ([view parentView] == nil) {
                // TODO: Adding cell padding here is unclean.
                UIView *uiView = [view uiView];
                [uiView setCenter:CGPointMake([uiView center].x + CELL_PADDING, [uiView center].y + CELL_PADDING)];
                [view setNeedsDisplay];
            }
        }
    }
    
    [textField resignFirstResponder];
    return YES;
}

@end
