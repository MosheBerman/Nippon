//
//  NipponAppDelegate.h
//  
//
//  Created by Moshe Berman on 1/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MainMenuViewController.h"
#import "MainMenuViewController_iPad.h"

#import "TravelViewController.h"
#import "TravelViewControllerPad.h"

#import "HighScoresViewController.h"

#import "HowToPlayViewController.h"
#import "Instructions.h"

#import "MessageBanner.h"
#import "Appirater.h"

#import <GameKit/GameKit.h>


@interface NipponAppDelegate : NSObject<UIApplicationDelegate, UIAlertViewDelegate, UIActionSheetDelegate> {
    
    UIWindow *window;
	UIViewController *mainMenu;
	BOOL *gameInProgress;
	
	//
	//	temporary Achievements Dictionary
	//
    
	NSMutableDictionary *tempAchievements;
	
	//
	//	temporary Leaderboards array
	//
    
	NSMutableArray *tempScores;
    
    //
    //  Keep track of the number of alerts
    //
    
    int numberOfVisibleAlerts;
	
}


@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) UIViewController *mainMenu;

@property (nonatomic, retain) NSMutableDictionary *tempAchievements;
@property (nonatomic, retain) NSMutableArray *tempScores;

@property(nonatomic, retain) NSMutableDictionary *achievementsDictionary;


//
//	Reset the preferences to the defaults
//

- (void) resetPreferences;

//
//	Report the easter egg achievement to Game Center
//

- (void) reportEasterEgg:(NSNotification *)notif;

//
//	Create and show the Main Game View
//

- (void) newGame:(NSNotification *) notif;

//
//	Resume the game if possible
//

- (void) resumeGame:(NSNotification *) notif;

//
//	Configure and present the game UI
//

- (void) createGameViewAndShowIt;

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
//	Hide the instructions view
//

- (void) hideInstructions;

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
//	Determine if Game Center is available
//

BOOL isGameCenterAvailable();

//
//	Authenticate for Game Center
//

- (void) authenticateLocalPlayer;

//
//	Report the score to game center
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

//
//	Load a particular achievement, or create it if does not exist
//

- (GKAchievement*) achievementForIdentifier: (NSString*) identifier;

//
//	Report a particular achievement
//

- (void) reportAchievementIdentifier: (NSString*) identifier percentComplete: (float) percent;

//
//	Reset all achievements
//

- (void) resetAchievements;

//
//	Handle a Funazushi event
//

- (void) handleFunazushiNotification:(NSNotification *)notif;

//
//	Handle Purchase Notification
//

- (void) handlePurchaseNotification:(NSNotification *)notif;

//
//	Handle Well Rounded Notification
//

- (void) handlePlayerIsWellRounded:(NSNotification *)notif;

//
//	Handle Player Is In For One Notification
//

- (void) handlePlayerIsInForOne:(NSNotification *)notif;

//
//	Handle Player Has Sushizushi Notification
//

- (void) handlePlayerHasSushizushi:(NSNotification *)notif;

//
//  Present a banner from a notification
//

- (void)presentBannerWithNotification:(NSNotification *)notification;

//
//  Present a banner containing a given message
//

- (void)presentBannerWithMessage:(NSString *)message;

//
//  Invoked when a message is hidden, to keep track of visible message count
//

- (void)alertWasHidden:(NSNotification *)notif;

@end

