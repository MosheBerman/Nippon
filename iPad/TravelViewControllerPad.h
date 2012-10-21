//
//  TravelViewControllerPad.h
//  Nippon
//
//  Created by Moshe Berman on 2/15/11.
//  Copyright 2011 MosheBerman.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HowToPlayViewController.h"


@interface TravelViewControllerPad : UIViewController <UIPopoverControllerDelegate>{
	
	//
	//	Two view outlets for the various orientations
	//
	
	IBOutlet UIView *landscapeView;
	IBOutlet UIView *portraitView;
	
	//
	//	An outlet for the information button
	//
	
	IBOutlet UIBarButtonItem *informationButton;
	
	//
	//	An outlet for the "Purchase" menu
	//
	
	UIPopoverController *popover;
	
	//
	//	
	//
	
	IBOutlet UILabel *locationLabelPortrait;
	IBOutlet UILabel *locationLabelLandscape;
	
	//
	//	
	//
	
	IBOutlet UILabel *timeLabelLandscape;
	IBOutlet UILabel *timeLabelPortrait;
    
    //
    //
    //
    
    int devModeCount;
    
    //
    //  The pin view
    //
    
    UIImageView *locationView;
	
}

@property (nonatomic, retain) UIPopoverController *popover;
@property (nonatomic, retain) UIBarButtonItem *informationButton;
@property (nonatomic, retain) UIView *landscapeView;
@property (nonatomic, retain) UIView *portraitView;

//
//
//

@property (nonatomic, retain) UILabel *locationLabelLandscape;
@property (nonatomic, retain) UILabel *locationLabelPortrait;
@property (nonatomic, retain) UILabel *timeLabelLandscape;
@property (nonatomic, retain) UILabel *timeLabelPortrait;
@property (nonatomic, retain) UIImageView *locationView;



//
//	
//

- (id) initWithOrientation:(UIDeviceOrientation)orientation;

//
//
//

- (void) handleChangeToOrientation:(UIDeviceOrientation)orientation;

- (IBAction) hideGame;

- (IBAction) showLocation:(id)sender;

- (void) generateRandomEvents;

- (void) handleMobOfFansWithAction:(NSString *)action;

- (IBAction) merlinsBeard;

@end
