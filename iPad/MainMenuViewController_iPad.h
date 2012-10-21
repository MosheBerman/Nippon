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


@interface MainMenuViewController_iPad : UIViewController <GKLeaderboardViewControllerDelegate, GKAchievementViewControllerDelegate, MFMailComposeViewControllerDelegate>{
	
	IBOutlet UIButton *newGameButton;
	IBOutlet UIButton *continueGameButton;
	IBOutlet UIButton *howToPlayButton;
	IBOutlet UIButton *gameCenterButton;
    IBOutlet UIButton *continueButton;
    
	IBOutlet UIImageView *landscapeImage;
	IBOutlet UIImageView *portraitImage;
	
	IBOutlet UILabel *versionLabel;
	
}
@property (retain, nonatomic) IBOutlet UIView *buttonWrapperView;

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
//	Handle orientation changes and lay out the buttons
//

- (void) handleChangeToOrientation:(UIInterfaceOrientation)orientation;



@end
