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
@synthesize buttonWrapperView;

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
	
	[versionLabel setText:[NSString stringWithFormat:@"%@%@",NSLocalizedString(@"v", @"an abbreviation for the word 'version'") ,[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]]];
	
    //
    //
    //
    
    buttonWrapperView.layer.borderColor = [UIColor darkGrayColor].CGColor;
    buttonWrapperView.layer.borderWidth = 1.0;

    buttonWrapperView.layer.cornerRadius = 5.0;
}


- (void) viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
    
	//
	//	Check if game center is available and label the button accordingly
	//
	
	if(isGameCenterAvailable()){
		
		//
		//	Game Center is available
		//
		
		[gameCenterButton setTitle:NSLocalizedString(@"Game Center", @"A button to show the Game Center UI") forState:UIControlStateNormal];
		
	}else{
		
		//
		//	Game Center is NOT available
		//
		
		[gameCenterButton setTitle:NSLocalizedString(@"High Scores", @"Show the high scores UI.") forState:UIControlStateNormal];
	} 
    
    [self handleChangeToOrientation:[[UIApplication sharedApplication]statusBarOrientation]];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if (kInGame == YES) {
        [continueButton setAlpha:1.0];
        [continueButton setEnabled:YES];
    }else{
        [continueButton setAlpha:0.5];
        [continueButton setEnabled:NO];       
    }
}

#pragma mark -
#pragma mark orientation changes

//
//	Handle orientation changes and lay out the buttons
//

- (void) handleChangeToOrientation:(UIInterfaceOrientation)orientation{
	
	if (UIDeviceOrientationIsPortrait(orientation)) {
		
		[UIView beginAnimations:@"rotationToPortrait" context:nil];
		[landscapeImage setHidden:YES];
		[portraitImage setHidden:NO];
        /*
		[newGameButton setFrame:kRectsButtonNewGamePortrait];
		[continueGameButton setFrame:kRectsButtonContinueGamePortrait];
		[howToPlayButton setFrame:kRectsButtonHowToPlayPortrait];
		[gameCenterButton setFrame:kRectsButtonGameCenterPortrait];
         */
		[versionLabel setFrame:kRectsLabelVersionPortrait];
		[UIView commitAnimations];
		
	}else{

		[UIView beginAnimations:@"rotationToPortrait" context:nil];
		[landscapeImage setHidden:NO];
		[portraitImage setHidden:YES];
        /*
		[newGameButton setFrame:kRectsButtonNewGameLandscape];
		[continueGameButton setFrame:kRectsButtonContinueGameLandscape];
		[howToPlayButton setFrame:kRectsButtonHowToPlayLandscape];
		[gameCenterButton setFrame:kRectsButtonGameCenterLandscape];
         */
		[versionLabel setFrame:kRectsLabelVersionLandscape];		
		[UIView commitAnimations];
	}
	
}

- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
	[self handleChangeToOrientation:(UIInterfaceOrientation)[[UIDevice currentDevice] orientation]];
}

#pragma mark -
#pragma mark Orentation

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES; //self.modalViewController == nil;
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

- (void)dealloc {
    [continueButton release];
    [buttonWrapperView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [continueButton release];
    continueButton = nil;
    [self setButtonWrapperView:nil];
    [super viewDidUnload];
}

#pragma mark - Contact the dev

- (IBAction)contactTheDev:(id)sender{
    
    //
    //  Check for mail setup
    //
    
    
    if (![MFMailComposeViewController canSendMail]) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error",@"Error")
                                                        message:NSLocalizedString(@"Mail is not set up. You can set it up in the Mail app, or email the developer at yetanotheriphoneapp@gmail.com. Thanks!", @"mail error message")
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"OK",@"") 
                                              otherButtonTitles: nil];
        [alert show];
        [alert release];
        return;
    }
    
    //
    //  Create the mail composer
    //
    
    MFMailComposeViewController *mailVC = [[MFMailComposeViewController alloc] init];
    
    //
    //  Configure the email
    //
    
    [mailVC setToRecipients:[NSArray arrayWithObject:@"yetanotheriphoneapp@gmail.com"]];
    
    //
    //  Build the mail
    //
    
    NSString *iOSVersion = [[UIDevice currentDevice] systemVersion];
    NSString *appversion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *device = [[UIDevice currentDevice]model];
    
    NSString *message = [NSString stringWithFormat:@"Hey Moshe,\n I'm playing Nippon v%@ on an %@ running iOS %@. I have some feedback for you: ", appversion, device, iOSVersion];
    
    [mailVC setMessageBody:message isHTML:NO];
    [mailVC setSubject:@"Nippon Feedback"];
    
    mailVC.mailComposeDelegate = self;
    
    [mailVC setModalPresentationStyle:UIModalPresentationFormSheet]; 
    
    if([self respondsToSelector:@selector(presentViewController:animated:completion:)]){
        [self presentViewController:mailVC animated:YES completion:^{}];
    }else{
        [self presentModalViewController:mailVC animated:YES];
    }
    
    [mailVC release];
}

//
//  Fires when the message is sent.
//

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    if (result == MFMailComposeResultSent) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Thanks",@"Thanks")
                                                        message:NSLocalizedString(@"Thanks for your feedback!", @"mail feedback message")
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"OK",@"") 
                                              otherButtonTitles: nil];
        [alert show];
        [alert release];
    }
    
    if([self respondsToSelector:@selector(dismissViewControllerAnimated:completion:)]){
        [self dismissViewControllerAnimated:YES completion:^{}];
    }else{
        [self dismissModalViewControllerAnimated:YES];
    }
    
    
}

@end
