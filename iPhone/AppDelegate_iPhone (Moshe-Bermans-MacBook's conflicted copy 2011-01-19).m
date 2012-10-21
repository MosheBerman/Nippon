//
//  AppDelegate_iPhone.m
//  Nippon
//
//  Created by Moshe Berman on 1/9/11.
//  Copyright 2011 MosheBerman.com. All rights reserved.
//

#import "AppDelegate_iPhone.h"

@implementation AppDelegate_iPhone

@synthesize window, mainMenu, tempScores, tempAchievements;


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
	//	Authenticate the player
	//
	
	if(isGameCenterAvailable()) {
		[self registerForAuthenticationNotification];
		[self authenticateLocalPlayer];
	}else {
		
		//
		//	Inform the user that Game Center is unsupported
		//
		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Game Center Unsupported:"
														message:@"Game Center is not supported on your device. Leaderboards and Achievements are not available." 
													   delegate:nil
											  cancelButtonTitle:@"Okay"
											  otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
	

    
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
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
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
	
}

#pragma mark -
#pragma mark  Reset the game defaults

- (void) resetPreferences{
	
	//
	//	The number of days left:
	//
	
	[kSettings setObject:[NSNumber numberWithInt:kInitialDaysLeft] forKey:@"daysLeft"];
	
	//
	//	The number of items your "coat" can hold:
	//
	
	[kSettings setObject:[NSNumber numberWithInt:kInitialCoat] forKey:@"maxCoat"];
	
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
	//	Initialize your coat
	//
	
	NSMutableDictionary *tempCoat = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInteger:0], @"Nagiri",
									 [NSNumber numberWithInteger:0], @"Maki",
									 [NSNumber numberWithInteger:0], @"Oshi",
									 [NSNumber numberWithInteger:0], @"Inari",
									 [NSNumber numberWithInteger:0], @"Sashimi",
									 [NSNumber numberWithInteger:0], @"Chirashi", 
									 [NSNumber numberWithInteger:0], @"Nare",
									 [NSNumber numberWithInteger:0], @"Sushizushi", nil];
	[kSettings setObject:tempCoat forKey:@"coat"];
	[tempCoat release];
	
}

#pragma mark -
#pragma mark Button Methods

//
//	Create and show the Main Game View
//

- (void) newGame:(NSNotification *)notif{
	
	if(kInGame == YES){
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Start New?"
															message:@"You have a game in progress. Starting a new game will cause the old game to be lost. Do you really want to start over?" 
														   delegate:self cancelButtonTitle:@"No" otherButtonTitles:nil];
		[alert addButtonWithTitle:@"Yes"];
		[alert show];
		[alert release];
		
	}else{
		//
		//	Reset the preferences
		//
		
		[self resetPreferences];
		
		
		//
		//	Create the necessary views
		//
		
		TravelViewController *travelView = [[TravelViewController alloc] initWithStyle:UITableViewStylePlain];
		UINavigationController *game = [[UINavigationController alloc] initWithRootViewController:travelView];
		
		//
		//	Resize the rows
		//
		
		[travelView.tableView setRowHeight:kTravelRowHeight];
		
		//
		//	Set the tint color of navigation bar
		//
		
		[game.navigationBar setTintColor:[UIColor darkGrayColor]];
		
		//
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
		
		//
		//	Create the necessary views
		//
	
		TravelViewController *travelView = [[TravelViewController alloc] initWithStyle:UITableViewStylePlain];
		UINavigationController *game = [[UINavigationController alloc] initWithRootViewController:travelView];
	
		//
		//	Resize the rows
		//
		
		[travelView.tableView setRowHeight:kTravelRowHeight];
	
		//	
		//	Set the tint color of navigation bar
		//
		
		[game.navigationBar setTintColor:[UIColor darkGrayColor]];
	
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
		
	}else{
		
		//
		//	Alert the user that they need to start a game
		//
		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning"
														message:@"You have no game to continue."
													   delegate:nil
											  cancelButtonTitle:@"Close"
											  otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
	
}


/*
-(IBAction)showCredits:(id)sender{
	
	Credits *cr = [[Credits alloc] initWithNibName:@"Credits" bundle:nil];
	
	[cr.view setFrame:CGRectMake(0, 0, (self.view.frame.size.width), (self.view.frame.size.height))];
	
	self.creditsView = cr;
	
	[self.view addSubview:creditsView.view];
	[self attachPopUpAnimation];
	[cr release];
	
}
*/

//
//	Create and show the instructions view
//

- (void) showInstructions:(NSNotification *)notif{
	
	//
	//	TODO: Load the instructions view
	//
	
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
	//	Create and present a UIActionSheet with the appropriate options
	//	TODO: Finish the conditional logic here
	//
	
	UIActionSheet *gameCenterActionSheet = [[UIActionSheet alloc] initWithTitle:@"Game Center"
																	   delegate:self
															  cancelButtonTitle:@"Cancel"
														 destructiveButtonTitle:nil
															  otherButtonTitles:@"Leaderboards", @"Achievements", nil];
	[gameCenterActionSheet showInView:self.mainMenu.view];
	[gameCenterActionSheet release];
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
	
	NSArray *vals = [kCoat allValues];
	NSInteger numberOfItems = 0.0;
	for(id val in vals){ 
		if([val isKindOfClass:[NSNumber class]]){
			numberOfItems += [val integerValue];
		}
	}
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Information"
													message:[NSString stringWithFormat: @"Days Left: %@\nCoat: %li/%@\nCash: ¥%@\nDebt: ¥%@\nSavings: ¥%@",kDaysLeft, numberOfItems, kMaxCoat, kCash, kDebt, kSavings]
												   delegate:nil
										  cancelButtonTitle:@"OK"
										  otherButtonTitles:nil];
	
	[alert show];
	[alert release];
}

#pragma mark -
#pragma mark Alert View delegate

- (void) alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{

	if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Yes"]) {
		[kSettings setBool:NO forKey:@"inGame"];
		[self newGame:nil];
	}

	
}

#pragma mark -
#pragma mark Action Sheet delegate

- (void) actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
	
	//
	//	Depending on the user's selection show the proper Game Center content
	//
	
	if([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Leaderboards"]){
		
		//
		//	Check for game center compatibility and authentication
		//
		
		if (isGameCenterAvailable()) {
			if([GKLocalPlayer localPlayer].isAuthenticated) {
				[self showLeaderboard];
			}else{
				[self authenticateLocalPlayer];
			}
		}
		
	}else if([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Achievements"]){
		
		if (isGameCenterAvailable()) {
			if([GKLocalPlayer localPlayer].isAuthenticated) {
				[self showAchievements];
			}else{
				[self authenticateLocalPlayer];
			}
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
	// Handle Game Center and scoring
	//

	if(isGameCenterAvailable()){
		if (![GKLocalPlayer localPlayer].isAuthenticated) {
			[self authenticateLocalPlayer];
		}
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
			
			// Insert code here to handle a successful authentication.
			
			//
			//	TODO: Send cached scores and achievements
			//
			
		}else{
			
			//
			//	Inform the user that Game Center could not be accessed.
			//
			
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Couldn't Log In:" 
															message:@"Could not log into Game Center. Some features may be unavailable."
														   delegate:nil
												  cancelButtonTitle:@"Okay"
												  otherButtonTitles:nil];
			[alert show];
			[alert release];
			
		}
	}];
}

//
//	Register for Game Center Authentication Change Notifications
//

- (void) registerForAuthenticationNotification{
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc addObserver: self
				 selector:@selector(authenticationChanged)
						 name:GKPlayerAuthenticationDidChangeNotificationName
					 object:nil];
}

//
//	Handle Game Center Authentication Change Notificaitons
//

- (void) authenticationChanged{
	if ([GKLocalPlayer localPlayer].isAuthenticated){
		
		//
		// Insert code here to handle a successful authentication.
		//
		
		//
		//	TODO: Send cached scores and achievements to Game Center
		//
		
	}else{
		
		//
		// Insert code here to clean up any outstanding Game Center-related classes.
		//	
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
			// handle the reporting error
			
			//
			//	TODO: Cache the score object
			//
			
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
		[self.mainMenu presentModalViewController: leaderboardController animated: YES];
	}
}

//
//	Show Achievements
//

- (void) showAchievements{
    GKAchievementViewController *achievements = [[GKAchievementViewController alloc] init];
    if (achievements != nil){
        achievements.achievementDelegate = self.mainMenu;
        [self.mainMenu presentModalViewController: achievements animated: YES];
    }
    [achievements release];
}

#pragma mark -

#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
	[tempScores release];
	[tempAchievements release];
	[mainMenu release];
    [window release];
    [super dealloc];
}


@end
