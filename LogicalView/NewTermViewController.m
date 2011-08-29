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
//  NewTermViewController.m
//

#import <QuartzCore/CALayer.h>
#import <QuartzCore/CAAnimation.h>

#import "NewTermViewController.h"
#import "ViewConstants.h"
#import "SelectionViewController.h"


@implementation NewTermViewController

@synthesize text;
@synthesize popover;

+ (UIColor *)inactiveColor {
    static UIColor *color = nil;
    if (color == nil) {
        color = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
    }
    return color;
}

- (id)init {
    [self setText:@""];
    
    [super initWithColor:[NewTermViewController inactiveColor]];
    [[self textField] setTextColor:[UIColor grayColor]];
    
    [self resize];
    
    return self;
}

- (void)dealloc {
    [text release];
    [super dealloc];
}

- (NSString *)getTermName {
    return text;
}

- (void)setTermName:(NSString *)n {
    [self setText:n];

    StructureViewController *parentStructureView = (StructureViewController *)[self parentView];
    
    // Display popover controller to pick term type
    NSArray *termTypes = 
        [[NSArray arrayWithObjects:[Atom class], [Variable class], [Structure class], nil] retain];
    
    void (^CreateTerm)(id) = ^(id selectedType) {
        TermOccurrence *newTermOccurrence = 
        [[parentStructureView occurrence] appendTermOfType:(Class)selectedType
                                                     named:n];
        [parentStructureView appendTermOccurrence:newTermOccurrence];
        [self setText:@""];
        [self.popover dismissPopoverAnimated:YES];
    };
    
    SelectionViewController *selection = [[[SelectionViewController alloc]
                                           initWithStyle:UITableViewStylePlain
                                           allOptions:termTypes
                                           onCompletion:CreateTerm] autorelease];
    popover = [[UIPopoverController alloc] initWithContentViewController:selection];
    [popover setDelegate:self];
    [popover presentPopoverFromRect:[[self textField] bounds] inView:[self textField] permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    
}

#pragma mark UIPopoverControllerDelegate methods

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
    [popover autorelease];
    popover = nil;
}

#pragma mark UITextFieldDelegate methods

// Change the text field's border color when editing
- (void)textFieldDidBeginEditing:(UITextField *)tf {
    [super textFieldDidBeginEditing:tf];

    CALayer *layer = [[self textField] layer];

    [layer setBorderColor:[UIColor grayColor].CGColor];
}

// Change the text field's border color when done editing
- (void)textFieldDidEndEditing:(UITextField *)tf {
    [super textFieldDidEndEditing:tf];
    
    CALayer *layer = [[self textField] layer];
    [layer setBorderColor:[NewTermViewController inactiveColor].CGColor];
}

@end
