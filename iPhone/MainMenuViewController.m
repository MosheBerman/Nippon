//
//  MainMenuViewController.m
//  Nippon
//
//  Created by Moshe Berman on 1/10/11.
//  Copyright 2011 MosheBerman.com. All rights reserved.
//

#import "MainMenuViewController.h"
#import "HighScoresViewController.h"
#import "SpiffyKit.h"

@implementation MainMenuViewController


- (IBAction)checkForDevMode:(id)sender {
    
    //Uncomment the following line in public builds, to avoid gaming the leaderboards et al.
    return;
    
    //
    //  Increment the number of buttons being pressed
    //
    
    devModeCount = devModeCount + 1;
    
    //If the number of buttons being pressed is
    //the number of buttons there are, then show dev mode
    
    if (devModeCount == 3) {
        
        [kSettings setBool:YES forKey:@"devMode"];
        
        //
        //  Show the financial view controller
        //
        
        FinancialViewController *scoreChanger = [[FinancialViewController alloc] initWithMode:kModeDeveloper andItem:@"Test a Score" atPrice:[NSNumber numberWithInt:1]];
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:scoreChanger];
        
        //
        //  Style the navigation controller
        //
        
        [navController.navigationBar setOpaque:NO];
        [navController.navigationBar setTranslucent:YES];
        [navController.navigationBar setTintColor:[UIColor blackColor]];
        
        //release the score changer
        [scoreChanger release];
        
        [self presentModalViewController:navController animated:YES];
				
        [navController release];
        //NSLog(@"Secret button pressed. devMode count is at %i", devModeCount);
        
        //
        //  Since the view will not give us a chance
        //  to run the "releaseDevMode" message, we need
        //  to reset the dev mode count here after presenting
        //  the secret view controller.
        //
        
        devModeCount = 0;
        
    }else{
        [kSettings setBool:NO forKey:@"devMode"];
    }
    
    
    //NSLog(@"Secret button pressed. devMode count is at %i", devModeCount);
    
}

- (IBAction)releaseDevMode:(id)sender {
    
    //
    //  Decrement the dev mode counter
    //  when a button is not up
    //
    
    devModeCount = devModeCount - 1;
    
    //
    //      Log the release of the button
    //
    
    //NSLog(@"Secret button released. devMode count is at %i", devModeCount);
    
}

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
    //  Initialize the dev mode coundter
    //
    
    devModeCount = 0;
		
}

- (void) viewWillAppear:(BOOL)animated
{
		
		[super viewWillAppear:animated];
		
		//
		//	Check if game center is available and label the appropriate button accordingly
		//
		
		if(isGameCenterAvailable()){
				
				//
				//	Game Center is available
				//
				
				[highScoresButton setTitle:NSLocalizedString(@"Game Center", @"") forState:UIControlStateNormal];
				
		}else{
				
				//
				//	Game Center is NOT available
				//
				
				[highScoresButton setTitle:NSLocalizedString(@"High Scores", @"") forState:UIControlStateNormal];
		}
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

//
//  Show the rating UI in App Store
//

- (IBAction) rateAppInAppStore{
    
    //
    //  Build the URL
    //
    
    NSString *reviewURL = @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=415518235&type=Purple+Software";
    
    //
    //  Open the App Store Rate view
    //
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:reviewURL]];
}

#pragma mark -
#pragma mark Game Center leaderboard delegate
//
//	Dispatch a "Game Center" notification to any Observers
//

- (IBAction) dispatchGameCenterNotification{
		[kNotificationCenter postNotificationName:kShowGameCenterNotification object:nil];
}

#pragma mark - Contact the dev

- (IBAction)contactTheDev:(id)sender{
		[[SpiffyController sharedController] presentInViewController:self fromRectWhereApplicable:((UIButton*)sender).frame];
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
    [continueButton release];
    continueButton = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [continueButton release];
    [super dealloc];
}


@end
