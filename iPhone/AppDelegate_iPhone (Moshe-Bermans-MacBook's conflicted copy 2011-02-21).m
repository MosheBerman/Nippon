//
//  AppDelegate_iPhone.m
//  Nippon
//
//  Created by Moshe Berman on 1/9/11.
//  Copyright 2011 MosheBerman.com. All rights reserved.
//

#import "AppDelegate_iPhone.h"
#import "HighScoresViewController.h"
#import "HowToPlayViewController.h"

//
// Localize this file
//

@implementation AppDelegate_iPhone

@synthesize window, mainMenu, tempAchievements, tempScores, achievementsDictionary;


#pragma mark -
#pragma mark Application lifecycle

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
		[kSettings setObject:[NSNumber numberWithInteger:0] forKey:@"numberOfGamesPlayed"];
	}
	
	//
	//	Initialize the "Items Bought" count object
	//
	
	if (kNumberOfItemsBought == nil) {
		[kSettings setObject:[NSNumber numberWithInteger:0] forKey:@"numberOfItemsBought"];
	}
	
	//
	//	Initialize the "Items Sold" object
	//
	
	if (kNumberOfItemsSold == nil) {
		[kSettings setObject:[NSNumber numberWithInteger:0] forKey:@"numberOfItemsSold"];
	}
	
	//
	//	Initialize the "Funazushi" count object
	//

	if (kNumberOfTimesFunazushi == nil) {
		[kSettings setObject:[NSNumber numberWithInteger:0] forKey:@"numberOfTimesFunazushi"];		
	}
	
	//
	//
	//
	
	if (kTempScores == nil) {
		[kSettings setObject:[[[NSMutableArray alloc] init] autorelease] forKey:@"tempScores"];
	}
	
	//
	//	Start listening for a game related notifications
	//
	
	[kNotificationCenter addObserver:self selector:@selector(newGame:) name:kStartNewGameNotification object:nil];
	[kNotificationCenter addObserver:self selector:@selector(resumeGame:) name:kResumeGameNotification object:nil];
	[kNotificationCenter addObserver:self selector:@selector(showInstructions:) name:kShowInstructionsNotification object:nil];
	[kNotificationCenter addObserver:self selector:@selector(showGameCenterActionSheet:) name:kShowGameCenterNotification object:nil];
	[kNotificationCenter addObserver:self selector:@selector(endGame:) name:kGameOverNotification object:nil];
	
    
	//
	//	Create and show the main menu
	//
	
	MainMenuViewController *menuView = [[MainMenuViewController alloc] initWithNibName:@"MainMenuViewController" bundle:nil];
	[self setMainMenu:menuView];
	[menuView release];
	
	[self.window addSubview:menuView.view];

	//
	//	Show the main Window
	//
	
    [self.window makeKeyAndVisible];
	
	//
	//	Store the temporary scores
	//
	
	self.tempScores = [[kTempScores mutableCopy] autorelease];
	
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
		
		achievementsDictionary = [[tempAchievements mutableCopy] autorelease];
		
		//
		//	Register for the Achievement related notifications
		//
		
		[kNotificationCenter addObserver:self selector:@selector(reportEasterEgg:) name:kEasterEggNotification object:nil];
		[kNotificationCenter addObserver:self selector:@selector(handleFunazushiNotification:) name:kFunazushiOccurredNotification object:nil];
		[kNotificationCenter addObserver:self selector:@selector(handlePurchaseNotification:) name:kPurchaseOccurredNotification object:nil];
		[kNotificationCenter addObserver:self selector:@selector(handlePlayerIsWellRounded:) name:kPlayerIsWellRoundedNotification object:nil];		
		[kNotificationCenter addObserver:self selector:@selector(handlePlayerIsInForOne:) name:kPlayerIsInForOneNotification object:nil];		
		[kNotificationCenter addObserver:self selector:@selector(handlePlayerHasSushizushi:) name:kPlayerHasSushizushiNotification object:nil];				
		
	}
	
 	[Appirater applicationDidFinishLaunching:YES];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
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
	
	[Appirater applicationDidEnterForeground:YES];

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
	
	[self.tempAchievements release];
	
	//
	//	Store and Release the temporary scores
	//
	
	[kSettings setObject:self.tempScores forKey:@"tempScores"];
	
	[self.tempScores release];
}

#pragma mark -
#pragma mark  Misc

- (void) resetPreferences{
	
	//
	//	The number of days left:
	//
	
	[kSettings setObject:[NSNumber numberWithInt:kInitialDaysLeft] forKey:@"daysLeft"];
	
	//
	//	The number of items your "cart" can hold:
	//
	
	[kSettings setObject:[NSNumber numberWithInt:kInitialCart] forKey:@"maxCart"];
	
	//
	//	How much cash you start with:
	//
	
	[kSettings setObject:[NSNumber numberWithInt:kInitialCash] forKey:@"cash"];

	//
	//	How much debt you start with:
	//
	
	[kSettings setObject:[NSNumber numberWithInt:kInitialDebt] forKey:@"debt"];
	
	//
	//	How much savings you start with:
	//
	
	[kSettings setObject:[NSNumber numberWithInt:kInitialSavings] forKey:@"savings"];
	
	//
	//	Clear the last location
	//
	
	[kSettings setObject:@"nowhere" forKey:@"lastLocation"];
	
	//
	//	Initialize your cart
	//
	
	NSMutableDictionary *tempCart = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
									 [NSNumber numberWithInteger:0], kItemsNagiri,
									 [NSNumber numberWithInteger:0], kItemsMaki,
									 [NSNumber numberWithInteger:0], kItemsOshi,
									 [NSNumber numberWithInteger:0], kItemsInari,
									 [NSNumber numberWithInteger:0], kItemsSashimi,
									 [NSNumber numberWithInteger:0], kItemsChirashi, 
									 [NSNumber numberWithInteger:0], kItemsNare,
									 [NSNumber numberWithInteger:0], kItemsSushizushi, nil];
	[kSettings setObject:tempCart forKey:@"cart"];
	[tempCart release];
	
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
	
	[kSettings setObject:[NSNumber numberWithInteger:0] forKey:@"numberOfItemsSold"];
	
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
		[alert release];
		
	}else{
		
		//
		//	Reset the preferences
		//
		
		[self resetPreferences];
		
		//
		//
		//
		
		[self createGameViewAndShowIt];
		
		//
		//	Enable the "in game" flag
		//
		
		[kSettings setBool:YES forKey:@"inGame"];
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
		[alert release];
	}
	
}

- (void) createGameViewAndShowIt{
	
	//
	//	Create the necessary views
	//
	
	TravelViewController *travelView = [[TravelViewController alloc] initWithStyle:UITableViewStylePlain];
	UINavigationController *game = [[UINavigationController alloc] initWithRootViewController:travelView];
	
	//
	//	Resize the rows
	//
	
	[travelView.tableView setRowHeight:kRowHeight];
	
	//	
	//	Set the tint color of navigation bar
	//
	
	[game.navigationBar setTintColor:[UIColor darkGrayColor]];
	
	//
	//	Set the tint color of the toolbar
	//
	
	[game.toolbar setTintColor:[UIColor darkGrayColor]];
	
	//
	//	Make the bar transluscent
	//
	
	[game.toolbar setTranslucent:YES];
	
	//
	//	Release the travel view
	//
	
	[travelView release];
	
	//	
	//	Present the game view
	//
	
	[self.mainMenu presentModalViewController:game animated:YES];
	
	//
	//	release the game view
	//
	
	[game release];	
	
}

//
//	Create and show the instructions view
//

- (void) showInstructions:(NSNotification *)notif{
	
	//
	//	Show the instructions view
	//
	
	HowToPlayViewController *instructions = [[HowToPlayViewController alloc] initWithNibName:@"HowToPlayViewController" bundle:nil];
	UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:instructions];
	
	[instructions release];
	
	[self.mainMenu presentModalViewController:navigationController animated:YES];
	
	[navigationController release];
	
}

//
//	Hide the instructions view
//

- (void) hideInstructions{
	[self.mainMenu dismissModalViewControllerAnimated:YES];
}

//
//	Hide the game view
//

- (void) hideGameView{
	[mainMenu dismissModalViewControllerAnimated:YES];
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
	
	NSString *message = [NSString stringWithFormat: @"%@: %@\n%@: %li/%@\n%@: ¥%@\n%@: ¥%@\n%@: ¥%@", NSLocalizedString(@"Days Left", @"how much time remains") ,kDaysLeft, NSLocalizedString(@"Cart", @"how many items the user has and how many they can carry at once"), numberOfItems, kMaxCart, NSLocalizedString(@"Cash", @"how much money the player has"), kCash, NSLocalizedString(@"Debt", @"how much the user owes the credit union"), kDebt, NSLocalizedString(@"Savings", @"how much the user has saved up"), kSavings];
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Information", @"The title for the information window")
													message:message
												   delegate:nil
										  cancelButtonTitle:NSLocalizedString(@"Okay", @"")
										  otherButtonTitles:nil];
	[alert show];
	[alert release];
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
			[gameCenterActionSheet release];

	}else {
		
		//
		//	Show offline scores
		//
		
		HighScoresViewController *scoresView = [[HighScoresViewController alloc] initWithStyle:UITableViewStyleGrouped];
		UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:scoresView];
		[scoresView release];
		
		[navigationController setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
		
		[self.mainMenu presentModalViewController:navigationController animated:YES];
		[navigationController release];
	}

	
}


#pragma mark -
#pragma mark Alert View delegate

- (void) alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{

	if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:NSLocalizedString(@"Yes", @"Yes")]) {
		
		//
		//	The user has chosen to overwrite the old game, start over
		//
		
		[kSettings setBool:NO forKey:@"inGame"];
		[self newGame:nil];
		
	}else if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:NSLocalizedString(@"Visit the Bank", @"")]) {
		
		//
		//	The user has chosen to visit the bank
		//
		
		[kNotificationCenter postNotificationName:kShowBankNotification object:nil];
		
	}else if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:NSLocalizedString(@"Visit the Credit Union", @"")]){
		
		//
		//	The user has chosen to visit the Credit Union
		//
		
		[kNotificationCenter postNotificationName:kShowCreditUnionNotification object:nil];
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
	
	[kSettings setObject:[NSNumber numberWithInteger:[kNumberOfGamesPlayed integerValue]+1] forKey:@"numberOfGamesPlayed"];
	
	//
	//	Handle Game Center and scoring
	//
		NSInteger score = [kCash integerValue] +  [kSavings integerValue] - [kDebt integerValue];	
	
	//NSLog(@"<MBNotification:> Game Over");
	
	if (isGameCenterAvailable()){
		
		if(![GKLocalPlayer localPlayer].isAuthenticated){
			
			//
			//	Store the score
			//
			
			[self.tempScores addObject:[NSNumber numberWithInteger:score]];
			
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
				[self reportScore:[[NSNumber numberWithInteger:score]longLongValue] forCategory:kLeaderboardCategory];
			
				//
				//	Inform the user of their score  and that it was reported
				//
			

				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Game Over:", @"a title informing the user that the game has ended")
																message:[NSString stringWithFormat:@"%@ ¥%li. %@", NSLocalizedString(@"Congratulations! You earned", @"inform the user how much they've earned"), score, NSLocalizedString(@"Your score was posted to Game center.", @"inform the user that their score was sent")]
															   delegate:nil
														  cancelButtonTitle:NSLocalizedString(@"Okay", @"an okay button")
														  otherButtonTitles:nil];
				[alert show];
				[alert release];
				
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
			
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Game Over:", @"a title informing the user that the game has ended")
														message:[NSString stringWithFormat:@"%@ ¥%li. %@", NSLocalizedString(@"Congratulations! You earned", @"inform the user how much they've earned") ,score, NSLocalizedString(@"Your score will be posted to Game Center when you log in.", @"inform the user that thier score will be posted on the next login")]
														delegate:nil
													cancelButtonTitle:NSLocalizedString(@"Okay", @"an okay button")
													otherButtonTitles:nil];
				[alert show];
				[alert release];
			
				//
				//	Store scores for offline use
				//
			
				NSMutableArray *tempArray = [kTempScores mutableCopy];
				
				[tempArray addObject:[NSNumber numberWithInteger:score]];
				
				[kSettings setObject:tempArray forKey:@"tempScores"];
				
				[tempArray release];
				
				//NSLog(@"Temp Scores: %@", [kTempScores description]);
			}
		}else {
			
			//
			//	The user did not score more than 0
			//
		
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Game Over:", @"a title informing the user that the game has ended")
														message:[NSString stringWithFormat:@"%@ ¥%li %@", NSLocalizedString(@"Your business failed. You ended up owing.", @""),  score*-1, NSLocalizedString(@"to the Credit Union.", @"")]
														delegate:nil
												cancelButtonTitle:NSLocalizedString(@"Okay", @"an okay button")
												otherButtonTitles:nil];
			[alert show];
			[alert release];
			
		}
		
	}else{
	
		//
		//	Here we are not using game 
		//	center at all, so save to
		//	the offline Leaderboards
		//
	
		if( score > 0){
			
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Game Over:", @"a title informing the user that the game has ended")
														message:[NSString stringWithFormat:@"%@ ¥%li.", NSLocalizedString(@"Congratulations! You earned", @"inform the user how much they've earned") ,score]
														delegate:nil
												cancelButtonTitle:NSLocalizedString(@"Okay", @"an okay button")
												otherButtonTitles:nil];
			[alert show];
			[alert release];
		
			//
			//	Store the score
			//
			
			
			NSMutableArray *tempArray = [kTempScores mutableCopy];
			
			[tempArray addObject:[NSNumber numberWithInteger:score]];
			
			[kSettings setObject:tempArray forKey:@"tempScores"];	
		
			self.tempScores = tempArray;
			
			[tempArray release];
			
			//
			//	Write the changes to the disk
			//
			
			[kSettings synchronize];
			
		}else{
		
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Game Over:", @"a title informing the user that the game has ended")
															message:[NSString stringWithFormat:@"%@ ¥%li %@", NSLocalizedString(@"Your business failed. You ended up owing", @""),  score*-1, NSLocalizedString(@"to the Credit Union.", @"")]
														delegate:nil
												cancelButtonTitle:NSLocalizedString(@"Okay", @"an okay button")
												otherButtonTitles:nil];
			[alert show];
			[alert release];
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
	[[GKLocalPlayer localPlayer] authenticateWithCompletionHandler:^(NSError *error) {
		if (error == nil){
			
			//
			//	Report the "Reminsce" achievement
			//
			
			[self reportAchievementIdentifier:kAchievementReminisce percentComplete:100.00];
			
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
				
				//NSLog(@"<MBGameCenter:> Reporting score: %i", [score integerValue]);
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
	GKScore *scoreReporter = [[[GKScore alloc] initWithCategory:category] autorelease];
	scoreReporter.value = score;
	
	[scoreReporter reportScoreWithCompletionHandler:^(NSError *error) {
		if (error != nil){
			[self.tempScores addObject:[NSNumber numberWithLongLong:[scoreReporter value]]];
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
	GKLeaderboardViewController *leaderboardController = [[[GKLeaderboardViewController alloc] init] autorelease];
	if (leaderboardController != nil){
		leaderboardController.leaderboardDelegate = self.mainMenu;
		[self.mainMenu presentModalViewController:leaderboardController animated: YES];
	}
}

//
//	Show Achievements
//

- (void) showAchievements{
	GKAchievementViewController *achivementController = [[[GKAchievementViewController alloc] init] autorelease];
	if (achivementController != nil){
		achivementController.achievementDelegate = self.mainMenu;
		[self.mainMenu presentModalViewController:achivementController animated: YES];
	}
}

//
//	Load a particular achievement, or create it if does not exist
//

- (GKAchievement*) getAchievementForIdentifier: (NSString*) identifier{
    GKAchievement *achievement = [achievementsDictionary objectForKey:identifier];
    if (achievement == nil){
        achievement = [[[GKAchievement alloc] initWithIdentifier:identifier] autorelease];
        [achievementsDictionary setObject:achievement forKey:achievement.identifier];
    }
    return [[achievement retain] autorelease];
}

//
//	Load all achievements
//

- (void) loadAchievements{
    [GKAchievement loadAchievementsWithCompletionHandler:^(NSArray *achievements, NSError *error){
		 if (error == nil){
			 for (GKAchievement* achievement in achievements){
				 [achievementsDictionary setObject: achievement forKey: achievement.identifier];
			 }
		 }
	 }];
}

//
//	Report a particular achievement
//

- (void) reportAchievementIdentifier: (NSString*) identifier percentComplete: (float) percent{
    GKAchievement *achievement = [self getAchievementForIdentifier:identifier];
    if (achievement){
		achievement.percentComplete = percent;
		[achievement reportAchievementWithCompletionHandler:^(NSError *error){
			 if (error != nil){
				 
				// NSLog(@"<MBGameCenter:> Could not report Achievement: %@. \n %@", achievement.identifier, [error description]);
				 
				 //
				 //		Retain the achievement object and try again later.
				 //
				 
				 [self.tempAchievements setObject:achievement forKey:achievement.identifier];
				 
				 [kSettings setObject:self.tempAchievements forKey:@"tempAchievements"];
				 
				 //
				 //		Write the new temporary array to disk
				 //
				 
				 [kSettings synchronize];
				 
			 }else {
				// NSLog(@"<MBGameCenter:> Reported achievement: %@", [achievement identifier]);
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
	 
	 
#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
	[tempAchievements release];
	[tempScores release];
	[mainMenu release];
	[window release];
	[super dealloc];
}


@end
