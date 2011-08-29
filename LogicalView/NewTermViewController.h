//
//  NewTermView.h
//  LogicalView
//
//  Created by Charles Garrett on 8/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Model.h"
#import "ScalarViewController.h"
#import "StructureViewController.h"

// A view for adding new terms to rules and structures.

@interface NewTermViewController : ScalarViewController <UIPopoverControllerDelegate> {
    
}

@property (nonatomic, retain) NSString *text;
@property (nonatomic, retain) UIPopoverController *popover;

- (id)init;
- (NSString *)getTermName;
- (void)setTermName:(NSString *)n;

@end
