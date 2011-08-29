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
//  SelectionViewController.h
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
