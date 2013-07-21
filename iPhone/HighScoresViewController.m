//
//  HighScoresViewController.m
//  Nippon
//
//  Created by Moshe Berman on 1/28/11.
//  Copyright 2011 MosheBerman.com. All rights reserved.
//

#import "HighScoresViewController.h"


@implementation HighScoresViewController

@synthesize	highScores;

#pragma mark -
#pragma mark Initialization


- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    self = [super initWithStyle:style];
    if (self) {
				
				//
				//	Load the saved high scores
				//
				//
				//	Sort the scores
				//
				
				NSArray *descriptors = [NSArray arrayWithObject:[[[NSSortDescriptor alloc]initWithKey:@"integerValue" ascending:NO]autorelease]];
				
				if (kTempScores != nil && [kTempScores count] > 1){
						self.highScores = [kTempScores sortedArrayUsingDescriptors:descriptors];
				}
				
    }
		
    return self;
}


#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad{
    [super viewDidLoad];
		
		//
		//	Add the Done button
		//
		
		UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissSelf)];
		self.navigationItem.leftBarButtonItem = doneButton;
		[doneButton release];
		
		//
		//	Set the title of the high scores
		//
		
		self.title = @"High Scores";
		
		//
		//	Tint the Navigation Bar
		//
		
		[self.navigationController.navigationBar setTintColor:[UIColor darkGrayColor]];
}



/*
 - (void)viewWillAppear:(BOOL)animated {
 [super viewWillAppear:animated];
 }
 */
/*
 - (void)viewDidAppear:(BOOL)animated {
 [super viewDidAppear:animated];
 }
 */
/*
 - (void)viewWillDisappear:(BOOL)animated {
 [super viewWillDisappear:animated];
 }
 */
/*
 - (void)viewDidDisappear:(BOOL)animated {
 [super viewDidDisappear:animated];
 }
 */

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return YES;
}



#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
		if ([highScores count] > 0) {
				if ([highScores count] < 10) {
						return [highScores count];
				}else{
						return 10;
				}
		}
		
		return 1;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
		
		//
		//	Center the scores
		//
		
		[cell.textLabel setTextAlignment:NSTextAlignmentCenter];
		
		//
		//	If there are scores to show
    //
		
		if ([self.highScores count] > 0) {
				
				//
				//	Load the score
				//
				
				if ([indexPath row] < [highScores count]) {
						
						[cell.textLabel setText:[NSString stringWithFormat:@"%@%i",kYen, [[highScores objectAtIndex:[indexPath row]]integerValue]]];
				}
				
		}else {
				
				//
				//	Inform the user that there are no high scores
				//
				
				[cell.textLabel setText:@"No High Scores"];
		}
		
		//
		//	Don't animate selections
		//
		
		[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}


- (void) dismissSelf{
		[self.parentViewController dismissViewControllerAnimated:YES completion:nil];
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */


/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source.
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
 }
 }
 */


/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */


/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
    /*
		 <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
		 [self.navigationController pushViewController:detailViewController animated:YES];
		 [detailViewController release];
		 */
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
		[highScores release];
    [super dealloc];
}


@end

