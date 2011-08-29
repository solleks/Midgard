//
//  SelectionViewController.m
//  LogicalView
//
//  Created by Charles Garrett on 8/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SelectionViewController.h"


@implementation SelectionViewController

@synthesize options;
@synthesize selectedOption;
@synthesize completed;
@synthesize completionBlock;

#define CONTENT_SIZE_WIDTH 160
#define CONTENT_SIZE_CELL_HEIGHT 44

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style allOptions:(NSArray *)opts onCompletion:(CompletionBlock)block {
    self = [self initWithStyle:style];
    
    if (self) {
        self.options = opts;
        self.selectedOption = 0;
        self.completed = NO;
        self.completionBlock = block;
        self.contentSizeForViewInPopover = CGSizeMake(CONTENT_SIZE_WIDTH, [opts count] * CONTENT_SIZE_CELL_HEIGHT);
    }
    
    return self;
}

- (void)dealloc
{
    [options release];
    [completionBlock release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.clearsSelectionOnViewWillAppear = NO;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    if (!completed) {
        // Execute the completion block
        completionBlock([options objectAtIndex:selectedOption]);
    }
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [options count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SelectionViewCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    if (indexPath.row == selectedOption) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }

    cell.textLabel.text = [[options objectAtIndex:indexPath.row] description];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Change the selected option
    if (indexPath.row != selectedOption) {        
        selectedOption = indexPath.row;
    }
    completed = YES;
    completionBlock([options objectAtIndex:selectedOption]);
}

@end
