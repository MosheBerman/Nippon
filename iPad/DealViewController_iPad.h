//
//  DealViewController.h
//  Nippon
//
//  Created by Moshe Berman on 1/10/11.
//  Copyright 2011 MosheBerman.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DealViewController_iPad : UITableViewController <UIAlertViewDelegate>{
	
	//
	//	An array of items
	//
	
	NSArray *items;
	
	//
	//	An array of prices
	//
	
	NSArray *prices;
}

@property (nonatomic, retain) NSArray *items;
@property (nonatomic, retain) NSArray *prices;


//
//	Show the bank
//

- (void) showBank;

//
//	Show the credit Union
//

- (void) showCreditUnion;

//
//	Determine if Game Center is available
//

BOOL isGameCenterAvailable();

//
//	Reload the table in case of a relevant event
//

- (void) reloadTheView:(NSNotification *)notif; 

@end
