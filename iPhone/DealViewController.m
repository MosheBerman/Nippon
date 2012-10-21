//
//  DealViewController.m
//  Nippon
//
//  Created by Moshe Berman on 1/10/11.
//  Copyright 2011 MosheBerman.com. All rights reserved.
//

#import "DealViewController.h"
#import "FinancialViewController.h"

@implementation DealViewController

@synthesize items, prices;

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
	//	Create an array of the items
	//
	
    NSArray *tempItems = [[NSArray alloc] initWithObjects:kItemsNagiri, kItemsMaki, kItemsOshi, kItemsInari, kItemsSashimi, kItemsChirashi, kItemsNare, kItemsSushizushi, nil];
	[self setItems:tempItems];
	[tempItems release];
	
	//
	//	Create an array of prices
	//
	
	NSArray *tempPrices = [[NSArray alloc] initWithObjects:kPriceOfNagiri, kPriceOfMaki, kPriceOfOshi, kPriceOfInari, kPriceOfSashimi, kPriceOfChirashi, kPriceOfNare, kPriceOfSushizushi, nil];
	[self setPrices: tempPrices];
	[tempPrices release];
	
	//
	//	Register for notifications to show the bank
	//	or the credit union
	//
	
	[kNotificationCenter addObserver:self selector:@selector(showBank) name:kShowBankNotification object:nil];
	[kNotificationCenter addObserver:self selector:@selector(showCreditUnion) name:kShowCreditUnionNotification object:nil];	

	//
	//	Resize the rows
	//
	
	[self.tableView setRowHeight:90.0f];
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	
	//
	//	Refresh the table data (in case of a sale, etc)
	//
	
	[self.tableView reloadData];
    
    

}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

	//
	//	Create the "cash" menu
	//
	
	[self reloadTheView:nil];
    
	//
	//	Register for a notification which is fired when random events complete
	//
	
	[kNotificationCenter addObserver:self selector:@selector(reloadTheView:) name:kRandomEventsAreDoneNotification object:nil];
	[kNotificationCenter addObserver:self selector:@selector(reloadTheView:) name:kSushiWasHalvedNotification object:nil];

    //
	//	If we are in Osaka or Tokyo, show the appropriate
	//	button for the Bank or the credit union
	//
	
	if ([self.title isEqualToString:@"Tokyo"]){
		
		//
		//	Create a flexible space to center the button on the toolbar
		//
		
		UIBarButtonItem *flexibleSpaceButtonItem = [[UIBarButtonItem alloc]
													initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
													target:nil action:nil];
		
		//
		//	Show the toolbar
		//
		
		[self.navigationController setToolbarHidden:NO animated:YES];
		
		//
		//	Make the "go to bank button"
		//
		
		UIBarButtonItem *bankButton = [[UIBarButtonItem alloc] initWithTitle:@"Visit the Bank" style:UIBarButtonItemStylePlain target:self action:@selector(showBank)];
		[self.navigationController.toolbar setItems:[NSArray arrayWithObjects:flexibleSpaceButtonItem, bankButton, flexibleSpaceButtonItem, nil] animated:YES];
		
		//
		//	Release the bar button items
		//
		
		[bankButton release];
		[flexibleSpaceButtonItem release];
		
	}else if ([self.title isEqualToString:@"Osaka"]) {
		
		//
		//	Create a flexible space to center the button on the toolbar
		//
		
		UIBarButtonItem *flexibleSpaceButtonItem = [[UIBarButtonItem alloc]
													initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
													target:nil action:nil];
		
		
		//
		//	Show the toolbar
		//
		
		[self.navigationController setToolbarHidden:NO animated:YES];
		
		//
		//	Make the "go to credit union button"
		//
		
		UIBarButtonItem *creditUnionButton = [[UIBarButtonItem alloc] initWithTitle:@"Visit the Credit Union" style:UIBarButtonItemStylePlain target:self action:@selector(showCreditUnion)];
		[self.navigationController.toolbar setItems:[NSArray arrayWithObjects:flexibleSpaceButtonItem, creditUnionButton, flexibleSpaceButtonItem, nil] animated:YES];
        
		//
		//	Release the bar button items
		//
		
		[creditUnionButton release];
		[flexibleSpaceButtonItem release];
	}
    
}

- (void) reloadTheView:(NSNotification *)notif{
	
	//
	//	Reload the table data
	//
	
	[self.tableView reloadData];
	
    //
    //  Format the currency amount
    //
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
	[formatter setGroupingSeparator:kFormatterGroupingSeparator];
    [formatter setGroupingSize:3];
    [formatter setAlwaysShowsDecimalSeparator:NO];
    [formatter setUsesGroupingSeparator:kFormatterEnabled];
    
	//
	//	Create the "cash" menu
	//
	
	UIBarButtonItem *yenButton = [[UIBarButtonItem alloc] initWithTitle:[NSString stringWithFormat:@"%@ %@%@", NSLocalizedString(@"You have", @""), kYen, [formatter stringFromNumber:[NSNumber numberWithLongLong:[kCash longLongValue]]]] style:UIBarButtonItemStyleBordered target:[[UIApplication sharedApplication] delegate] action:@selector(showInGameInfo)];
	self.navigationItem.rightBarButtonItem = yenButton;
	[yenButton release];
	
    //
    //  Relesse the formatter
    //
    
    [formatter release];
	
}

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


//
//	Show the bank
//

- (void) showBank{
	
	//
	//	Show the bank
	//
	
	FinancialViewController *bankView = [[FinancialViewController alloc] initWithMode:kModeBank andItem:NSLocalizedString(@"Bank",@"") atPrice:nil];
	[self.navigationController pushViewController:bankView animated:YES];
	[bankView release];
	
}

//
//	Show the credit Union
//

- (void) showCreditUnion{
	
	//
	//	Show the credit union
	//
	
	FinancialViewController *bankView = [[FinancialViewController alloc] initWithMode:kModeCreditUnion andItem:NSLocalizedString(@"Credit Union", @"") atPrice:nil];
	[self.navigationController pushViewController:bankView animated:YES];
	[bankView release];	
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //if ([self.title isEqualToString:@"Tokyo"] || [self.title isEqualToString:@"Osaka"]){
    //    return 2;   
    //}
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    if ([self.title isEqualToString:@"Tokyo"] || [self.title isEqualToString:@"Osaka"]) {
//        if (section == 0) {
//            return 1;
//        }
//    }
    // Return the number of rows in the section.
    return [items count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    
	//
	//	Set up the cell labels
	//
	
	[cell.textLabel setText:[self.items objectAtIndex:[indexPath row]]];
	
    //
    //  Create a formatter
    //
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setGroupingSize:3];
    [formatter setAlwaysShowsDecimalSeparator:NO];
    [formatter setUsesGroupingSeparator:kFormatterEnabled];
    [formatter setGroupingSeparator:kFormatterGroupingSeparator];
    
    //
    //  Set the detail text
    //
    
    if ([[kCart objectForKey:cell.textLabel.text]integerValue] > 0) {
        [cell.detailTextLabel setText:[NSString stringWithFormat:@"%@: %@%@ - %@: %li", NSLocalizedString(@"Price", @"") , kYen, [formatter stringFromNumber:[self.prices objectAtIndex:[indexPath row]]], NSLocalizedString(@"You have", @""), [[kCart objectForKey:cell.textLabel.text]integerValue]]];     
    }else{
        [cell.detailTextLabel setText:[NSString stringWithFormat:@"%@: %@%@", NSLocalizedString(@"Price", @"") , kYen, [formatter stringFromNumber:[self.prices objectAtIndex:[indexPath row]]]]];
    }
    
    //
    //  Release the formatter
    //
    
    [formatter release];
    
	//
	//	Set the selection type
	//
	
	[cell setSelectionStyle:UITableViewCellSelectionStyleGray];
	
	//
	//	Add the accessory view
	//
	
	[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
	
   
	

    
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
	FinancialViewController *financeView = [[FinancialViewController alloc] initWithMode:kModeItem andItem:[[tableView cellForRowAtIndexPath:[tableView indexPathForSelectedRow]] textLabel].text atPrice:[self.prices objectAtIndex:[[tableView indexPathForSelectedRow] row]]];
	
	[self.navigationController pushViewController:financeView animated:YES];
	
	[financeView release]; 
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

#pragma mark -

- (void) viewWillDisappear:(BOOL)animated{
	[super viewWillDisappear:animated];
	
	//
	//	Hide the toolbar
	//
	
	[self.navigationController setToolbarHidden:YES animated:YES];
	
	//
	//	Stop listening for Notifications
	//
	
	[kNotificationCenter removeObserver:self];
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
	
	[kNotificationCenter removeObserver:self];
}


- (void)dealloc {
	[prices release];
	[items release];
    [super dealloc];
}


@end

