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
//  ScalarViewController.h
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
