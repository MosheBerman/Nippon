//
//  HighScoresViewController.h
//  Nippon
//
//  Created by Moshe Berman on 1/28/11.
//  Copyright 2011 MosheBerman.com. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface HighScoresViewController : UITableViewController {
	NSArray *highScores;
}

@property (nonatomic, copy) NSArray *highScores;

-(void)dismissSelf;

@end

