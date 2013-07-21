//
//  InstructionsViewController.m
//  Nippon
//
//  Created by Moshe Berman on 1/18/11.
//  Copyright 2011 MosheBerman.com. All rights reserved.
//

#import "AboutNipponViewController.h"
#import "HowToPlayViewController.h"

@implementation AboutNipponViewController


#pragma mark -
#pragma mark Initialization

/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/


#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];

	//
	//	Set the title
	//
	
	[self setTitle:@"About Nippon"];
	
	//
	//	Set the background color
	//
	
	[self.tableView setBackgroundColor:[UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0]];
	
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
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
    // Return the number of rows in the section.
    return 1;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
	//
	//	
	//
	
	[cell setSelectionStyle:UITableViewCellSelectionStyleGray];
	
	
	if ([indexPath section] == 0) {
		if ([indexPath row] == 0) {
			
			//
			//	Center the text
			//
			
			[cell.textLabel setTextAlignment:NSTextAlignmentCenter];
			
			//
			//	Set the text
			//
			
			[cell.textLabel setText:@"How to Play"];
			
			//
			//	Add the disclosure indicator.
			//
			
			[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
			
		}

		
	}else if ([indexPath section] == 1) {
		if ([indexPath row] == 0) {
			
			//
			//	Align the label
			//
			
			[cell.textLabel setTextAlignment:NSTextAlignmentCenter];
			
			//
			//	Set the text
			//
			
			[cell.textLabel setText:@"Spread the Word"];
			
			//
			//	Add the disclosure indicator.
			//
			
			[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];			

		}
	}
    return cell;
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
    
	
	if ([indexPath section] == 0) {
		if ([indexPath row] == 0) {
			
			HowToPlayViewController *helpView = [[HowToPlayViewController alloc] initWithNibName:@"HowToPlayViewController" bundle:nil];
			[self.navigationController pushViewController:helpView animated:YES];
		}
		
	}
	
	[tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
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




@end

