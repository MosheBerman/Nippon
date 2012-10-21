//
//  AppDelegate_iPhone.h
//  Nippon
//
//  Created by Moshe Berman on 1/9/11.
//  Copyright 2011 MosheBerman.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainMenuViewController.h"
#import "TravelViewController.h"
#import <GameKit/GameKit.h>

@interface AppDelegate_iPhone : NSObject <UIApplicationDelegate, UIAlertViewDelegate, UIActionSheetDelegate> {
    UIWindow *window;
	MainMenuViewController *mainMenu;
	BOOL *gameInProgress;
	
	//
	//Temporary arrays for the Game Center caches
	//
	
	NSMutableArray *tempScores;
	NSMutableArray *tempAchievements;
}



@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) MainMenuViewController *mainMenu;

@property (nonatomic, retain) NSMutableArray *tempScores;
@property (nonatomic, retain) NSMutableArray *tempAchievements;

//
//Reset the preferences to the defaults
//

- (void) resetPreferences;

//
//	Create and show the Main Game View
//

- (void) newGame:(NSNotification *) notif;

//
//	Resume the game if possible
//

- (void) resumeGame:(NSNotification *) notif;

//
//	Create and show the instructions view
//

- (void) showInstructions:(NSNotification *) notif;

//
//	Present a UIActionSheet which will allow the 
//	user to choose between achievements and leader
//	boards. Based on the selection, the correct view
//	will be shown. This is handled in the UIActionSheetDelegate
//	methods.
//

- (void) showGameCenterActionSheet: (NSNotification *) notif;


//
//	Hide the game view
//

- (void) hideGameView;

//
//	Show the info alert
//

- (void) showInGameInfo;

//
//	Handle the end of the game
//

- (void) endGame:(NSNotification *) notif;

//
//	Does the device support Game center?
//

BOOL isGameCenterAvailable();

//
//	Authenticate for Game Center
//

- (void) authenticateLocalPlayer;
//
//	Register for Game Center Authentication Change Notifications
//

- (void) registerForAuthenticationNotification;

//
//	Handle Game Center Authentication Change Notificaitons
//

- (void) authenticationChanged;

//
//	Report scores to Game Center
//

- (void) reportScore: (int64_t) score forCategory: (NSString*) category;

//
//	Show the leaderboard
//

- (void) showLeaderboard;

//
//	Show Achievements
//

- (void) showAchievements;

@end

