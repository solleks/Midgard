//
//  TermView.h
//  LogicalView
//
//  Created by Charles Garrett on 8/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Model.h"

// Base class for user interface views of various terms.
@interface TermViewController : UIViewController {
    
}

@property (nonatomic, retain) TermViewController *parentView;

+ (CGFloat)height;

- (void)resize;
- (void)resizeForText:(NSString *)text;
- (void)setNeedsDisplay;
- (UIView *)uiView;

@end
