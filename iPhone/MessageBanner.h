//
//  AchievementAlert.h
//  Nippon
//
//  Created by Moshe Berman on 5/4/11.
//  Copyright 2011 MosheBerman.com. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MessageBanner : UIViewController {
    
    UILabel *messageLabel;
    NSString *message;
}

@property (nonatomic, retain) IBOutlet UILabel *messageLabel;
@property (nonatomic, retain) NSString *message;

//
//  Initialize the view
//

- (id)initWithMessage:(NSString *)message;

//
//
//

- (void) animateOut;

//
//  Finish cleaning up and alert the delegate 
//

- (void)viewWasRemoved;

@end
