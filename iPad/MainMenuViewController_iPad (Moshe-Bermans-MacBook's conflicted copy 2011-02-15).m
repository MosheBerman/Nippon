//
//  MainMenuViewController.m
//  Nippon
//
//  Created by Moshe Berman on 1/10/11.
//  Copyright 2011 MosheBerman.com. All rights reserved.
//

#import "MainMenuViewController_iPad.h"
#import "AppDelegate_iPad.h"

@implementation MainMenuViewController_iPad

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


 // Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	[super viewDidLoad];	
	
	//
	//	Set the version label
	//
	
	[versionLabel setText:[NSString stringWithFormat:@"%@%@",NSLocalizedString(@"v", @"an abbreviation for the word 'version'") ,[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]]];

	//
	//	Handle Orientation Change
	//
	
	[self handleChangeToOrientation:[[UIDevice currentDevice] orientation]];
	
	//
	//
	//
	
	if(isGameCenterAvailable()){
		
		//
		//	Game Center is available
		//
		
		[gameCenterButton setTitle:NSLocalizedString(@"Game Center", @"") forState:UIControlStateNormal];
		
	}else{
		
		//
		//	Game Center is NOT available
		//
		
		[gameCenterButton setTitle:NSLocalizedString(@"High Scores", @"") forState:UIControlStateNormal];
	}
}



#pragma mark -
#pragma mark Orentation

- (void) willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{

	//
	//
	//
	
	[self handleChangeToOrientation:toInterfaceOrientation];
}


- (void) handleChangeToOrientation:(UIDeviceOrientation)orientation{
	
	//
	//
	//
	
	if(UIInterfaceOrientationIsLandscape(orientation)){
		
		[UIView beginAnimations:@"" context:nil];
		[landscapeImage setHidden:NO];
		[portraitImage setHidden:YES];
		[newGameButton setFrame:kRectsButtonNewGameLansdcape];
		[continueGameButton setFrame:kRectsButtonContinueGameLandscape];
		[howToPlayButton setFrame:kRectsButtonHowToPlayLandscape];
		[gameCenterButton setFrame:kRectsButtonGameCenterLandscape];
		[versionLabel setFrame:kRectsLabelVersionLandscape];
		[UIView commitAnimations];
		
	}else if(UIInterfaceOrientationIsPortrait(orientation)){
		
		[UIView beginAnimations:@"" context:nil];
		[landscapeImage setHidden:YES];
		[portraitImage setHidden:NO];
		[newGameButton setFrame:kRectsButtonNewGamePortrait];
		[continueGameButton setFrame:kRectsButtonContinueGamePortrait];
		[howToPlayButton setFrame:kRectsButtonHowToPlayPortrait];
		[gameCenterButton setFrame:kRectsButtonGameCenterPortrait];
		[versionLabel setFrame:kRectsLabelVersionPortrait];	
		[UIView commitAnimations];
		
	}
	
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}


#pragma mark -

//
//	Dispatch a "New Game" notification to any Observers
//

- (IBAction) dispatchNewGameNotification{
	[kNotificationCenter postNotificationName:kStartNewGameNotification object:nil];
}

//
//	Dispatch a "Resume Game" notification to any Observers
//

- (IBAction) dispatchResumeGameNotification{
	[kNotificationCenter postNotificationName:kResumeGameNotification object:nil];
}

//
//	Dispatch a "show Instructions" notification to any Observers
//

- (IBAction) dispatchShowInstructionsNotification{
	[kNotificationCenter postNotificationName:kShowInstructionsNotification object:nil];
}

#pragma mark -
#pragma mark Game Center leaderboard delegate
//
//	Dispatch a "Game Center" notification to any Observers
//

- (IBAction) dispatchGameCenterNotification{
	[kNotificationCenter postNotificationName:kShowGameCenterNotification object:nil];
}

#pragma mark -
#pragma mark Game Center Delegate

//
//	Dismiss the leaderbaord
//

- (void)leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController{
	[self dismissModalViewControllerAnimated:YES];
}

- (void)achievementViewControllerDidFinish:(GKAchievementViewController *)viewController{
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark -

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[super dealloc];
}


@end
