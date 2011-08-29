//
//  SelectionViewController.h
//  LogicalView
//
//  Created by Charles Garrett on 8/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


// A selection view presents a table of options from which the
// user can select one option.

typedef void(^CompletionBlock)(id);

@interface SelectionViewController : UITableViewController {
    NSArray *options;
    NSUInteger selectedOption;
    BOOL completed;
    CompletionBlock completionBlock;
}

@property (nonatomic, retain) NSArray *options;
@property (nonatomic) NSUInteger selectedOption;
@property (nonatomic) BOOL completed;
@property (nonatomic, copy) CompletionBlock completionBlock;

- (id)initWithStyle:(UITableViewStyle)style allOptions:(NSArray *)opts onCompletion:(CompletionBlock)block;

@end
