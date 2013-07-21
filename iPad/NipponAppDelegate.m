//
//  NipponAppDelegate.m
//  
//
//  Created by Moshe Berman on 1/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NipponAppDelegate.h"

#import "SpiffyKit.h"

@implementation NipponAppDelegate

@synthesize window, mainMenu, tempAchievements, tempScores, achievementsDictionary;

#pragma mark - Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
	//
	//	Initialize the "Game in progress" flag.
	//
	
	if(kInGame != YES && kInGame != NO){
		[kSettings setBool:NO forKey:@"inGame"];
	}
	
	//
	//	Initialize the "Games Counted" count object
	//
	
	if (kNumberOfGamesPlayed == nil) {
		[kSettings setObject:@0 forKey:@"numberOfGamesPlayed"];
	}
	
	//
	//	Initialize the "Items Bought" count object
	//
	
	if (kNumberOfItemsBought == nil) {
		[kSettings setObject:@0 forKey:@"numberOfItemsBought"];
	}
	
	//
	//	Initialize the "Items Sold" object
	//
	
	if (kNumberOfItemsSold == nil) {
		[kSettings setObject:@0 forKey:@"numberOfItemsSold"];
	}
	
	//
	//	Initialize the "Funazushi" count object
	//
    
	if (kNumberOfTimesFunazushi == nil) {
		[kSettings setObject:@0 forKey:@"numberOfTimesFunazushi"];		
	}
	
	//
	//
	//
	
	if (kTempScores == nil) {
		[kSettings setObject:[[NSMutableArray alloc] init] forKey:@"tempScores"];
	}
    
    //
	//
	//
	
	if (kDevMode == nil) {
		[kSettings setObject:@"NO" forKey:@"devMode"];
	}
    
    //
    //  Set the number of visible alerts to zero
    //
    
    numberOfVisibleAlerts = 0;
	
	//
	//	Start listening for a game related notifications
	//
	
	[kNotificationCenter addObserver:self selector:@selector(newGame:) name:kStartNewGameNotification object:nil];
	[kNotificationCenter addObserver:self selector:@selector(resumeGame:) name:kResumeGameNotification object:nil];
	[kNotificationCenter addObserver:self selector:@selector(showInstructions:) name:kShowInstructionsNotification object:nil];
	[kNotificationCenter addObserver:self selector:@selector(showGameCenterActionSheet:) name:kShowGameCenterNotification object:nil];
	[kNotificationCenter addObserver:self selector:@selector(endGame:) name:kGameOverNotification object:nil];
	[kNotificationCenter addObserver:self selector:@selector(presentBannerWithNotification:) name:kShowAlertNotification object:nil];
    
	//
	//	Create and show the main menu
	//
	
	MainMenuViewController *menuView = nil;
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        menuView = [[MainMenuViewController alloc] initWithNibName:@"MainMenuViewController" bundle:nil];
    }else{
        menuView = [[MainMenuViewController_iPad alloc] initWithNibName:@"MainMenuViewController_iPad" bundle:nil]; 
    }
    
	[self setMainMenu:menuView];
	
	self.window.rootViewController = menuView;
    
    self.window.backgroundColor = [UIColor colorWithRed:0.81 green:0.16 blue:0.14 alpha:1.00];
    
    [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:0.81 green:0.16 blue:0.14 alpha:1.00]];
    
	//
	//	Show the main Window
	//
	
    [self.window makeKeyAndVisible];
	
	//
	//	Authenticate if game center is available
	//
	
	
	if(isGameCenterAvailable()){
		
		//
		//	Authenticate with game center
		//
		
		[self authenticateLocalPlayer];
		
		//
		//	Initialize the acheivements dictionary
		//
		
		achievementsDictionary = [tempAchievements mutableCopy];
		tempScores = [[NSMutableArray alloc] init];
		
		//
		//	Register for the Achievement related notifications
		//
		
		[kNotificationCenter addObserver:self selector:@selector(reportEasterEgg:) name:kEasterEggNotification object:nil];
		[kNotificationCenter addObserver:self selector:@selector(handleFunazushiNotification:) name:kFunazushiOccurredNotification object:nil];
		[kNotificationCenter addObserver:self selector:@selector(handlePurchaseNotification:) name:kPurchaseOccurredNotification object:nil];
		[kNotificationCenter addObserver:self selector:@selector(handlePlayerIsWellRounded:) name:kPlayerIsWellRoundedNotification object:nil];		
		[kNotificationCenter addObserver:self selector:@selector(handlePlayerIsInForOne:) name:kPlayerIsInForOneNotification object:nil];		
		[kNotificationCenter addObserver:self selector:@selector(handlePlayerHasSushizushi:) name:kPlayerHasSushizushiNotification object:nil];				
		
	}else{
        
        
    }
    
    //
	//	Prompt the user for rating
	//
    
	[Appirater applicationDidFinishLaunching:YES];
    
    //
    //  Configure Spiffy
    //
    
    [self configureSpiffy];
    
	
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    //
	//	Store and Release the achievements dictionary
	//
	
	[kSettings setObject:self.tempAchievements forKey:@"tempAchievements"];
	
	//
	//	Store and Release the temporary scores
	//
	
	[kSettings setObject:self.tempScores forKey:@"tempScores"];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    
	//
	//	If game center is available
	//
	
	if (isGameCenterAvailable()) {
        
		//
		//	Authenticate the player
		//
		
		[self authenticateLocalPlayer];
        
	}
	
	//
	//	Prompt the user to rate
	//
	
	//[Appirater applicationDidEnterForeground:YES];
    
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
	
	//
	//	Stop listening for notifications
	//
	
	[kNotificationCenter removeObserver:self];
	
	//
	//	Store and Release the achievements dictionary
	//
	
	[kSettings setObject:self.tempAchievements forKey:@"tempAchievements"];
	
	//[self.tempAchievements release];
	
	//
	//	Store and Release the temporary scores
	//
	
	[kSettings setObject:self.tempScores forKey:@"tempScores"];
	
    
	[kSettings synchronize];    
}

#pragma mark -
#pragma mark  Misc

- (void) resetPreferences{
	
	//
	//	The number of days left:
	//
	
	[kSettings setObject:@kInitialDaysLeft forKey:@"daysLeft"];
	
    //
    //  Reset the double length game
    //
    
    [kSettings setBool:NO forKey:@"doubleLength"];
    
	//
	//	The number of items your "cart" can hold:
	//
	
	[kSettings setObject:@kInitialCart forKey:@"maxCart"];
	
	//
	//	How much cash you start with:
	//
	
	[kSettings setObject:[NSNumber numberWithLongLong:kInitialCash] forKey:@"cash"];
    
	//
	//	How much debt you start with:
	//
	
	[kSettings setObject:[NSNumber numberWithLongLong:kInitialDebt] forKey:@"debt"];
	
	//
	//	How much savings you start with:
	//
	
	[kSettings setObject:[NSNumber numberWithLongLong:kInitialSavings] forKey:@"savings"];
	
	//
	//	Clear the last location
	//
	
	[kSettings setObject:@"Nowhere Yet" forKey:@"lastLocation"];
	
    //
    //  Reset the "cheated" flag
    //
    
    [kSettings setBool:NO forKey:@"cheated"];
    
	//
	//	Initialize your cart
	//
	
	NSMutableDictionary *tempCart = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
									 @0, kItemsNagiri,
									 @0, kItemsMaki,
									 @0, kItemsOshi,
									 @0, kItemsInari,
									 @0, kItemsSashimi,
									 @0, kItemsChirashi, 
									 @0, kItemsNare,
									 @0, kItemsSushizushi, nil];
    
	[kSettings setObject:tempCart forKey:@"cart"];
	
	
	//
	//	Reset the "no nori" achievement flag
	//
	
	[kSettings setBool:YES forKey:@"noNori"];
	
	//
	//	Reset the "allergic" achievement flag
	//
	
	[kSettings setBool:YES forKey:@"isAllergic"];
	
	//
	//	Reset the "Day Trader" achievement count
	//
	
	[kSettings setObject:@0 forKey:@"numberOfItemsSold"];
    
    //
    //  Write the changes to disk
    //
    
    [kSettings synchronize];
	
}

//
//	Report the easter egg achievement to Game Center
//

- (void) reportEasterEgg:(NSNotification *)notif{
	if(isGameCenterAvailable()){
		[self reportAchievementIdentifier:kAchievementFiveO percentComplete: 100.0];
	}
}

//
//	Handle a Funazushi event
//

- (void) handleFunazushiNotification:(NSNotification *)notif{
    
	//
	//	If game center is available
	//
	
	if (isGameCenterAvailable()) {
        
		//
		//	If progress is less than %100, report the proper progress.
		//	Otherwise, report full progress
		//
		
		if ([kNumberOfTimesFunazushi integerValue] < kFunazushiThreshold) {
			[self reportAchievementIdentifier:kAchievementFunazushi percentComplete:[kNumberOfTimesFunazushi floatValue] * (100/kFunazushiThreshold)];
		}else {
			[self reportAchievementIdentifier:kAchievementFunazushi percentComplete:100.0];
		}
	}
}


//
//	Handle Purchase Notification
//

- (void) handlePurchaseNotification:(NSNotification *)notif{
	//NSLog(@"<MBNotification:> Purchase occurred.");
	
	if ([kNumberOfItemsBought integerValue] < kCornerTheMarketThreshold) {
		[self reportAchievementIdentifier:kAchievementCornerTheMarket percentComplete:(float)([kNumberOfItemsBought floatValue]/kCornerTheMarketThreshold) * 100];		
	}else{
		[self reportAchievementIdentifier:kAchievementCornerTheMarket percentComplete:100.0];
	}
	//NSLog(@"<MBNotification:> Progress: %f", (float)([kNumberOfItemsBought floatValue]/kCornerTheMarketThreshold) * 100);
}

//
//	The player earned the "well rounded" achievement
//

- (void) handlePlayerIsWellRounded:(NSNotification *)notif{
	if (isGameCenterAvailable()) {
		[self reportAchievementIdentifier:kAchievementWellRounded percentComplete:100.0];
	}
}


//
//	Handle Player Is In For One Notification
//

- (void) handlePlayerIsInForOne:(NSNotification *)notif{
	if (isGameCenterAvailable()) {
		[self reportAchievementIdentifier:kAchievementInForOne percentComplete:100.0];
	}	
}

//
//	Handle Player Has Sushizushi Notification
//

- (void) handlePlayerHasSushizushi:(NSNotification *)notif{
	if (isGameCenterAvailable()) {
		[self reportAchievementIdentifier:kAchievementWealthy percentComplete:100.0];
	}	
}

#pragma mark -
#pragma mark Button Methods

//
//	Create and show the Main Game View
//

- (void) newGame:(NSNotification *)notif{
	
	if(kInGame == YES){
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:NSLocalizedString(@"You have a game in progress. Starting a new game will cause the old game to be lost. Do you really want to start over?", @"ask if the user wants to restart") 
                                                       delegate:self
											  cancelButtonTitle:NSLocalizedString(@"No", @"no")
											  otherButtonTitles:nil];
		[alert addButtonWithTitle:NSLocalizedString(@"Yes", @"yes")];
		[alert show];
		
	}else{
		
		//
		//	Reset the preferences
		//
		
		[self resetPreferences];
        
        //
		//	Enable the "in game" flag
		//
        
		[kSettings setBool:YES forKey:@"inGame"];        
        
        //
        //  Show the game
        //
        
        [self createGameViewAndShowIt];
        
	}
}

//
//	Resume the game if possible
//

- (void) resumeGame:(NSNotification *)notif{
	
	
	if(kInGame == YES){
		
		[self createGameViewAndShowIt];
		
	}else{
		
		//
		//	Alert the user that they need to start a game
		//
		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
														message:NSLocalizedString(@"You have no game to continue.", @"Inform the user that there is no game to continue")
													   delegate:nil
											  cancelButtonTitle:NSLocalizedString(@"Back to Menu", "close the alert and return to the menu")
											  otherButtonTitles:nil];
		[alert show];
	}
	
}

- (void) createGameViewAndShowIt{
    
	//
	//	Create the necessary views
	//
	
    UIViewController *travelView = nil;
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        
        travelView = [[TravelViewController alloc] initWithStyle:UITableViewStylePlain];
        [((UITableViewController *)travelView).tableView setRowHeight:kRowHeight];      
        UINavigationController *game = [[UINavigationController alloc] initWithRootViewController:travelView];
        
        //
        //	Style the toolbar, as used for the "Bank" and "Credit Union" buttons
        //
    
        [game.toolbar setTranslucent:YES];
        
        //
        //	Present the game view
        //
        
        [self.mainMenu presentViewController:game animated:YES completion:nil];
        
        //
        //	release the game view
        //
        
        
        
    }else{
        travelView = [[TravelViewControllerPad alloc] initWithNibName:@"TravelViewControllerPad" bundle:nil];
        if([self.mainMenu respondsToSelector:@selector(presentViewController:animated:completion:)]){
            [self.mainMenu presentViewController:travelView animated:YES completion:^{}];
        }else{
            [self.mainMenu presentViewController:travelView animated:YES completion:nil];
        }
    }
	
    //
    //
    //	Release the travel view
    //
    

}


//
//	Create and show the instructions view
//

- (void) showInstructions:(NSNotification *)notif{
	
	//
	//	Show the instructions view
	//
	
	UIViewController *instructions = nil;
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        instructions = [[HowToPlayViewController alloc] initWithNibName:@"HowToPlayViewController" bundle:nil];
    }else{
        instructions = [[Instructions alloc] initWithNibName:@"Instructions" bundle:nil];
               
    }
    
	UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:instructions];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [navigationController setModalPresentationStyle:UIModalPresentationFormSheet];
    }
    //
    //  Release the instructions view
    //
    
    
    //
    //  Present the modal view
    // 
	
	[self.mainMenu presentViewController:navigationController animated:YES completion:nil];
	
    //
    //  Release the navigation controller
    //
    
	
}

//
//	Hide the instructions view
//

- (void) hideInstructions{
	[self.mainMenu dismissViewControllerAnimated:YES completion:nil];
}

//
//	Hide the game view
//

- (void) hideGameView{
    
    //
    //
    //
    
	[mainMenu dismissViewControllerAnimated:YES completion:nil];
}




//
//	Show in game information alert
//

- (void) showInGameInfo{
	
	//
	//	Populate the information and show it to the user
	//
	
	NSArray *vals = [kCart allValues];
	NSInteger numberOfItems = 0.0;
	for(id val in vals){ 
		if([val isKindOfClass:[NSNumber class]]){
			numberOfItems += [val integerValue];
		}
	} 
    
    //
    //  Create a formatter to format the numbers in the UI
    //
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
	[formatter setGroupingSeparator:kFormatterGroupingSeparator];
    [formatter setGroupingSize:3];
    [formatter setAlwaysShowsDecimalSeparator:NO];
    [formatter setUsesGroupingSeparator:kFormatterEnabled];
    
	NSString *message = [NSString stringWithFormat: @"%@: %@\n%@: %li/%@\n%@: ¥%@\n%@: ¥%@\n%@: ¥%@", NSLocalizedString(@"Days Left", @"how much time remains") ,kDaysLeft, NSLocalizedString(@"Cart", @"how many items the user has and how many they can carry at once"), (long)numberOfItems, kMaxCart, NSLocalizedString(@"Cash", @"how much money the player has"), [formatter stringFromNumber:@([kCash longLongValue])], NSLocalizedString(@"Debt", @"how much the user owes the credit union"), [formatter stringFromNumber:@([kDebt longLongValue])], NSLocalizedString(@"Savings", @"how much the user has saved up"), [formatter stringFromNumber:@([kSavings longLongValue])]];
	
    //Release the formatter
    
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Information", @"The title for the information window")
													message:message
												   delegate:nil
										  cancelButtonTitle:NSLocalizedString(@"Okay", @"")
										  otherButtonTitles:nil];
	[alert show];
}


//
//	Present a UIActionSheet which will allow the 
//	user to choose between achievements and leader
//	boards. Based on the selection, the correct view
//	will be shown. This is handled in the UIActionSheetDelegate
//	methods.
//

- (void) showGameCenterActionSheet: (NSNotification *)notif{
    
	//
	//	If game center is available
	//
	
	if (isGameCenterAvailable()) {
		
		//
		//	If the player is authenticated
		//
		
		if(![GKLocalPlayer localPlayer].isAuthenticated){
            [self authenticateLocalPlayer];
		}
        
        //
        //	Present an action sheet for the game center menu
        //
        
        UIActionSheet *gameCenterActionSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"Game Center", @"Game Center")
                                                                           delegate:self 
                                                                  cancelButtonTitle:NSLocalizedString(@"Cancel", @"offer the user the option to cancel") 
                                                             destructiveButtonTitle:nil
                                                                  otherButtonTitles:kLeaderBoardsButtonTitle, kAchievementsButtonTitle, nil];
        [gameCenterActionSheet showInView:self.mainMenu.view];
        
	}else {
		
		//
		//	Show offline scores
		//
		
		HighScoresViewController *scoresView = [[HighScoresViewController alloc] initWithStyle:UITableViewStyleGrouped];
		UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:scoresView];
		
		[navigationController setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
		
		[self.mainMenu presentViewController:navigationController animated:YES completion:nil];
	}
    
	
}


#pragma mark -
#pragma mark Alert View delegate

- (void) alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if ([alertView.title isEqualToString:@"Long Game?"]) {
        if(buttonIndex != alertView.cancelButtonIndex){
            
            //
            //	Double remaining time
            //
            
            [kSettings setObject:@(kInitialDaysLeft*2) forKey:@"daysLeft"];
            [kSettings setBool:YES forKey:@"doubleLength"];
        }
        
		//
		//	Present the game
		//
		
		[self createGameViewAndShowIt];
        
        
    }else{
        if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:NSLocalizedString(@"Yes", @"Yes")]) {
            
            //
            //	The user has chosen to overwrite the old game, start over
            //
            
            [kSettings setBool:NO forKey:@"inGame"];
            [self newGame:nil];
            
        }
    }
}

#pragma mark -
#pragma mark The game is over

- (void) endGame:(NSNotification *) notif{
    
	//
	//	The game is over, clean up and handle scoring etc...
	//
	
	//
	//	Hide the game view
	//
	
	[self hideGameView];
	
	//
	//	Disable the "in game" flag
	//
	
	[kSettings setBool:NO forKey:@"inGame"];
	
	//
	//	Add the game to the "game count"
	//
	
	[kSettings setObject:@([kNumberOfGamesPlayed integerValue]+1) forKey:@"numberOfGamesPlayed"];
	
	//
	//	Handle Game Center and scoring
	//
    
	int64_t score = [kCash longLongValue] - [kDebt longLongValue] + [kSavings longLongValue];	
	
	//NSLog(@"<MBNotification:> Game Over");
	
	if (score > 0) {
		//[Appirater userDidSignificantEvent:YES];
	}
	
	if (isGameCenterAvailable()){
		
		if(![GKLocalPlayer localPlayer].isAuthenticated){
			
			//
			//	Store the score
			//
			
			[self.tempScores addObject:@(score)];
			
			//
			//	Authenticate the local player
			//
			
			[self authenticateLocalPlayer];
		}
		
		//
		//	Report pogress on the "Master Chef" Achievement
		//
		
		if ([kNumberOfGamesPlayed integerValue] < 5) {
			
			//
			//	Report progress, the user has not completed the achievement yet.
			//
			
			[self reportAchievementIdentifier:kAchievementMasterChef percentComplete: [kNumberOfGamesPlayed floatValue]*20];
			
		}else {
			
			//
			//	Report the complete achievement
			//
			
			[self reportAchievementIdentifier:kAchievementMasterChef percentComplete: 100.0];
		}
		//
		//	Report the "Overstock" Achievement.
		//
		//	Begin by calculating how many items the player is carrying
		//
		
		NSInteger numberOfItemsOnYou = 0;
		
		for(NSNumber *itemInCart in [kCart allValues]){
			numberOfItemsOnYou += [itemInCart integerValue];
		}
		
		if (numberOfItemsOnYou == [kMaxCart integerValue]) {
            
            //
            //	The player has achieved "overstock"
            //
			
			[self reportAchievementIdentifier:kAchievementOverstock percentComplete: 100.0];
		}
		
		if (score < 0) {
            
			//
			//	Report the "Ashamed" Achievement
			//
			
			[self reportAchievementIdentifier:kAchievementShameful percentComplete:100.0];
		}
		
		//
		//	Handle the "Day Trader" achievement
		//
		
		if ([kNumberOfItemsSold integerValue] > kDayTraderThreshold) {
			[self reportAchievementIdentifier:kAchievementDayTrader percentComplete:100.0];
		}else if([kNumberOfItemsSold integerValue] < kReservedThreshold){
			[self reportAchievementIdentifier:kAchievementReserved percentComplete:100.0];
		}
		
		//
		//	Handle scoring...
		//
		
		if(score > 0){
			
			//
			//	If The user is authenticated
			//
			
			if ([GKLocalPlayer localPlayer].isAuthenticated){
                
				//
				//	Report the score to Game Center
				//
                
                if (kCheated == YES) {
                    [self reportScore:score forCategory:kCheaterLeaderboardCategory];
                }else if([kSettings boolForKey:@"doubleLength"] == NO){
                    [self reportScore:score forCategory:kLeaderboardCategory];
                }else{
                    [self reportScore:score forCategory:kDoubleLeaderboardCategory];
                }
                
                NSNumber *scoreAsNumber = @(score); 
                
                
                
                //
                //  Create a formatter to format the code
                //
                
                NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
                [formatter setGroupingSeparator:kFormatterGroupingSeparator];
                [formatter setGroupingSize:3];
                [formatter setAlwaysShowsDecimalSeparator:NO];
                [formatter setUsesGroupingSeparator:kFormatterEnabled];
                
                NSString *formattedNumber = [formatter stringFromNumber:scoreAsNumber];
                
                
                
                //
				//
				//	Inform the user of their score  and that it was reported
				//
                
                
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Game Over:", @"a title informing the user that the game has ended")
																message:[NSString stringWithFormat:@"%@ ¥%@.", NSLocalizedString(@"Congratulations! You earned", @"inform the user how much they've earned"), formattedNumber]
															   delegate:nil
                                                      cancelButtonTitle:NSLocalizedString(@"Okay", @"an okay button")
                                                      otherButtonTitles:nil];
                
				[alert show];
                
				//
				//	Check for the "No Nori" achievement
				//
				
				if ([kNoNori boolValue] == YES) {
					
					[self reportAchievementIdentifier:kAchievementNoNori percentComplete:100.0];
				}
				
				//
				//	Check for the "Allergic" achievement
				//
				
				if ([kIsAllergic boolValue] == YES) {
					
					[self reportAchievementIdentifier:kAchievementAllergic percentComplete:100.0];
				}
                
			}else{
                
                //
                //  Creare a formatter to format the score
                //
                
                NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
                
                [formatter setGroupingSeparator:kFormatterGroupingSeparator];
                [formatter setGroupingSize:3];
                [formatter setAlwaysShowsDecimalSeparator:NO];
                [formatter setUsesGroupingSeparator:kFormatterEnabled];
                
                //
                //  Return the formatted score as a string
                //
                
                NSString *scoreString = [formatter stringFromNumber:@(score)];
                
                //
                //  Release the formatter
                //
                
                
                //
                //  Inform the user that their score will be posted to Game Center in the future
                //
                
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Game Over:", @"a title informing the user that the game has ended")
                                                                message:[NSString stringWithFormat:@"%@ ¥%@. %@", NSLocalizedString(@"Congratulations! You earned", @"inform the user how much they've earned") ,scoreString, NSLocalizedString(@"Your score will be posted to Game Center when you log in.", @"inform the user that thier score will be posted on the next login")]
                                                               delegate:nil
                                                      cancelButtonTitle:NSLocalizedString(@"Okay", @"an okay button")
                                                      otherButtonTitles:nil];
				[alert show];
                
                
                
				//
				//	Store scores for offline use
				//
                
				NSMutableArray *tempArray = [kTempScores mutableCopy];
				
				[tempArray addObject:@(score)];
				
				[kSettings setObject:tempArray forKey:@"tempScores"];
				
				
				//NSLog(@"Temp Scores: %@", [kTempScores description]);
			}
			
			//
			//	Prompt the user to rate
			//
			
			//[Appirater userDidSignificantEvent:YES];
			
		}else if (score == 0){
			
			UIAlertView *alert= [[UIAlertView alloc] initWithTitle:@"Um."
                                                           message:@"Yea, you scored zero. That takes talent. I'm honestly impressed."
                                                          delegate:nil
                                                 cancelButtonTitle:@"I know."
                                                 otherButtonTitles:nil];
			[alert show];
			
            //
            //  Report the achievement
            //
            
            [self reportAchievementIdentifier:kAchievementZero percentComplete:100.0];
		}else{
			
			//
			//	The user did not score more than 0
			//
            
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Game Over:", @"a title informing the user that the game has ended")
                                                            message:[NSString stringWithFormat:@"%@ ¥%lli %@", NSLocalizedString(@"Your business failed. You ended up owing.", @""),  score*-1, NSLocalizedString(@"to the Credit Union.", @"")]
                                                           delegate:nil
                                                  cancelButtonTitle:NSLocalizedString(@"Okay", @"an okay button")
                                                  otherButtonTitles:nil];
			[alert show];
			
		}
		
	}else{
        
		//
		//	Here we are not using game 
		//	center at all, so save to
		//	the offline Leaderboards
		//
        
		if( score > 0){
			
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Game Over:", @"a title informing the user that the game has ended")
                                                            message:[NSString stringWithFormat:@"%@ ¥%lli.", NSLocalizedString(@"Congratulations! You earned", @"inform the user how much they've earned") ,score]
                                                           delegate:nil
                                                  cancelButtonTitle:NSLocalizedString(@"Okay", @"an okay button")
                                                  otherButtonTitles:nil];
			[alert show];
            
			//
			//	Store the score
			//
			
			
			NSMutableArray *tempArray = [kTempScores mutableCopy];
			
			[tempArray addObject:@(score)];
			
			[kSettings setObject:tempArray forKey:@"tempScores"];	
            
			self.tempScores = tempArray;
			
			
			//
			//	Write the changes to the disk
			//
			
			[kSettings synchronize];
			
			//
			//	Prompt the user to rate
			//
			
			//[Appirater userDidSignificantEvent:YES];
			
		}else if(score == 0){
            
			UIAlertView *alert= [[UIAlertView alloc] initWithTitle:@"Um."
                                                           message:@"Yea, you scored zero. That takes talent. I'm honestly impressed."
                                                          delegate:nil
                                                 cancelButtonTitle:@"I know."
                                                 otherButtonTitles:nil];
			[alert show];
			
			
		}else{
            
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Game Over:", @"a title informing the user that the game has ended")
															message:[NSString stringWithFormat:@"%@ ¥%lli %@", NSLocalizedString(@"Your business failed. You ended up owing", @""),  score*-1, NSLocalizedString(@"to the Credit Union.", @"")]
                                                           delegate:nil
                                                  cancelButtonTitle:NSLocalizedString(@"Okay", @"an okay button")
                                                  otherButtonTitles:nil];
			[alert show];
		}
	}		
}

#pragma mark -
#pragma mark Action Sheet delegate

- (void) actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    
	//
	//
	//
	
	if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:kLeaderBoardsButtonTitle]) {
		
		//
		//	Present the Leaderboard
		//
		
		[self showLeaderboard];
		
	}else if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:kAchievementsButtonTitle]) {
		
		//
		//	Present the Achievements
		//
		
		[self showAchievements];
		
	}
}

#pragma mark -
#pragma mark Game Center

BOOL isGameCenterAvailable(){
	// Check for presence of GKLocalPlayer API.
	Class gcClass = (NSClassFromString(@"GKLocalPlayer"));
	
	// The device must be running running iOS 4.1 or later.
	NSString *reqSysVer = @"4.1";
	NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
	BOOL osVersionSupported = ([currSysVer compare:reqSysVer options:NSNumericSearch] != NSOrderedAscending);
	
	return (gcClass && osVersionSupported);
}

//
//	Authenticate for Game Center
//

- (void) authenticateLocalPlayer{
    
    [[GKLocalPlayer localPlayer] setAuthenticateHandler:^(UIViewController *viewController, NSError *error) {
		if (error == nil){
			
            if([kSettings boolForKey:@"hasReminisced"] != YES){
                //
                //	Report the "Reminsce" achievement
                //
                
                [self reportAchievementIdentifier:kAchievementReminisce percentComplete:100.00];
                [kSettings setBool:YES forKey:@"hasReminisced"];
			}
            
			//
			//	Handle cached achievements
			//
			
			for(GKAchievement *achievement in self.tempAchievements){
				
				[self reportAchievementIdentifier:achievement.identifier percentComplete:achievement.percentComplete];
			}
			
			//
			//	Handle cached scores
			//
			
			for(NSNumber *score in self.tempScores){
				
				//
				//	Report each cached score
				//
				
				[self reportScore:[score longLongValue] forCategory:kLeaderboardCategory];
				
				//NSLog(@"<MBGameCenter:> Reporting score: %lli", [score longLongValue]);
			}
			
			
		}else{
			
			// Your application can process the error parameter to report the error to the player.
			
			//NSLog(@"Error logging into Game Center. Error: %@", [error description]);
			
		}
	}];
}

//
//	Register for Game Center Authentication Change Notifications
//

- (void) registerForAuthenticationNotification{
	[kNotificationCenter addObserver: self
                            selector:@selector(authenticationChanged)
                                name:GKPlayerAuthenticationDidChangeNotificationName
                              object:nil];
}

//
//	Handle Game Center Authentication Change Notificaitons
//

- (void) authenticationChanged{
	if ([GKLocalPlayer localPlayer].isAuthenticated){
        
		//NSLog(@"<MBGameCenter:> Player is authenticated.");
		
	}else{
		// Insert code here to clean up any outstanding Game Center-related classes.
		//NSLog(@"<MBGameCenter:> Player logged out.");
		[self authenticateLocalPlayer];
	} 
}

//
//	Report scores to Game Center
//

- (void) reportScore: (int64_t) score forCategory: (NSString*) category{
	GKScore *scoreReporter = [[GKScore alloc] initWithCategory:category];
	scoreReporter.value = score;
	
	[scoreReporter reportScoreWithCompletionHandler:^(NSError *error) {
		if (error != nil){
            if ([[scoreReporter.category description] isEqualToString:kCheaterLeaderboardCategory]) {
                //User cheated, don't store the score.
            }else{
                [self.tempScores addObject:@([scoreReporter value])];
            }
			//NSLog(@"<MBGameCenter:> Error posting score. \n%@", [error description]);
		}else {
			//NSLog(@"<MBGameCenter:> Posted score.");
		}
        
	}];
}

//
//	Show the leaderboard
//

- (void) showLeaderboard{
	GKLeaderboardViewController *leaderboardController = [[GKLeaderboardViewController alloc] init];
	if (leaderboardController != nil){
		leaderboardController.leaderboardDelegate = self.mainMenu;
		[self.mainMenu presentViewController:leaderboardController animated:YES completion:nil];
	}
}

//
//	Show Achievements
//

- (void) showAchievements{
	GKAchievementViewController *achivementController = [[GKAchievementViewController alloc] init];
	if (achivementController != nil){
		achivementController.achievementDelegate = self.mainMenu;
		[self.mainMenu presentViewController:achivementController animated:YES completion:nil];
	}
}

//
//	Load a particular achievement, or create it if does not exist
//

- (GKAchievement*) achievementForIdentifier: (NSString*) identifier{
    GKAchievement *achievement = achievementsDictionary[identifier];
    if (achievement == nil){
        achievement = [[GKAchievement alloc] initWithIdentifier:identifier];
        achievementsDictionary[achievement.identifier] = achievement;
    }
    return achievement;
}

//
//	Load all achievements
//

- (void) loadAchievements{
    [GKAchievement loadAchievementsWithCompletionHandler:^(NSArray *achievements, NSError *error){
        if (error == nil){
            for (GKAchievement* achievement in achievements){
                achievementsDictionary[achievement.identifier] = achievement;
            }
        }
    }];
}

//
//	Report a particular achievement
//

- (void) reportAchievementIdentifier: (NSString*) identifier percentComplete: (float) percent{
    GKAchievement *achievement = [self achievementForIdentifier:identifier];
    
    if (achievement){
        
        if ([achievement respondsToSelector:@selector(showsCompletionBanner)]) {
            achievement.showsCompletionBanner = YES;
        }
        
		achievement.percentComplete = percent;
		[achievement reportAchievementWithCompletionHandler:^(NSError *error){
            if (error != nil){
                
				// NSLog(@"<MBGameCenter:> Could not report Achievement: %@. \n %@", achievement.identifier, [error description]);
                
                //
                //		Retain the achievement object and try again later.
                //
                
                (self.tempAchievements)[achievement.identifier] = achievement;
                
                [kSettings setObject:self.tempAchievements forKey:@"tempAchievements"];
                
                //
                //		Write the new temporary array to disk
                //
                
                [kSettings synchronize];
                
            }else {
				// NSLog(@"<MBGameCenter:> Reported achievement: %@", [achievement identifier]);
                
                if ([achievement percentComplete] == 100.0 && ![[achievement identifier] isEqualToString:kAchievementReminisce]) {
                    
                    NSDictionary *achievementLookup = @{kAchievementReminisce: @"Reminisce",
                                                       kAchievementManifestDestiny: @"Manifest Destiny", 
                                                       kAchievementWellRounded: @"Well Rounded",
                                                       kAchievementMasterChef: @"Master Chef",
                                                       kAchievementOverstock: @"Overstock",
                                                       kAchievementShameful: @"Shameful",
                                                       kAchievementNoNori: @"No Nori",                                        
                                                       kAchievementDayTrader: @"Day Trader",
                                                       kAchievementCornerTheMarket: @"Corner The Market",
                                                       kAchievementFunazushi: @"Funazushi",
                                                       kAchievementFiveO: @"Five-0",
                                                       kAchievementAllergic: @"Allergic",
                                                       kAchievementWealthy: @"Wealthy",
                                                       kAchievementInForOne: @"In For One",
                                                       kAchievementMerlinsBeard: @"Merlin's Beard",
                                                       kAchievementInheritance: @"Inheritance",
                                                       kAchievementReserved: @"Reserved",
                                                       kAchievementZero: @"Zero"};
                    
                    
                    //  iOS 5 adds game center banners
                    //  so we need to check for it here
                    
                    NSString *reqSysVer = @"5.0";
                    
                    NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
                    
                    if ([currSysVer compare:reqSysVer options:NSNumericSearch] != NSOrderedAscending){
                        //On iOS 5, otherwise rely on default message
                    }else{
                        [self presentBannerWithMessage:achievementLookup[[achievement identifier]]];
                    }
                    
                }
            }
            
        }];
    }
}

//
//	Reset the achievements
//

- (void) resetAchievements{
	// Clear all locally saved achievement objects.
    achievementsDictionary = [[NSMutableDictionary alloc] init];
	// Clear all progress saved on Game Center
	[GKAchievement resetAchievementsWithCompletionHandler:^(NSError *error){
		if (error != nil){}
        // handle errors
	}];
}

//
//
//

- (void)alertWasHidden:(NSNotification *)notif{
    if (numberOfVisibleAlerts > 0) {
        numberOfVisibleAlerts = numberOfVisibleAlerts - 1;
    }
    [kNotificationCenter removeObserver:self name:kAlertWasHiddenNotification object:[notif object]];
}

#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


#pragma mark - Show Message In Banner

- (void)presentBannerWithNotification:(NSNotification *)notification{
    [self presentBannerWithMessage:[notification userInfo][@"message"]];
}

//On iOS 5, this method does nothing

- (void)presentBannerWithMessage:(NSString *)message{
    
    //
    // Create the alert banner
    //
    
    MessageBanner *alert = [[MessageBanner alloc] initWithMessage:message];
    
    //
    // Position it offscreen
    //
    
    [alert.view setFrame:CGRectMake((self.window.frame.size.width/2)-(alert.view.frame.size.width/2), -alert.view.frame.size.height, alert.view.frame.size.width, alert.view.frame.size.height)];
    
    //
    // Add self as an observer for this notification
    //
    
    [kNotificationCenter addObserver:self selector:@selector(alertWasHidden:) name:kAlertWasHiddenNotification object:nil];
    
    //
    // Add the banner to the display hierarchy
    //
    
    [self.window addSubview:alert.view];
    
    //
    // Animate it into view
    //
    
    [UIView beginAnimations:@"" context:@""];
    [UIView setAnimationDelay:kBannerAnimationDelay];
    [UIView setAnimationDuration:kBannerSpeed];
    
    [alert.view setFrame:CGRectMake((self.window.frame.size.width/2)-(alert.view.frame.size.width/2), ([[UIApplication sharedApplication] statusBarFrame].size.height+10.0)+(numberOfVisibleAlerts * alert.view.frame.size.height), alert.view.frame.size.width, alert.view.frame.size.height)];
    
    //
    // Increment the number of visible alerts
    //
    
    numberOfVisibleAlerts = numberOfVisibleAlerts + 1;
    
    [UIView commitAnimations];
    
    
}


- (void)configureSpiffy
{
    [[SpiffyController sharedController] setAppStoreIdentifier:@"415518235"];
    [[SpiffyController sharedController] setAppURL:@"https://itunes.apple.com/us/app/nippon/id415518235?ls=1&mt=8"];
    [[SpiffyController sharedController] setWebsiteURL:@"http://mosheberman.com"];
    [[SpiffyController sharedController] setMoreAppsURL:@"http://appstore.com/mosheberman"];
    
    [[SpiffyController sharedController] setSupportEmailAddress:@"yetanotheriphoneapp@gmail.com"];
    [[SpiffyController sharedController] setTwitterHandle:@"bermaniastudios"];
    
    [[SpiffyController sharedController] setAppColor:[UIColor colorWithRed:0.81 green:0.16 blue:0.14 alpha:1.00]];
}

@end
