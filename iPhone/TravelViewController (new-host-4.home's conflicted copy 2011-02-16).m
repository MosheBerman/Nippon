//
//  TravelViewController.m
//  Nippon
//
//  Created by Moshe Berman on 1/10/11.
//  Copyright 2011 MosheBerman.com. All rights reserved.
//

#import "TravelViewController.h"
#import "DealViewController.h"

@implementation TravelViewController

@synthesize locations;

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
	//	Create the menu button
	//
	
	UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Main Menu", @"") style:UIBarButtonItemStyleBordered target:[[UIApplication sharedApplication] delegate] action:@selector(hideGameView)];
	self.navigationItem.leftBarButtonItem = menuButton;
	[menuButton release];
	
	//
	//	Set the title of the view
	//
	
	[self setTitle: @"Travel"];
	
	NSArray *tempLocations = [[NSArray alloc] initWithObjects:@"Tokyo", @"Yokohama", @"Osaka", @"Nagoya", @"Sapporo", @"Kobe", nil];
	self.locations = tempLocations;
	[tempLocations release];
	
	
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

	//
	//	Create the "cash" menu
	//
	
	UIBarButtonItem *yenButton = [[UIBarButtonItem alloc] initWithTitle:[NSString stringWithFormat:@"%@ %@", kDaysLeft, NSLocalizedString(@"Days Left", @"")] style:UIBarButtonItemStyleBordered target:[[UIApplication sharedApplication] delegate] action:@selector(showInGameInfo)];
	self.navigationItem.rightBarButtonItem = yenButton;
	[yenButton release];
}



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
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [locations count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
     
	//
	//	Center the label
	//
	
	[cell.textLabel setTextAlignment:UITextAlignmentCenter];
	
	//
	//	Load the label for the cell from the array of places
	//
	
	[cell.textLabel setText:[self.locations objectAtIndex:[indexPath row]]];
   
	//
	//	Set the selection style to "Grey"
	//
	
	[cell setSelectionStyle:UITableViewCellSelectionStyleGray];
	
	//
	//	Add the accessory view to the cell
	//
	
	[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
	
	//
	//	Set the font
	//
	
	//[cell.textLabel setFont:[UIFont fontWithName:@"Zapfino" size:14.0f]];
	
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
    
	//
	//	Check if we are "already in" the chosen location
	//	if not, we deduct a day for travel time and then
	//	generate new prices
	//
	
	if (kLastLocation != [[[tableView cellForRowAtIndexPath:indexPath] textLabel] text]) {
		
		//
		//	Store the new location
		//
		
		[kSettings setObject:[[[tableView cellForRowAtIndexPath:indexPath] textLabel] text] forKey:@"lastLocation"];
		
		//
		//	Deduct travel time
		//
		
		[kSettings setObject:[NSNumber numberWithInt:[kDaysLeft intValue] - kTravelTime] forKey:@"daysLeft"];
		
		if ([kDaysLeft intValue] < 0) {
			
			//
			//	End the game immeditely
			//
			
			[kNotificationCenter postNotificationName:kGameOverNotification object:nil];
			
		}else{
		
			//
			//	Generate prices
			//
		
			[kSettings setObject:[NSNumber numberWithInt:abs(arc4random()%kPriceNagiriMax+kPriceNagiriMin)] forKey:@"priceOfNagiri"];
			[kSettings setObject:[NSNumber numberWithInt:abs(arc4random()%kPriceMakiMax+kPriceMakiMin)] forKey:@"priceOfMaki"];
			[kSettings setObject:[NSNumber numberWithInt:abs(arc4random()%kPriceOshiMax+kPriceOshiMin)] forKey:@"priceOfOshi"];
			[kSettings setObject:[NSNumber numberWithInt:abs(arc4random()%kPriceInariMax+kPriceInariMin)] forKey:@"priceOfInari"];
			[kSettings setObject:[NSNumber numberWithInt:abs(arc4random()%kPriceSashimiMax+kPriceSashimiMin)] forKey:@"priceOfSashimi"];
			[kSettings setObject:[NSNumber numberWithInt:abs(arc4random()%kPriceChirashiMax+kPriceChirashiMin)] forKey:@"priceOfChirashi"];
			[kSettings setObject:[NSNumber numberWithInt:abs(arc4random()%kPriceNareMax+kPriceNareMin)] forKey:@"priceOfNare"];
			[kSettings setObject:[NSNumber numberWithInt:abs(arc4random()%kPriceSushizushiMax+kPriceSushizushiMin)] forKey:@"priceOfSushizushi"];
		
			//
			//	Generate bank and debt interest
			//
		
			[kSettings setObject:[NSNumber numberWithInt:[kSavings doubleValue]*kBankInterest] forKey:@"savings"];
			[kSettings setObject:[NSNumber numberWithInt:[kDebt doubleValue]*kDebtInterest] forKey:@"debt"];
		
			//
			//	Generate random events
			//
			
			[self generateRandomEvents];
			
			//
			//	Check if we are entering Tokyo or Osaka and show
			//	the Bank or Credit Union Prompt if we are.
			//
		
			if([[[[tableView cellForRowAtIndexPath:indexPath] textLabel] text] isEqualToString:@"Tokyo"]) {
			
				//
				//	We're entering Tokyo, offer to visit the Bank.
				//
			
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Visit the Bank?", @"")
																message:NSLocalizedString(@"Do you want to visit the National Bank at Tokyo?", @"")
															   delegate:self
													  cancelButtonTitle:kButtonTitleNo
													  otherButtonTitles:nil];
				[alert addButtonWithTitle:kButtonTitleYes];
			
				[alert show];
				[alert release];
			
			}else if([[[[tableView cellForRowAtIndexPath:indexPath] textLabel] text] isEqualToString:@"Osaka"]) {
			
				//
				//	We're entering Osaka, offer to visit the Credit Union.
				//
			
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Visit the Credit Union?", @"")
																message:NSLocalizedString(@"Do you want to visit the Credit Union?", @"")
															   delegate:self
													cancelButtonTitle:kButtonTitleNo
													otherButtonTitles:nil];
				[alert addButtonWithTitle:kButtonTitleYes];
			
				[alert show];
				[alert release];
			}
		}
	}
	
	//
	//	Create a Deal View Controller
	//
	
	DealViewController *dealView = [[DealViewController alloc] initWithStyle:UITableViewStylePlain];
	
	//
	//	Pass the seleceted location as the title of the deal view
	//
	
	[dealView setTitle:[[[tableView cellForRowAtIndexPath:indexPath] textLabel] text]];
	
	//
	//	Resize the rows in the deal view
	//
	
	[dealView.tableView setRowHeight:kDealViewRowHeight];
	
	
	//
	//	Show the deal view controller
	//
	
	[self.navigationController pushViewController:dealView animated:YES];
	
	//
	//	Release the Deal View
	//
	
	[dealView release];	
}

#pragma mark -
#pragma mark Generate the random events

//
//	Generate the random events
//

- (void) generateRandomEvents{
	
	NSArray *arrayOfEvents = [[NSArray alloc] initWithObjects: kRandomEventSpoiled, kRandomEventBiggerCart, kRandomEventFoundAFew, kRandomEventPricesBottomOut, kRandomEventPricesSkyrocket, nil];
	NSArray *arrayOfProbabilities = [[NSArray alloc] initWithObjects: [NSNumber numberWithFloat:kProbabilityOfSpoiled], [NSNumber numberWithFloat:kProbabilityOfBiggerCart], [NSNumber numberWithFloat:kProbabilityOfFoundAFew], [NSNumber numberWithFloat:kProbabilityOfPricesBottomOut], [NSNumber numberWithFloat:kProbabilityOfPricesSkyrocket], nil];
		
		//
		//	Check if the probability is less than the threshold of the event
		//
		
	//
	//	Randomly generate each event
	//
	
	
	
	//
	//	Generate a random number for the event
	//
	
	NSInteger occurance = arc4random()%100+1;
	
	//
	//	A "mob of fans" event can't occur at the
	//	same time as other events, in case the 
	//	game ends...
	//
	
		if(occurance < kProbabilityOfMobOfFans){
			
			//
			//	Calculate how many items the player has on them
			//
			
			NSInteger numberOfItemsOnPlayer = 0;
			
			for(NSNumber *num in [kCart allValues]){
				numberOfItemsOnPlayer += [num integerValue];
			}
			
			if(numberOfItemsOnPlayer > 0){
				
				//
				//	A mob of fans chases the player.
				//	The player has sushi, so offer to
				//	pay off the fans with sushi.
				//
			
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kRandomEventMobOfFans
																message:NSLocalizedString(@"A mob of fans is chasing you. Do you want to give out samples or try to escape?", @"")
															   delegate:self
													  cancelButtonTitle:kButtonTitleRun
													  otherButtonTitles:nil];
				[alert addButtonWithTitle:kButtonTitleShare];
				[alert show];
				[alert release];
				
			}else {
				
				//
				//	A mob of fans chases the player.
				//	The player has nothing, so let the
				//	player make a run for it.
				//
				
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kRandomEventMobOfFans
																message:NSLocalizedString(@"A mob of fans is chasing you. You have nothing to give them. It looks like you have to make a run for it.", @"")
															   delegate:self
													  cancelButtonTitle:kButtonTitleRun
													  otherButtonTitles:nil];
				[alert show];
				[alert release];
			}

		}else{
			
			//
			//	A mob of fans did not occur, 
			//	generate the othermevents
			//
			
			for(int i=0; i<[arrayOfEvents count]; i++){
				
				//
				//	Randomly generate each event
				//
				
				
				
				//
				//	Generate a random number for the event
				//
				
				occurance = arc4random()%100;
				
				if (occurance < [[arrayOfProbabilities objectAtIndex:i] integerValue]) {
			
					//
					//	Depending on the event, handle it
					//
			
					if ([[arrayOfEvents objectAtIndex:i] isEqualToString:kRandomEventBiggerCart]) {
						
						//
						//	Offer a bigger cart for a fee
						//
				
						UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kRandomEventBiggerCart
																	message:[NSString stringWithFormat:@"Do you want to buy a bigger %@ for %@500?", @"cart", kYen]
																   delegate:self
														  cancelButtonTitle:kButtonTitleNo
														  otherButtonTitles:nil];
						[alert addButtonWithTitle:kButtonTitleYes];
						[alert show];
						[alert release];
				
					}else if ([[arrayOfEvents objectAtIndex:i] isEqualToString:kRandomEventFoundAFew]) {
				
						//
						//	Choose which item was found
						//
				
						NSArray *items = [NSArray arrayWithObjects:kItemsNagiri, kItemsMaki, kItemsOshi, kItemsInari, kItemsSashimi, kItemsChirashi, kItemsNare, kItemsSushizushi, nil];
				
						NSInteger itemIndex = floor(arc4random()%[items count])+1;
				
						//
						//	If the item exists, find it
						//
						
						if (itemIndex < [items count]-1){
					
							NSString *itemWhichYouFound = [items objectAtIndex:itemIndex];
				
							//
							//	Check for an item invalidating the "allergic" achievement
							//
				
							if ([itemWhichYouFound isEqualToString:kItemsMaki] || [itemWhichYouFound isEqualToString:kItemsOshi] || [itemWhichYouFound isEqualToString:kItemsInari] || [itemWhichYouFound isEqualToString:kItemsSushizushi]) {
								[kSettings setObject:NO forKey:@"isAllergic"];
							}
				
							//
							//	Choose how many were found
							//
				
							NSInteger howManyWereFound = floor(arc4random()%kMaxItemsFound)+1; 
							
							NSInteger numberOfItemsOnYou = 0;
							
							//
							//	Verify that the player can hold all of the items
							//
							
							for(NSNumber *itemInCart in [kCart allValues]){
								numberOfItemsOnYou += [itemInCart integerValue];
							}

							numberOfItemsOnYou += howManyWereFound;
							
							if(numberOfItemsOnYou <= [kMaxCart integerValue]){
							
								//	
								//	"Apply" the find
								//
				
								NSMutableDictionary *tempCart = [kCart mutableCopy];
				
								NSNumber *tempNumber = [tempCart objectForKey:itemWhichYouFound];
				
								[tempCart setObject:[NSNumber numberWithInteger:howManyWereFound+[tempNumber integerValue]] forKey:itemWhichYouFound];
				
								[kSettings setObject:tempCart forKey:@"cart"];
							
								[tempCart release];
			
								//
								//	Inform the player that they found a few items
								//
							
								UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kRandomEventFoundAFew
																				message:[NSString stringWithFormat:@"%@ %li %@.", NSLocalizedString(@"You found", @""), howManyWereFound, itemWhichYouFound]
																			   delegate:self 
																	  cancelButtonTitle:NSLocalizedString(@"Okay, great!", @"")
																	  otherButtonTitles:nil];
								[alert show];
								[alert release];
								
							}else if ((numberOfItemsOnYou - howManyWereFound) < [kMaxCart integerValue]) {
								
								//
								//	The user could not carry all of them,
								//	pick up whatever can be carried
								//
								
								for (NSInteger i = 0; i < howManyWereFound; i++) {
									
									//
									//	See if there is room for each one
									//	(perhaps we should first determine the correct
									//	number of items and then add them, not increment 
									//	them as we determine how many are found.
									//
									
									if((numberOfItemsOnYou - howManyWereFound)+i < [kMaxCart integerValue]){
										
										//	
										//	"Apply" the find
										//
									
										NSMutableDictionary *tempCart = [kCart mutableCopy];
									
										NSNumber *tempNumber = [tempCart objectForKey:itemWhichYouFound];
									
										[tempCart setObject:[NSNumber numberWithInteger:1+[tempNumber integerValue]] forKey:itemWhichYouFound];
									
										[kSettings setObject:tempCart forKey:@"cart"];
									
										[tempCart release];
									}
								}
								
								UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kRandomEventFoundAFew
																				message:[NSString stringWithFormat:@"%@ %li %@, %@", NSLocalizedString(@"You found", @""), howManyWereFound, itemWhichYouFound, NSLocalizedString(@"but could only carry some of them.", @"")]
																			   delegate:self 
																	  cancelButtonTitle:NSLocalizedString(@"Okay, great!", @"")
																	  otherButtonTitles:nil];
								[alert show];
								[alert release];
								
								
							}else{
								
								//
								//	Inform the player that they found a few items
								//	But they have no room.
								//
								
								UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kRandomEventFoundAFew
																				message:[NSString stringWithFormat:@"%@ %@, %@", NSLocalizedString(@"You found some", @""), itemWhichYouFound, NSLocalizedString(@"but you had no room for it...", @"")]
																			   delegate:nil 
																	  cancelButtonTitle:NSLocalizedString(@"Okay...", @"")
																	  otherButtonTitles:nil];
								[alert show];
								[alert release];
								
							}

							
							
						}
						
						
				
					}else if ([[arrayOfEvents objectAtIndex:i] isEqualToString:kRandomEventPricesBottomOut]) {
				
						//
						//	Choose which item bottoms out
						//
				
						NSArray *items = [NSArray arrayWithObjects:kItemsNagiri, kItemsMaki, kItemsOshi, kItemsInari, kItemsSashimi, kItemsChirashi, kItemsNare, kItemsSushizushi, nil] ;
				
						NSInteger indexOfItem = floor(arc4random()%([items count]+1));
						
						if(indexOfItem < [items count]-1){
						
							NSString *itemWhichBottomsOut = [items objectAtIndex:indexOfItem];
				
							//
							//	Apply the new lower price
							//
					
							if ([itemWhichBottomsOut isEqualToString:kItemsNagiri]) {
								[kSettings setObject:[NSNumber numberWithInteger:[kPriceOfNagiri integerValue] / kBottomOutFactor] forKey:@"priceOfNagiri"];
							}else if ([itemWhichBottomsOut isEqualToString:kItemsMaki]) {
								[kSettings setObject:[NSNumber numberWithInteger:[kPriceOfMaki integerValue] / kBottomOutFactor] forKey:@"priceOfMaki"];
							}else if ([itemWhichBottomsOut isEqualToString:kItemsOshi]) {
								[kSettings setObject:[NSNumber numberWithInteger:([kPriceOfOshi integerValue] / kBottomOutFactor)+2] forKey:@"priceOfOshi"];
							}else if ([itemWhichBottomsOut isEqualToString:kItemsInari]) {
								[kSettings setObject:[NSNumber numberWithInteger:[kPriceOfInari integerValue] / kBottomOutFactor] forKey:@"priceOfInari"];
							}else if ([itemWhichBottomsOut isEqualToString:kItemsSashimi]) {
								[kSettings setObject:[NSNumber numberWithInteger:[kPriceOfSashimi integerValue] / kBottomOutFactor] forKey:@"priceOfSashimi"];
							}else if ([itemWhichBottomsOut isEqualToString:kItemsChirashi]) {
								[kSettings setObject:[NSNumber numberWithInteger:[kPriceOfChirashi integerValue]  / kBottomOutFactor] forKey:@"priceOfChirashi"];
							}else if ([itemWhichBottomsOut isEqualToString:kItemsNare]) {
								[kSettings setObject:[NSNumber numberWithInteger:[kPriceOfNare integerValue] / kBottomOutFactor] forKey:@"priceOfNare"];
							}else if ([itemWhichBottomsOut isEqualToString:kItemsSushizushi]) {
								[kSettings setObject:[NSNumber numberWithInteger:[kPriceOfSushizushi integerValue] / kBottomOutFactor] forKey:@"priceOfSushizushi"];
							}
				
							//
							// Inform the user of the change
							//
					
							UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kRandomEventPricesBottomOut
																		message:[NSString stringWithFormat:@"%@ %@. %@",NSLocalizedString(@"Americans have flooded the market with cheap", @""), itemWhichBottomsOut, NSLocalizedString(@"Prices drop to insane lows!", @"")]
																	   delegate:self 
															  cancelButtonTitle:NSLocalizedString(@"Okay", @"")
															  otherButtonTitles:nil];
							[alert show];
						[alert release];
					
							i++;	//Prices can't skyrocket and bottom out at the same time, so skip the next iteration
							
						}
						
						
					}else if ([[arrayOfEvents objectAtIndex:i] isEqualToString:kRandomEventPricesSkyrocket]) {
				
						//
						//	Prices skyrocket on a particular item.
						//	First, choose which item
						//
				
					NSArray *items = [NSArray arrayWithObjects:kItemsNagiri, kItemsMaki, kItemsOshi, kItemsInari, kItemsSashimi, kItemsChirashi, kItemsNare, kItemsSushizushi, nil];
				
						NSInteger indexOfItem = floor(arc4random()%([items count]+1));
				
						if(indexOfItem < [items count]-1){
							NSString *itemWhichSkyrockets = [items objectAtIndex:indexOfItem];
						
							//
							//	Apply the new higher price
							//
						
							if ([itemWhichSkyrockets isEqualToString:kItemsNagiri]) {
								[kSettings setObject:[NSNumber numberWithInteger:[kPriceOfNagiri integerValue] * kSkyrocketPriceFactor] forKey:@"priceOfNagiri"];
							}else if ([itemWhichSkyrockets isEqualToString:kItemsMaki]) {
								[kSettings setObject:[NSNumber numberWithInteger:[kPriceOfMaki integerValue] * kSkyrocketPriceFactor] forKey:@"priceOfMaki"];
							}else if ([itemWhichSkyrockets isEqualToString:kItemsOshi]) {
								[kSettings setObject:[NSNumber numberWithInteger:[kPriceOfOshi integerValue] * kSkyrocketPriceFactor] forKey:@"priceOfOshi"];
							}else if ([itemWhichSkyrockets isEqualToString:kItemsInari]) {
								[kSettings setObject:[NSNumber numberWithInteger:[kPriceOfInari integerValue] * kSkyrocketPriceFactor] forKey:@"priceOfInari"];
							}else if ([itemWhichSkyrockets isEqualToString:kItemsSashimi]) {
								[kSettings setObject:[NSNumber numberWithInteger:[kPriceOfSashimi integerValue] * kSkyrocketPriceFactor] forKey:@"priceOfSashimi"];
							}else if ([itemWhichSkyrockets isEqualToString:kItemsChirashi]) {
								[kSettings setObject:[NSNumber numberWithInteger:[kPriceOfChirashi integerValue] * kSkyrocketPriceFactor] forKey:@"priceOfChirashi"];
							}else if ([itemWhichSkyrockets isEqualToString:kItemsNare]) {
								[kSettings setObject:[NSNumber numberWithInteger:[kPriceOfNare integerValue] * kSkyrocketPriceFactor] forKey:@"priceOfNare"];
							}else if ([itemWhichSkyrockets isEqualToString:kItemsSushizushi]) {
								[kSettings setObject:[NSNumber numberWithInteger:[kPriceOfSushizushi integerValue] * kSkyrocketPriceFactor] forKey:@"priceOfSushizushi"];
							}
				
							//
							// Inform the user of the change
							//
				
							UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kRandomEventPricesSkyrocket
																		message:[NSString stringWithFormat:@"%@ %@. %@", NSLocalizedString(@"Americans are buying up all of Nippon's", @""), itemWhichSkyrockets, NSLocalizedString(@"Prices are incredibly high!", @"")]
																	   delegate:self 
															  cancelButtonTitle:NSLocalizedString(@"Okay", @"")
															  otherButtonTitles:nil];
							[alert show];		
							[alert release];

						}
				
					}else if ([[arrayOfEvents objectAtIndex:i] isEqualToString:kRandomEventSpoiled]) {
				
						//
						//	TODO: Merge this with Mob catching player
						//	Check that the player has items
						//
						
						NSInteger howManyItemsThePlayerHas = 0;
						
						for(NSNumber *number in [kCart allValues]){
							howManyItemsThePlayerHas += [number integerValue];	
						}
						
						//
						//
						//
						
						
						if(howManyItemsThePlayerHas > 0){
						
							//
							//	"Throw out" some of the player's sushi
							//
					
							NSMutableDictionary *tempCart = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInteger:[[kCart objectForKey:kItemsNagiri] integerValue]/3], kItemsNagiri,
														 [NSNumber numberWithInteger:([[kCart objectForKey:kItemsMaki] integerValue]/3)*2], kItemsMaki,
														 [NSNumber numberWithInteger:([[kCart objectForKey:kItemsOshi] integerValue]/3)*2], kItemsOshi,
														 [NSNumber numberWithInteger:([[kCart objectForKey:kItemsInari] integerValue]/3)*2], kItemsInari,
														 [NSNumber numberWithInteger:([[kCart objectForKey:kItemsSashimi] integerValue]/3)*2], kItemsSashimi,
														 [NSNumber numberWithInteger:([[kCart objectForKey:kItemsChirashi] integerValue]/3)*2], kItemsChirashi, 
														 [NSNumber numberWithInteger:([[kCart objectForKey:kItemsNare] integerValue]/3)*2], kItemsNare,
														 [NSNumber numberWithInteger:([[kCart objectForKey:kItemsSushizushi] integerValue]/3)*2], kItemsSushizushi, nil];
							[kSettings setObject:tempCart forKey:@"cart"];
							[tempCart release];
				
							//
							//	Increment the "Funazushi" count
							//
					
							[kSettings setObject:[NSNumber numberWithInteger:[kNumberOfTimesFunazushi integerValue]+1] forKey:@"numberOfTimesFunazushi"];
					
							//
							//	Post a notification saying that Funazushi occurred
							//
					
							[kNotificationCenter postNotificationName:kFunazushiOccurredNotification object:self];
				
				
							//
							//	All of your items Spoiled
							//
				
							UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kRandomEventSpoiled
																			message:NSLocalizedString(@"Some of your Sushi started to smell funny. You threw it out.", @"inform the user that thier sushi spoiled")
																	   delegate:nil
															  cancelButtonTitle:NSLocalizedString(@"Oh no!", @"")
															  otherButtonTitles:nil];
							[alert show];
							[alert release];
						}
					}
				}
			}
			
			//
			//	Store the new values on disk
			//
		
			[kSettings synchronize];
			
			//
			//	Post a notification that the values have been updated,
			//	so that relevant views can update themselves
			//
			
			[kNotificationCenter postNotificationName:kRandomEventsAreDoneNotification object:self];
	}
	
	
	[arrayOfProbabilities release];
	[arrayOfEvents release];	
}



#pragma mark -
#pragma mark Alert View Delegate

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	if ([alertView.title isEqualToString:NSLocalizedString(@"Visit the Bank?", @"Offer the user the option to visit the bank")]) {
		if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:kButtonTitleYes]) {
			
			//
			//	Post a notification telling the deal view to show the bank
			//
			
			[kNotificationCenter postNotificationName:kShowBankNotification object:nil];
			
		}
	}else if ([alertView.title isEqualToString:NSLocalizedString(@"Visit the Credit Union?", @"Offer the user the option to visit the credit union")]) {
		
		if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:kButtonTitleYes]) {
			
			//
			//	Post a notification telling the deal view to show the credit union
			//
			
			[kNotificationCenter postNotificationName:kShowCreditUnionNotification object:nil];
		}
		
	}else if ([alertView.title isEqualToString:kRandomEventBiggerCart]) {
		
		if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:kButtonTitleYes]) {
			
			if ([kCash integerValue] - 500 >= 0) {
				
				//
				//	Increase the cart size
				//
				
				[kSettings setObject:[NSNumber numberWithInteger:[kMaxCart integerValue]+([kMaxCart integerValue]/4)] forKey:@"maxCart"];
				
				//
				//	Deduct the cash for the cart
				//
				
				[kSettings setObject:[NSNumber numberWithInteger:[kCash integerValue]-500] forKey:@"cash"];
				
				//
				//	Write the changes to disk
				//
				
				[kSettings synchronize];
				
				//
				//	Post a notification that the values have been updated,
				//	so that relevant views can update themselves
				//
				
				[kNotificationCenter postNotificationName:kRandomEventsAreDoneNotification object:self];
				
			}else {
				
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Uh Oh!", @"")
																message:NSLocalizedString(@"You can't afford to buy that, sorry!", @"")
															   delegate:nil
													  cancelButtonTitle:NSLocalizedString(@"Okay...", @"") 
													  otherButtonTitles:nil];
				[alert show];
				[alert release];
			}
		}
		
	}else if ([alertView.title isEqualToString:kRandomEventFoundAFew]) {
		
	}else if([alertView.title isEqualToString:kRandomEventMobOfFans]){
		
		//
		//	Handle player response to Mob
		//
		
		[self handleMobOfFansWithAction:[alertView buttonTitleAtIndex:buttonIndex]];
		
	}else if ([alertView.title isEqualToString:kRandomEventPricesBottomOut]) {
		
	}else if ([alertView.title isEqualToString:kRandomEventPricesSkyrocket]) {
		
	}else if ([alertView.title isEqualToString:kRandomEventSpoiled]) {
		
	}
}

- (void) handleMobOfFansWithAction:(NSString *)action{
		
	//
	//	A mob of fans is chasing you
	//
	
	if ([action isEqualToString:kButtonTitleRun]) {
		
		//
		//	The player chose to run,
		//	determine if they were sucessful
		//
		
		NSInteger wasSuccessful = (NSInteger)(arc4random()%kProbabilityOfDitchingTheMob+1);
		
		if (wasSuccessful > kProbabilityOfDitchingTheMob/2) {
			
			//
			//	The player was successful, alert them of this
			//
			
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Whew...", @"An expression of relief")
															message:NSLocalizedString(@"You lost the mob in the side streets.", @"")
														   delegate:nil
												  cancelButtonTitle:NSLocalizedString(@"Great!", @"An expression of hapiness")
												  otherButtonTitles:nil];
			[alert show];
			[alert release];
			
		}else {
			
			//
			//	The player failed, determine if the player should get 
			//	the same choice, or if all of the player's sushi is
			//	taken by the mob of fans.
			//
			
			
			NSInteger wasOverrun = (NSInteger)(arc4random()%kProbabilityOfDitchingTheMob+1);
			
			//
			//	
			//
			
			if (wasOverrun > kProbabilityOfDitchingTheMob/2){
				
				NSInteger numberOfItemsOnPlayer = 0;
				
				for(NSNumber *num in [kCart allValues]){
					numberOfItemsOnPlayer += [num integerValue];
				}
				
				if(numberOfItemsOnPlayer > 0){
					
					//
					//	A mob of fans chases the player.
					//	The player has sushi, so offer to
					//	pay off the fans with sushi.
					//
					
					UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kRandomEventMobOfFans
																	message:NSLocalizedString(@"A mob of fans is chasing you. Do you want to give out samples or try to escape?", @"")
																   delegate:self
														  cancelButtonTitle:kButtonTitleRun
														  otherButtonTitles:nil];
					[alert addButtonWithTitle:kButtonTitleShare];
					[alert show];
					[alert release];
					
				}else {
					
					//
					//	A mob of fans chases the player.
					//	The player has nothing, so let the
					//	player make a run for it.
					//
					
					UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kRandomEventMobOfFans
																	message:NSLocalizedString(@"The mob is still chasing you! Run!", @"")
																   delegate:self
														  cancelButtonTitle:kButtonTitleRun
														  otherButtonTitles:nil];
					[alert show];
					[alert release];
				}
				
			}else{
				
				//
				//	The fans took some of your money.
				//
				
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Not fast Enough!", @"The user failed to outrun the fans")
																message:NSLocalizedString(@"Your fans caught up with you away and you had to drop money to distract them.", @"")
															   delegate:nil
													  cancelButtonTitle:NSLocalizedString(@"Okay...", @"")
													  otherButtonTitles:nil];
				[alert show];
				[alert release];
				
				//
				//	Cut the players cash in half
				//
				
				[kSettings setObject:[NSNumber numberWithInteger:[kCash integerValue]/2]forKey:@"cash"];
				
				//
				//	Write the changes to disk
				//
				
				[kSettings synchronize];
				
				//
				//	Post a notification that the values have been updated,
				//	so that relevant views can update themselves
				//
				
				[kNotificationCenter postNotificationName:kRandomEventsAreDoneNotification object:self];
			}

		}

		
	}else if ([action isEqualToString:kButtonTitleShare]) {

		//
		//	The player shared half of their sushi.
		//
		
		NSInteger *homwManyItemsPlayerHas = 0;
		
		for(NSNumber *num in [kCart allValues]){
			homwManyItemsPlayerHas += [num integerValue];
		}
		
		if(homwManyItemsPlayerHas > 0){
			
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Whew...", @"")
															message:NSLocalizedString(@"You gave your most dedicated fans half of your sushi and they left you alone.", @"")
														delegate:nil
												cancelButtonTitle:NSLocalizedString(@"It could have been worse.", @"")
												otherButtonTitles:nil];
			[alert show];
			[alert release];
		
			//
			// Remove half of the users sushi
			//
		
			NSMutableDictionary *tempCart = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
											 [NSNumber numberWithInteger:[[kCart objectForKey:@"Nagiri"] integerValue]/2], @"Nagiri",
											 [NSNumber numberWithInteger:[[kCart objectForKey:@"Maki"] integerValue]/2], @"Maki",
											 [NSNumber numberWithInteger:[[kCart objectForKey:@"Oshi"] integerValue]/2], @"Oshi",
											 [NSNumber numberWithInteger:[[kCart objectForKey:@"Inari"] integerValue]/2], @"Inari",
											 [NSNumber numberWithInteger:[[kCart objectForKey:@"Sashimi"] integerValue]/2], @"Sashimi",
											 [NSNumber numberWithInteger:[[kCart objectForKey:@"Chirashi"] integerValue]/2], @"Chirashi", 
											 [NSNumber numberWithInteger:[[kCart objectForKey:@"Nare"] integerValue]/2], @"Nare",
											 [NSNumber numberWithInteger:[[kCart objectForKey:@"Sushizushi"] integerValue]/2], @"Sushizushi", nil];
			[kSettings setObject:tempCart forKey:@"cart"];
			[tempCart release];
		
			//
			//	Write the changes to disk
			//
		
			[kSettings synchronize];
		
			//
			//	Post a notification that the mob took half of the players sushi
			//
		
			[kNotificationCenter postNotificationName:kSushiWasHalvedNotification object:self];
		}
	}else {
		
		//
		//	The player has no sushi to share, run
		//
		
		[self handleMobOfFansWithAction:kButtonTitleRun];
	}

	

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
	[locations release];
    [super dealloc];
}


@end

