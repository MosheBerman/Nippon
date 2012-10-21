//
//  MainMenuViewController.h
//  Nippon
//
//  Created by Moshe Berman on 1/10/11.
//  Copyright 2011 MosheBerman.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GameKit/GameKit.h>
#import <MessageUI/MessageUI.h>

#import "FinancialViewController.h"

@interface MainMenuViewController : UIViewController <GKLeaderboardViewControllerDelegate, GKAchievementViewControllerDelegate, MFMailComposeViewControllerDelegate>{
    
	IBOutlet UILabel *versionLabel;
	IBOutlet UIButton *highScoresButton;
    IBOutlet UIButton *continueButton;
    
    int devModeCount;
     
}



//
//	Dispatch a "New Game" notification to any Observers
//

- (IBAction) dispatchNewGameNotification;

//
//	Dispatch a "Resume Game" notification to any Observers
//

- (IBAction) dispatchResumeGameNotification;

//
//	Dispatch a "show Instructions" notification to any Observers
//

- (IBAction) dispatchShowInstructionsNotification;

//
//	Dispatch a "Game Center" notification to any Observers
//

- (IBAction) dispatchGameCenterNotification;

//
//	Check if game center is available
//

BOOL isGameCenterAvailable();

//
//  Check if developer mode is activated when a secret button is pressed
//

- (IBAction)checkForDevMode:(id)sender;

//
//  Release developer mode, if it's not activated
//

- (IBAction)releaseDevMode:(id)sender;

//
//  Show an email form
//

- (IBAction)contactTheDev:(id)sender;

@end
