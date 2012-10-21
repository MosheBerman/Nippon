//
//  TravelViewController.h
//  Nippon
//
//  Created by Moshe Berman on 1/10/11.
//  Copyright 2011 MosheBerman.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DealViewController.h"

@interface TravelViewController : UITableViewController <UIAlertViewDelegate>{

	NSArray *locations;
}

@property (nonatomic, retain) NSArray *locations;

- (void) generateRandomEvents;

- (void) handleMobOfFansWithAction:(NSString *)action;

@end
