//
//  ScalarView.h
//  LogicalView
//
//  Created by Charles Garrett on 8/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TermViewController.h"

// A scalar view represents a term with no structure (an Atom or
// Variable) or a functor.  The term is represented by a TermOccurrence
// so that we can determine its position in its parent term.

@interface ScalarViewController : TermViewController <UITextFieldDelegate> {
    
}

@property (nonatomic, retain) TermOccurrence *occurrence;
@property (nonatomic, retain) UITextField *textField;
@property (nonatomic, retain) UIColor *color;

+ (CGFloat)height;

- (id)initWithColor:(UIColor *)c;
- (id)initWithTermOccurrence:(TermOccurrence *)to;
- (void)resize;
- (void)setNeedsDisplay;
- (UIView *)uiView;
- (NSString *)getTermName;
- (void)setTermName:(NSString *)n;

#pragma mark UITextFieldDelegate methods
- (BOOL)textField:(UITextField *)tf shouldChangeCharactersInRange:(NSRange)range
    replacementString:(NSString *)string;
- (BOOL)textFieldShouldBeginEditing:(UITextField *)tf;
- (void)textFieldDidBeginEditing:(UITextField *)tf;
- (BOOL)textFieldShouldEndEditing:(UITextField *)tf;
- (void)textFieldDidEndEditing:(UITextField *)tf;
- (BOOL)textFieldShouldClear:(UITextField *)tf;
- (BOOL)textFieldShouldReturn:(UITextField *)tf;

@end
