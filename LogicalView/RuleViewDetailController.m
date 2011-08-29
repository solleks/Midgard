//
//  RuleViewDetailController.m
//  LogicalView
//
//  Created by Charles Garrett on 8/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RuleViewDetailController.h"
#import "TermViewController.h"
#import "ViewConstants.h"


@interface RuleViewDetailController ()
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
- (void)layoutCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
    changeCallback:(ChangeCallback)callback;
- (CGFloat)heightOfCellAtIndexPath:(NSIndexPath *)indexPath;
@end

@implementation RuleViewDetailController

@synthesize rule;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    if ([indexPath section] == 0) {
        // Rule head
        cell.textLabel.text = [[[rule head] termAtIndex:0]displayString];
    } else {
        // Rule body
        cell.textLabel.text = [[[rule body] termAtIndex:[indexPath row]] displayString];
    }
}

- (void)layoutCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
    changeCallback:(ChangeCallback)callback {
    if ([indexPath section] == 0) {
        // Rule head
        UIView *view = [[[[rule head] termOccurrenceAtIndex:0]
                         layoutCellWithChangeCallback:callback]
                        uiView];
        [view setCenter:CGPointMake([view center].x + CELL_PADDING, [view center].y + CELL_PADDING)];
        [[cell contentView] addSubview:view];
    } else {
        // Rule body
        UIView *view = [[[[rule body] termOccurrenceAtIndex:[indexPath row]]
                         layoutCellWithChangeCallback:callback]
                        uiView];
        [view setCenter:CGPointMake([view center].x + CELL_PADDING, [view center].y + CELL_PADDING)];
        [[cell contentView] addSubview:view];
    }
}

- (CGFloat)heightOfCellAtIndexPath:(NSIndexPath *)indexPath {
    if ([indexPath section] == 0) {
        // Rule head
        return [[[rule head] termAtIndex:0] heightOfCell] + 2 * CELL_PADDING;
    } else {
        // Rule body
        return [[[rule body] termAtIndex:[indexPath row]] heightOfCell] + 2 * CELL_PADDING;
    }    
}

- (void)addToRuleBody {
    NSLog(@"Add a term to the rule body");
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.navigationItem.title = [(Structure *)[[rule head] termAtIndex:0] functorAndArity];
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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        if ([rule body] == nil) {
            return 0;
        } else {
            return [[[rule body] elements] count];
        }
    }
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"Head";
    } else {
        return @"Body";
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Don't reuse the table view cells because their content is dynamically determined by the
    // rule and not consistent enough to reuse.
    UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
    [cell setBackgroundColor:[UIColor whiteColor]];
    [cell setOpaque:YES];
    
    ChangeCallback callback = ^(void) {
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                         withRowAnimation:UITableViewRowAnimationNone];
        [tableView setNeedsDisplay];
    };
    
    [self layoutCell:cell atIndexPath:indexPath changeCallback:callback];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self heightOfCellAtIndexPath:indexPath];
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Can edit rule body, but not head.
    return ([indexPath section] == 1);
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        if ([indexPath section] == 1) {
            // Rule body
            TermList *body = [rule body];
            TermOccurrence *occurrence = [body termOccurrenceAtIndex:[indexPath row]];
            [body removeElementsObject:occurrence];

            NSManagedObjectContext *context = [occurrence managedObjectContext];
            [context deleteObject:occurrence];
            
            // Remove empty rule bodies
            if ([[body elements] count] == 0) {
                [rule setBody:nil];
                [context deleteObject:body];
            }
        
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];

            // Save the context.
            NSError *error = nil;
            if (![context save:&error])
            {
                /*
                 Replace this implementation with code to handle the error appropriately.
                 
                 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
                 */
                NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                abort();
            }
        }
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return NO;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}

@end
