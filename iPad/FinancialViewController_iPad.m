//
//  FinancialViewController.m
//  Nippon
//
//  Created by Moshe Berman on 1/12/11.
//  Copyright 2011 MosheBerman.com. All rights reserved.
//

#import "FinancialViewController_iPad.h"
#import "AppDelegate_iPad.h"

@implementation FinancialViewController_iPad

@synthesize mode, price, amountBox, modeSelector;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
 self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
 if (self) {
 // Custom initialization.
 }
 return self;
 }
 */

- (id)initWithMode:(NSString *)viewMode andItem:(NSString *)viewItem atPrice:(NSNumber *)viewPrice{
    self = [self initWithNibName:@"FinancialViewController_iPad" bundle:nil];
	if(self){
		
		//
		//	Store the appropriate values in the view's properties
		//
		
		[self setMode:viewMode];
		[self setTitle:viewItem];
		
		//
		//
		//
		
		//
		//	viewPrice could be nil if we 
		//	are in the Bank or the Credit Union
		//
		
		if(viewPrice != nil){
			[self setPrice:[viewPrice integerValue]];
		}
		
		//
		//	Create the confirm button
		//
		
		UIBarButtonItem *confirmButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Confirm", @"A button confirming the player's action") style:UIBarButtonItemStyleDone target:self action:@selector(handleConfirm)];
		[self.navigationItem setRightBarButtonItem:confirmButton];
		[confirmButton release];
	}
	
	return self;
}


- (IBAction) modeSelectorChanged{
	
	//
	//	Update the amount box place holder based on the 
	//	mode of the financial view and the amount of
	//	relevant monies. (Debt, Savings, Cash, etc.)
	//
	
	
	if([[self mode] isEqualToString:kModeItem]){
		
		//
		//	We'ere in trade view
		//
		
		if ([modeSelector selectedSegmentIndex] == 0) {
			
			//
			//	The Buy button is selected
			//
			
			if([kCash longLongValue]/self.price > 0){
				[self.amountBox setPlaceholder:[NSString stringWithFormat:@"You can afford %lli at %@%i.",[kCash longLongValue]/self.price, kYen,  self.price]];
			}else {
				[self.amountBox setPlaceholder:[NSString stringWithFormat:@"You cannot afford %@.", self.title]];
			}
			
		}else if ([modeSelector selectedSegmentIndex] == 1) {
			
			//
			//	The Sell button is selected
			//
			if([[kCart objectForKey:self.title]integerValue] > 0){
				[self.amountBox setPlaceholder:[NSString stringWithFormat:@"You have %li %@.", [[kCart objectForKey:self.title]integerValue], self.title]];
			}else {
				[self.amountBox setPlaceholder:[NSString stringWithFormat:@"You do not have any %@.", self.title]];
			}
			
		}
		
	}else if ([[self mode] isEqualToString:kModeBank]) {
		
		//
		//	We're in the bank
		//
		
		if ([modeSelector selectedSegmentIndex] == 0) {
			
			//
			//	The Deposit button is selected
			//
			
			[self.amountBox setPlaceholder:[NSString stringWithFormat:@"You have %@%lli.", kYen, [kCash longLongValue]]];
			
		}else if ([modeSelector selectedSegmentIndex] == 1) {
			
			//
			//	The Withdraw button is selected
			//
			
			if([kSavings longLongValue] > 0){
				[self.amountBox setPlaceholder:[NSString stringWithFormat:@"You can withdraw up to %@%lli.", kYen, [kSavings longLongValue]]];
			}else {
				[self.amountBox setPlaceholder:@"You have no savings."];
			}
		}
	}else if ([[self mode] isEqualToString:kModeCreditUnion]) {
		
		//
		//	We're in the Credit Union
		//
		
		if ([modeSelector selectedSegmentIndex] == 0) {
			
			//
			//	The Borrow button is selected
			//
			
			if([kDebt longLongValue] < kDebtCap){
				[self.amountBox setPlaceholder:[NSString stringWithFormat:@"We can lend you up to %@%lli.",kYen, kDebtCap - [kDebt longLongValue]]];
			}else {
				[self.amountBox setPlaceholder:@"We can't trust you 'til you pay."];
			}
			
		}else if ([modeSelector selectedSegmentIndex] == 1) {
			
			//
			//	The Repay button is selected
			//
			
			if([kDebt longLongValue] > 0){
				[self.amountBox setPlaceholder:[NSString stringWithFormat:@"Do you have our %@%lli?", kYen, [kDebt longLongValue]]];
			}else {
				[self.amountBox setPlaceholder:[NSString stringWithFormat:@"How can we help you?"]];
			}
		}
	}
}

#pragma mark -
- (void) viewWillAppear:(BOOL)animated{
	
	if([[self mode] isEqualToString:kModeItem]){
		
        //
        //  Create a formatter
        //
        
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        [formatter setGroupingSize:3];
        [formatter setAlwaysShowsDecimalSeparator:NO];
        [formatter setUsesGroupingSeparator:kFormatterEnabled];
        [formatter setGroupingSeparator:kFormatterGroupingSeparator];
        
		//
		//	Create the "cash" menu
		//
		
		UIBarButtonItem *yenButton = [[UIBarButtonItem alloc] initWithTitle:[NSString stringWithFormat:@"You have %@%@",kYen,[formatter stringFromNumber:kCash]] style:UIBarButtonItemStyleBordered target:[[UIApplication sharedApplication] delegate] action:@selector(showInGameInfo)];
		self.navigationItem.rightBarButtonItem = yenButton;
		[yenButton release];
		
        //
        //  Release the formatter
        //
        
        [formatter release];
        
	}else if ([[self mode] isEqualToString:kModeBank]) {
		
		//
		//	Create the info button
		//
        
		if([kSavings longLongValue] > 0){
			
            //
            //	Create the "cash" menu
            //
            
            //Format the currency amounts
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
            [formatter setGroupingSize:3];
            [formatter setAlwaysShowsDecimalSeparator:NO];
            [formatter setUsesGroupingSeparator:kFormatterEnabled];
            [formatter setGroupingSeparator:kFormatterGroupingSeparator];

            
            UIBarButtonItem *yenButton = [[UIBarButtonItem alloc] initWithTitle:[NSString stringWithFormat:@"%@%@ in savings", kYen, [formatter stringFromNumber: kSavings]] style:UIBarButtonItemStyleBordered target:[[UIApplication sharedApplication] delegate] action:@selector(showInGameInfo)];
			self.navigationItem.rightBarButtonItem = yenButton;
			
            
            [yenButton release];
			
            //
            //
            //
            
            [formatter release];
        
		}else {
			
			UIBarButtonItem *yenButton = [[UIBarButtonItem alloc] initWithTitle:@"No savings" style:UIBarButtonItemStyleBordered target:[[UIApplication sharedApplication] delegate] action:@selector(showInGameInfo)];
			self.navigationItem.rightBarButtonItem = yenButton;
			
            
            [yenButton release];
		}
        

		
		
	}else if ([[self mode] isEqualToString:kModeCreditUnion]) {
		
        //
        //  Create a formatter
        //
        
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        [formatter setGroupingSize:3];
        [formatter setAlwaysShowsDecimalSeparator:NO];
        [formatter setUsesGroupingSeparator:kFormatterEnabled];
        [formatter setGroupingSeparator:kFormatterGroupingSeparator];
	
        //
		//	Create the "cash" menu
		//
		
		UIBarButtonItem *yenButton = [[UIBarButtonItem alloc] initWithTitle:[NSString stringWithFormat:@"You owe %@%@", kYen, [formatter stringFromNumber:kDebt]] style:UIBarButtonItemStyleBordered target:[[UIApplication sharedApplication] delegate] action:@selector(showInGameInfo)];
		self.navigationItem.rightBarButtonItem = yenButton;
		[yenButton release];
		
        //
        //  Release the formatter
        //
        
        [formatter release];
	}else if([self.mode isEqualToString:kModeDeveloper]){
        
        //
        //  Make a cancel button in the top of the dev mode view
        //
        
        
        self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self.parentViewController action:@selector(dismissModalViewControllerAnimated:)] autorelease];
    }
	
	
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	//
	//	Set the placeholder text for the amount box
	//
	
	[self setPlaceholderText];
	
	//
	//	Make the amount box into the first responder
	//
	
	[self.amountBox setInputView:newInput];
	[self.amountBox becomeFirstResponder];
	
}

#pragma mark -

- (IBAction) AddNumber:(id)sender{
	[self.amountBox setText:[NSString stringWithFormat:@"%@%@", self.amountBox.text, [(UIButton *)sender titleLabel].text]];
}

- (IBAction)deleteLast:(id)sender{
	
	//
	//	TODO: Delete the last character in the box
	//
}

- (IBAction) clearBox{
	[self.amountBox setText:@""];	
}

#pragma mark -

//
//	When the confirm button is pressed, do this
//	

- (IBAction) handleConfirm{
	
    if ([self.mode isEqualToString: kModeDeveloper]) {
        
        //
        //  Record the fact that the user cheated
        //
        
        [kSettings setBool:YES forKey:@"cheated"];
        
        //
        //  Set the score
        //
        
        [kSettings setValue:[NSNumber numberWithLongLong:[[self.amountBox text] longLongValue]]forKey:@"cash"];
        
        //
        //  Synchronize the settings
        //
        
        [kSettings synchronize];
        
        //
        //  Release the developer mode view
        //
        
        [self.parentViewController dismissModalViewControllerAnimated:YES];
    }
    
    
	//
	//	Check the view's mode and then perform the 
	//	proper actions based on that mode.
	//
	
	if([self.mode isEqualToString:kModeItem]){
		
		//
		//	We're in item mode, handle according
		//	to the mode selector segmented control.
		//
		
		if (modeSelector.selectedSegmentIndex == 0) {
			[self performPurchase];
		}else if (modeSelector.selectedSegmentIndex == 1) {
			[self performSale];
		}
		
	}else if ([self.mode isEqualToString:kModeBank]) {
		
		//
		//	We're in bank mode, handle according
		//	to the mode selector segmented control.
		//
		
		if (modeSelector.selectedSegmentIndex == 0) {
			[self performDeposit];
		}else if (modeSelector.selectedSegmentIndex == 1) {
			[self performWithdrawal];
		}
		
	}else if([self.mode isEqualToString:kModeCreditUnion]){
		
		//
		//	We're in credit mode, handle according
		//	to the mode selector segmented control.
		//
		
		if (modeSelector.selectedSegmentIndex == 0) {
			[self performPayment];
		}else if (modeSelector.selectedSegmentIndex == 1) {
			[self performBorrow];
		}
	}
	
	//
	//	Refresh the "cash" button
	//
	
	if([[self mode] isEqualToString:kModeItem]){
		
		//
		//	Create the "cash" menu
		//
		
		UIBarButtonItem *yenButton = [[UIBarButtonItem alloc] initWithTitle:[NSString stringWithFormat:@"You have %@%@", kYen, kCash] style:UIBarButtonItemStyleBordered target:[[UIApplication sharedApplication] delegate] action:@selector(showInGameInfo)];
		self.navigationItem.rightBarButtonItem = yenButton;
		[yenButton release];
		
	}else if ([[self mode] isEqualToString:kModeBank]) {
		
        //
		//	Create the "cash" menu
		//
        
        //Format the currency amounts
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        [formatter setGroupingSize:3];
        [formatter setAlwaysShowsDecimalSeparator:NO];
        [formatter setUsesGroupingSeparator:kFormatterEnabled];
        [formatter setGroupingSeparator:kFormatterGroupingSeparator];

        
		//
		//	Create the info menu button
		//
		
		UIBarButtonItem *yenButton = [[UIBarButtonItem alloc] initWithTitle:[NSString stringWithFormat:@"%@%@ in savings", kYen, [formatter stringFromNumber:kSavings]] style:UIBarButtonItemStyleBordered target:[[UIApplication sharedApplication] delegate] action:@selector(showInGameInfo)];
		self.navigationItem.rightBarButtonItem = yenButton;
		
        //
        //  Release the yen button
        //
        
        [yenButton release];
        
        //
        //  Release the formatter
        //
        
        [formatter release];
		
	}else if ([[self mode] isEqualToString:kModeCreditUnion]) {
		
		//
		//	Create the info menu button
		//
		
		if([kDebt longLongValue] > 0){
            
            //
            //	Create the "cash" menu
            //
            
            //Format the currency amounts
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
            [formatter setGroupingSize:3];
            [formatter setAlwaysShowsDecimalSeparator:NO];
            [formatter setUsesGroupingSeparator:kFormatterEnabled];
            [formatter setGroupingSeparator:kFormatterGroupingSeparator];

            
			UIBarButtonItem *yenButton = [[UIBarButtonItem alloc] initWithTitle:[NSString stringWithFormat:@"You owe %@%@", kYen,[formatter stringFromNumber: kDebt]] style:UIBarButtonItemStyleBordered target:[[UIApplication sharedApplication] delegate] action:@selector(showInGameInfo)];
			self.navigationItem.rightBarButtonItem = yenButton;
			
            //
            //
            //
            
            [yenButton release];
            
            //
            //
            //
            
            [formatter release];
		}else {
			UIBarButtonItem *yenButton = [[UIBarButtonItem alloc] initWithTitle:[NSString stringWithFormat:@"You owe nothing", kYen, kDebt] style:UIBarButtonItemStyleBordered target:[[UIApplication sharedApplication] delegate] action:@selector(showInGameInfo)];
			self.navigationItem.rightBarButtonItem = yenButton;
			[yenButton release];
		}
		
		
	}
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
	return YES;	
}

//
//	Handle the Max Button
//

- (IBAction) handleMaxButton{
	
	if([self.mode isEqualToString:kModeItem]){
		
		//
		//	Depending on the toggler mode... 
		//
		
		if(modeSelector.selectedSegmentIndex == 0){
			
			//
			//	Calculate how much space you have left
			//
			
			NSInteger numberOfItemsOnYou = 0;
			
			for(NSNumber *itemInCart in [kCart allValues]){
				numberOfItemsOnYou += [itemInCart integerValue];
			}
			
			//
			//	Deduct the number of items from the overall "cart"
			//
			
			NSInteger numberOfEmptySpaces = [kMaxCart integerValue]- numberOfItemsOnYou;
			
			
			//If the player can afford the item and has room
			if (numberOfEmptySpaces * self.price <= [kCash longLongValue] && numberOfEmptySpaces * self.price > 0) {
				
				//
				//	If the player can afford to fill up on an item, 
				//	then set the amount box to the number of empty spaces
				//
				
				self.amountBox.text = [NSString stringWithFormat:@"%i", numberOfEmptySpaces];
				
				//If the player has some room and can afford some of the item
 			}else if ([kCash longLongValue]/self.price > 0 && numberOfEmptySpaces > 0) {
				
				//
				//	If the player can afford some of an item, 
				//	then set the amount box to that number
				//
				
				self.amountBox.text = [NSString stringWithFormat:@"%lli", [kCash longLongValue]/self.price];
				
			}else if ([kCash longLongValue]/self.price < 1 && numberOfEmptySpaces < 1){
				
				//
				//	Inform the user that they cannot afford this item and that they have no room
				//
				
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Uh Oh!"
																message:@"You don't have enough room and you can't afford any. If you have other Sushi, try selling it first."
															   delegate:nil
													  cancelButtonTitle:@"Okay" 
													  otherButtonTitles:nil];
				[alert show];
				[alert release];
				
			}else if (numberOfEmptySpaces < 1) {
				
				//
				//	Inform the user that they have no room
				//
				
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Uh Oh!"
																message:@"You don't have enough room. Try selling your other Sushi first."
															   delegate:nil
													  cancelButtonTitle:@"Okay" 
													  otherButtonTitles:nil];
				[alert show];
				[alert release];
			}else {
				
				//
				//	Inform the user that they cannot afford this item
				//
				
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Uh Oh!"
																message:@"You cannot afford any. Try selling your other Sushi first."
															   delegate:nil
													  cancelButtonTitle:@"Okay" 
													  otherButtonTitles:nil];
				[alert show];
				[alert release];
				
			}
			
			
			
			
			
		}else if (modeSelector.selectedSegmentIndex == 1) {
			
			//
			//	Calculate how many the player has
			//
			
			if ([[kCart objectForKey:self.title] integerValue] > 0) {
				
				//
				//	The player has some
				//
				
				self.amountBox.text = [NSString stringWithFormat:@"%i",[[kCart objectForKey:self.title] integerValue]];
			}else {
				
				//
				//	The player has none, inform the player
				//
				
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Uh Oh!"
																message:[NSString stringWithFormat:@"You don't have any %@!", self.title]
															   delegate:@""
													  cancelButtonTitle:@"Okay."
													  otherButtonTitles:nil];
				
				[alert show];
				[alert release];
			}			
		}
		
	}else if ([self.mode isEqualToString:kModeBank]) {
		
		//
		//	Depending on the toggler mode... 
		//
		
		if(modeSelector.selectedSegmentIndex == 0){
			
			//
			//	Check that the user has money to deposit
			//
			
			if ([kCash longLongValue] > 0) {
				
				self.amountBox.text = [NSString stringWithFormat:@"%lli", [kCash longLongValue]];
			}else {
				
				//
				//	Inform the user that they have no money to deposit
				//
				
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Uh Oh!"
																message:@"You don't have any money to deposit."
															   delegate:nil
													  cancelButtonTitle:@"Okay" 
													  otherButtonTitles:nil];
				[alert show];
				[alert release];
			}
			
			
		}else if (modeSelector.selectedSegmentIndex == 1) {
			
			//
			//	Check that the user has money to withdraw
			//
			
			if ([kSavings longLongValue] > 0) {
				
				self.amountBox.text = [NSString stringWithFormat:@"%lli", [kSavings longLongValue]];
			}else {
				
				//
				//	Inform the user that they have no savings to withdraw
				//
				
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Uh Oh!"
																message:@"You don't have any savings to withdraw."
															   delegate:nil
													  cancelButtonTitle:@"Okay" 
													  otherButtonTitles:nil];
				[alert show];
				[alert release];
			}
		}
		
	}else if ([self.mode isEqualToString:kModeCreditUnion]) {
		
		//
		//	Depending on the toggler mode... 
		//
		
		if(modeSelector.selectedSegmentIndex == 1){
			
			//
			//	Calculate maximum credit line,
			//
			
			if ([kDebt longLongValue] < kDebtCap) {
				
				//
				//	There is credit available,
				//	fill in the right amount.
				//
				
				self.amountBox.text = [NSString stringWithFormat:@"%lli", kDebtCap - [kDebt longLongValue]];
				
			}else {
				
				//
				//	There is no credit available
				//
				
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Careful!"
																message:@"They don't look like they want to lend you any more!"
															   delegate:nil
													  cancelButtonTitle:@"Okay" 
													  otherButtonTitles:nil];
				[alert show];
				[alert release];
				
			}
			
			
		}else if (modeSelector.selectedSegmentIndex == 0) {
			
			//
			//	Verify that the user has debt
			//
			
			if([kDebt longLongValue] > 0){
				
				//
				//	Check if the user has enough cash to repay
				//
				
				if ([kCash longLongValue] > [kDebt longLongValue]) {
					
					self.amountBox.text = [NSString stringWithFormat:@"%lli", [kDebt longLongValue]];
					
				}else if ([kCash longLongValue] < [kDebt longLongValue]) {
					
					//
					//	Verify that the user has money
					//
					
					if ([kCash longLongValue] > 0) {
						
						self.amountBox.text = [NSString stringWithFormat:@"%lli", [kCash longLongValue]];
						
					}else {
						
						//
						//	Inform the user that they owe nothing
						//
						
						UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Uh Oh!"
																		message:@"You don't have any money on you. Do you want to insult the Credit Union?"
																	   delegate:nil
															  cancelButtonTitle:@"Okay" 
															  otherButtonTitles:nil];
						[alert show];
						[alert release];
						
					}
					
				}
				
				
			}else {
				
				//
				//		Inform the user that they owe nothing
				//
				
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Uh Oh!"
																message:@"You don't owe anything."
															   delegate:nil
													  cancelButtonTitle:@"Okay" 
													  otherButtonTitles:nil];
				[alert show];
				[alert release];
				
			}
			
			
			
		}	
	}else if([self.mode isEqualToString:kModeDeveloper]){
        
        //
        //  Set the textbox to the max value
        //
        
        self.amountBox.text = [NSString stringWithFormat:@"%lli",INT64_MAX];
        
        
    }//end Mode check
}

//
//	Set the placeholder text on the textbox
//

- (void) setPlaceholderText{
	
	
	if([self.mode isEqualToString:kModeItem]){
		
		//
		//	Set the input box placeholder
		//
		
		if([kCash longValue]/self.price > 0){
			[self.amountBox setPlaceholder:[NSString stringWithFormat:@"You can afford %li at %@%i.",[kCash longValue]/self.price, kYen,  self.price]];
		}else {
			[self.amountBox setPlaceholder:[NSString stringWithFormat:@"You cannot afford %@.", self.title]];
		}
		
	}else if ([self.mode isEqualToString:kModeBank]) {
		
		//
		//	Set the input box placeholder
		//
		
		[self.amountBox setPlaceholder:[NSString stringWithFormat:@"It seems that you have %@%lli.", kYen,[kCash longLongValue]]];
		
		
		//
		//	Label the segments properly
		//
		
		[modeSelector setTitle:@"Deposit" forSegmentAtIndex:0];
		[modeSelector setTitle:@"Withdraw" forSegmentAtIndex:1];
		
	}else if ([self.mode isEqualToString:kModeCreditUnion]) {
		
		//
		//	Set the input box placeholder
		//
		
		if([kDebt longValue] > 0){
			[self.amountBox setPlaceholder:[NSString stringWithFormat:@"Do you have our %@%lli?", kYen, [kDebt longLongValue]]];
		}else {
			[self.amountBox setPlaceholder:[NSString stringWithFormat:@"How can we help you?"]];
		}
		
		//
		//	Label the segments properly
		//
		
		[modeSelector setTitle:@"Repay" forSegmentAtIndex:0];
		[modeSelector setTitle:@"Borrow" forSegmentAtIndex:1];
	}	
}

//
//	Set the information label
//

- (void) setInformationLabelText:(NSString *)text{
	
}


#pragma mark -
#pragma mark Transactions


//
//	Perform a purchase
//

- (BOOL) performPurchase{
	if ([amountBox.text isEqualToString:@""] || [amountBox.text isEqualToString:@"0"]){
		
		//
		//	Inform the user that they must enter a value
		//
		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Uh Oh!"
														message:@"You can't buy nothing."
													   delegate:nil
											  cancelButtonTitle:@"OK"
											  otherButtonTitles:nil];
		[alert show];
		[alert release];
		
		return NO;
		
	}else{
		
		//
		//	Check if the user can afford the 
		//	current item and if they can carry it.
		//	If they can, but the items.
		//
		
		//
		//	Calculate the number of items that the player id carrying
		//
		
		NSInteger numberOfItemsOnYou = 0;
		
		for(NSNumber *itemInCart in [kCart allValues]){
			numberOfItemsOnYou += [itemInCart integerValue];
		}
		
		numberOfItemsOnYou += [amountBox.text integerValue];
		
		//
		//	Perform the check
		//
		
		if([amountBox.text integerValue] * [self price] <= [kCash longLongValue] && numberOfItemsOnYou <= [kMaxCart integerValue]){
			
			//
			//	Deduct the cash
			//
			
			[kSettings setObject:[NSNumber numberWithLongLong:[kCash longLongValue] - ([amountBox.text longLongValue] * [self price])] forKey:@"cash"];
			
			
			//
			//	And then "purchase the items"
			//
			
			NSMutableDictionary *tempCart = [kCart mutableCopy];
			
			[tempCart setObject:[NSNumber numberWithInteger:[[kCart objectForKey:self.title] integerValue] + [amountBox.text integerValue]] forKey:[self title]];
			
			[kSettings setObject:[[tempCart copy] autorelease] forKey:@"cart"];
			
			[tempCart release];
			
			//
			//	Add the sale to the "number of items bought" count
			//
			
			[kSettings setObject:[NSNumber numberWithInteger:[kNumberOfItemsBought integerValue] + [amountBox.text integerValue]] forKey:@"numberOfItemsBought"];
			
			
			//
			//	Check for a "No Nori" "violation"
			//
			
			if ([self.title isEqualToString:kItemsMaki] || [self.title isEqualToString:kItemsOshi] || [self.title isEqualToString:kItemsInari] || [self.title isEqualToString:kItemsSushizushi]) {
				[kSettings setBool:YES forKey:@"noNori"];
			}
			
			//
			//	Check for Sushizushi
			//
			
			if ([self.title isEqualToString:kItemsSushizushi]) {
				[kNotificationCenter postNotificationName:kPlayerHasSushizushiNotification object:nil];
			}
			
			//
			//	Synchronize (write) the changes to disk
			//
			
			[kSettings synchronize];
			
			
			//
			//	Check for "well rounded" achievement
			//
			
			NSInteger uniqueItemsCarried = 0;
			
			for(NSNumber *number in [kCart allValues]){
				
				//
				//	If a player has more than one of an item,
				//	then they are carrying it
				//
				
				if([number integerValue] > 0){
					uniqueItemsCarried = uniqueItemsCarried + 1;
				}
			}
			
			//
			//	If the player has four or more unique items
			//
			
			if (uniqueItemsCarried >= 4) {
				
				
				//
				//	Post the appropriate notification
				//
				
				[kNotificationCenter postNotificationName:kPlayerIsWellRoundedNotification object:nil];
			}
			
			NSInteger itemsThatPlayerOnlyHasOneOf = 0;
			
			for(NSNumber *number in [kCart allValues]){
				if ([number integerValue] == 1) {
					itemsThatPlayerOnlyHasOneOf = itemsThatPlayerOnlyHasOneOf + 1;
				}
			}
			
			//NSLog(@"Player has one of %i items.", itemsThatPlayerOnlyHasOneOf);
			
			if (itemsThatPlayerOnlyHasOneOf == 8) {	
				
				//
				//	Post a notification saying that the player has one of everything
				//
				
				[kNotificationCenter postNotificationName:kPlayerIsInForOneNotification object:nil];
				
			}
			
			
			
			
			//
			//	Pop to the items menu
			//
			
			[self.navigationController popViewControllerAnimated:YES];	
			
			//
			//	Notify the interested objects that a purchase occured
			//
			
			[kNotificationCenter postNotificationName:kPurchaseOccurredNotification object:self];
			
		}else {
			
			//
			//	Inform the user that they can't afford 
			//	an item or that they have no room.
			//
			
			if([amountBox.text integerValue] * [self price] > [kCash longLongValue] && numberOfItemsOnYou > [kMaxCart integerValue]){
				
				//
				//	Inform the user that they cannot afford the
				//	number of items and that they have no room
				//
				
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Uh Oh!"
																message:[NSString stringWithFormat:@"You cannot buy %@ %@. You don't have enough room and you can't afford it. Try selling some of your other sushi first.", [amountBox text], [self title]]
															   delegate:nil
													  cancelButtonTitle:@"Okay"
													  otherButtonTitles:nil];
				[alert show];
				[alert release];
				
			}else if ([amountBox.text integerValue] * [self price] > [kCash longValue]) {
				
				//
				//	Inform the user that they cannot afford the
				//	number of items and that they have no room
				//
				
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Uh Oh!"
																message:[NSString stringWithFormat:@"You cannot buy %@ %@. You can't afford it. Try selling some of your other sushi first.", [amountBox text], [self title]]
															   delegate:nil
													  cancelButtonTitle:@"Okay"
													  otherButtonTitles:nil];
				[alert show];
				[alert release];
				
			}else if (numberOfItemsOnYou > [kMaxCart integerValue]) {
				
				//
				//	Inform the user that they cannot afford the
				//	number of items and that they have no room
				//
				
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Uh Oh!"
																message:[NSString stringWithFormat:@"You cannot buy %@ %@. You don't have enough room. Try selling some of your other sushi first.", [amountBox text], [self title]]
															   delegate:nil
													  cancelButtonTitle:@"Okay"
													  otherButtonTitles:nil];
				[alert show];
				[alert release];
				
			}
			
			return NO;
		}
	}
	
	return YES;
}

//
//	Sell an itme
//

- (BOOL) performSale{
	
	//
	//	Check that the user has entered a valid value
	//
	
	if ([amountBox.text isEqualToString:@""] || [amountBox.text isEqualToString:@"0"]){
		
		//
		//	Inform the user that they must enter
		//	a value that is greater than zero
		//
		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Uh Oh!"
														message:@"You can't sell nothing." 
													   delegate:nil 
											  cancelButtonTitle:@"OK" 
											  otherButtonTitles:nil];
		[alert show];
		[alert release];
		
		return NO;
		
	}else{
		
		//
		//	Check that the player has that many items
		//	to sell. If they do, perform the sale.
		//
		
		if ([amountBox.text integerValue] <= [[kCart objectForKey:self.title] integerValue]) {
			
			//
			//	Perform the sale
			//
			
			NSMutableDictionary *tempCart = [kCart mutableCopy];
			
			[tempCart setObject:[NSNumber numberWithInteger:[[kCart objectForKey:self.title] integerValue] - [amountBox.text integerValue]] forKey:self.title];
			
			[kSettings setObject:tempCart forKey:@"cart"];
			
			[tempCart release];
			
			//
			//	Add the cash to the player's wallet
			//
			
			[kSettings setObject:[NSNumber numberWithLongLong:[kCash longLongValue] + ([amountBox.text longLongValue] * [self price])] forKey:@"cash"];
			
			//
			//	Apply the Inheritance achievement
			//
			
			if (isGameCenterAvailable()) {
				if ([self.title isEqualToString:@"Sushizushi"]) {
					if ([amountBox.text integerValue] >= 100) {
						[(AppDelegate_iPad *)[[UIApplication sharedApplication] delegate] reportAchievementIdentifier:kAchievementInheritance percentComplete:100.0];
					}
				}
			}
				
			//
			//	Synchronize (write) the changes to disk
			//
			
			[kSettings synchronize];
			
			//
			//	Pop to the items menu
			//
			
			[self.navigationController popViewControllerAnimated:YES];	
			
			//
			//	Add the sale to the "number of items sold" count
			//
			
			[kSettings setObject:[NSNumber numberWithInteger:[kNumberOfItemsSold integerValue] + [amountBox.text integerValue]] forKey:@"numberOfItemsSold"];
			
			//
			//	Write the changes to disk
			//
			
			[kSettings synchronize];
			
			//
			//	Notify the interested objects that a sale occured
			//
			
			[kNotificationCenter postNotificationName:kSaleOccurredNotification object:self];
			
		}else {
			
			if ([[kCart objectForKey:self.title] integerValue] > 0) {
				
				//
				//	Inform the user that they don't have that many items to sell
				//
				
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Uh Oh!"
																message:[NSString stringWithFormat:@"You don't have that many %@ to sell.", self.title]
															   delegate:nil
													  cancelButtonTitle:@"Okay"
													  otherButtonTitles:nil];
				[alert show];
				[alert release];
				
			}else{
				
				//
				//	Inform the user that they don't have any of this item to sell
				//
				
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Uh Oh!"
																message:[NSString stringWithFormat:@"You don't have any %@!", self.title]
															   delegate:nil
													  cancelButtonTitle:@"Okay"
													  otherButtonTitles:nil];
				[alert show];
				[alert release];
			}
			
			return NO;
		}
		
	}
	
	return YES;
}

//
//	Withdraw money from the bank
//

- (BOOL) performWithdrawal{
	
	//
	//	Validate the input
	//
	
	if ([amountBox.text isEqualToString:@""] || [amountBox.text isEqualToString:@"0"]){
		
		//
		//	Inform the user that they must enter
		//	a value that is greater than zero
		//
		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Can't Withdraw:"
														message:[NSString stringWithFormat:@"You can't withdraw %@0...", kYen]
													   delegate:nil
											  cancelButtonTitle:@"OK"
											  otherButtonTitles:nil];
		[alert show];
		[alert release];
		
		return NO;
		
	}else{
		
		if ([self.amountBox.text integerValue] <= [kSavings longValue]){
			
			//
			//	Deduct the money from the savings
			//
			
			[kSettings setObject:[NSNumber numberWithLongLong:[kSavings longLongValue] - [self.amountBox.text longLongValue]] forKey:@"savings"];
			
			//
			//	Add the money to the cash
			//
			
			[kSettings setObject:[NSNumber numberWithLongLong:[kCash longLongValue] + [self.amountBox.text longLongValue]] forKey:@"cash"];
			
			//
			//	Store the changes on disk
			//
			
			[kSettings synchronize];
			
			//
			//	Reset the amount box
			//
			
			[self.amountBox setText:@""];
			
			//
			//	Set the text box placeholder text
			//
			
			[self setPlaceholderText];
			
		}else{
			
			//
			//	Inform the user that there is not enough cash to withdraw.
			//
			
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Can't Withdraw:"
															message:[NSString stringWithFormat:@"You don't have %@%@ to withdraw.", kYen, [amountBox text]] 
														   delegate:nil
												  cancelButtonTitle:@"Okay" 
												  otherButtonTitles:nil];
			[alert show];
			[alert release];
			
			return NO;
		}
	}
	
	
	return YES;
}

//
//	Deposit money into the bank
//

- (BOOL) performDeposit{
	
	if ([amountBox.text isEqualToString:@""] || [amountBox.text isEqualToString:@"0"]){
		
		//
		//	Inform the user that they must enter
		//	a value that is greater than zero
		//
		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Can't Deposit:"
														message:[NSString stringWithFormat:@"You can't deposit %@0...", kYen]
													   delegate:nil
											  cancelButtonTitle:@"OK"
											  otherButtonTitles:nil];
		[alert show];
		[alert release];
		
		return NO;
	}else {
		
		if ([amountBox.text integerValue] <= [kCash longLongValue]) {
			
			//
			//	Deduct the amount of cash from the user's "wallet"
			//
			
			[kSettings setObject:[NSNumber numberWithLongLong:[kCash longLongValue] - [self.amountBox.text longLongValue]] forKey:@"cash"];
			
			//
			//	Add the correct amount of cash to the bank account
			//
			
			[kSettings setObject:[NSNumber numberWithLongLong:[kSavings longLongValue] + [self.amountBox.text longLongValue]] forKey:@"savings"];
			
			//
			//	Write the changes to disk
			//
			
			[kSettings synchronize];
			
			//
			//	Reset the amount box
			//
			
			[self.amountBox setText:@""];
			
			
			//
			//	Set the text box placeholder text
			//
			
			[self setPlaceholderText];
			
		}else {
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Can't Deposit:"
															message:[NSString stringWithFormat:@"You can't deposit %@%@. You don't have that much!", kYen, [self.amountBox text]]
														   delegate:nil
												  cancelButtonTitle:@"OK"
												  otherButtonTitles:nil];
			[alert show];
			[alert release];
			
			return NO;
		}
		
	}
	
	return YES;
}

//
//	Borrow from the loan shark
//

- (BOOL) performBorrow{
	
	//
	//	Validate the input
	//
	
	if ([amountBox.text isEqualToString:@""] || [amountBox.text isEqualToString:@"0"]){
		
		//
		//	Inform the user that they must enter
		//	a value that is greater than zero
		//
		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Can't Borrow:" 
														message:[NSString stringWithFormat:@"You can't borrow %@0. It's insulting to even ask for something like that!", kYen] 
													   delegate:nil
											  cancelButtonTitle:@"OK"
											  otherButtonTitles:nil];
		[alert show];
		[alert release];
		
		return NO;
		
	}else{
		
		if ([kDebt longLongValue] + [self.amountBox.text integerValue] <= kDebtCap){
			
			//
			//	Increase the amount of debt
			//
			
			[kSettings setObject:[NSNumber numberWithInteger:[kDebt longLongValue] + [self.amountBox.text longLongValue]] forKey:@"debt"];
			
			//
			//	Add the money to the cash
			//
			
			[kSettings setObject:[NSNumber numberWithInteger:[kCash longLongValue] + [self.amountBox.text longLongValue]] forKey:@"cash"];
			
			//
			//	Store the changes on disk
			//
			
			[kSettings synchronize];
			
			
			//
			//	Reset the amount box
			//
			
			[self.amountBox setText:@""];
			
			//
			//	Set the text box placeholder text
			//
			
			[self setPlaceholderText];
			
		}else{
			
			//
			//	Inform the user that there is not enough cash to withdraw.
			//
			
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Can't Borrow:"
															message:[NSString stringWithFormat:@"We don't trust you enough to lend you %@%@. Sorry!", kYen, [amountBox text]] 
														   delegate:nil
												  cancelButtonTitle:@"Okay" 
												  otherButtonTitles:nil];
			[alert show];
			[alert release];
			
			return NO;
		}
	}
	
	
	return YES;
}

//
//	Pay the loan shark
//

- (BOOL) performPayment{
	
	
	//
	//	Validate the input
	//
	
	if ([amountBox.text isEqualToString:@""] || [amountBox.text isEqualToString:@"0"] || [amountBox.text isEqualToString:@"00000"]){
		
		//
		//	Inform the user that they must enter
		//	a value that is greater than zero
		//
		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Can't Pay:" 
														message:[NSString stringWithFormat:@"You can't pay %@0. It's insulting to even ask for something like that!", kYen] 
													   delegate:nil
											  cancelButtonTitle:@"OK"
											  otherButtonTitles:nil];
		[alert show];
		[alert release];
		
		//
		//	EASTER EGG - If the user enters five zeros, they get ¥500 for free. Sweet!
		//
		
		if([amountBox.text isEqualToString:@"00000"]) {
			
			//
			//	Give the user 500 yen
			//
			
			[kSettings setObject:[NSNumber numberWithInteger:[kCash longLongValue] + 500] forKey:@"cash"];
			
			//
			//	Pop the view controller
			//
			
			[self.navigationController popViewControllerAnimated:YES];
			
			//
			//	Report the achievement to the notification center
			//
			
			[kNotificationCenter postNotificationName:kEasterEggNotification object:self];
			
		}
		
		return NO;
		
	}else{
		
		if ([self.amountBox.text longLongValue] <= [kDebt longLongValue] && [self.amountBox.text longLongValue] <= [kCash longLongValue]){
			
			//
			//	Dencrease the amount of debt
			//
			
			[kSettings setObject:[NSNumber numberWithLongLong:[kDebt longLongValue] - [self.amountBox.text longLongValue]] forKey:@"debt"];
			
			//
			//	Remove the money from the player's cash
			//
			
			[kSettings setObject:[NSNumber numberWithLongLong:[kCash longLongValue] - [self.amountBox.text longLongValue]] forKey:@"cash"];
			
			//
			//	Store the changes on disk
			//
			
			[kSettings synchronize];
			
			//
			//	Reset the amount box
			//
			
			[self.amountBox setText:@""];
			
			//
			//	Set the text box placeholder text
			//
			
			[self setPlaceholderText];
			
		}else if([self.amountBox.text longLongValue] > [kDebt longLongValue]) {
			
			//
			//	Inform the user that they don't owe that much.
			//
			
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Can't Pay:"
															message:[NSString stringWithFormat:@"You don't owe %@%@. They'd probably take it, but why offer?", kYen, [amountBox text]] 
														   delegate:nil
												  cancelButtonTitle:@"No" 
												  otherButtonTitles:nil];
			[alert show];
			[alert release];
			
			return NO;
			
		}else if([self.amountBox.text integerValue] > [kCash longLongValue]){
			
			//
			//	Inform the user that there is not enough cash to repay.
			//
			
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Can't Pay:"
															message:[NSString stringWithFormat:@"You don't have %@%@ to repay. Are you sure you want to offend them?", kYen, [amountBox text]] 
														   delegate:nil
												  cancelButtonTitle:@"No" 
												  otherButtonTitles:nil];
			[alert show];
			[alert release];
			
			return NO;
		}
	}
	
	
	return YES;
}

#pragma mark -

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[modeSelector release];
	[mode release];
	[amountBox release];
    [super dealloc];
}


@end
