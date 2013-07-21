//
//  AchievementAlert.m
//  Nippon
//
//  Created by Moshe Berman on 5/4/11.
//  Copyright 2011 MosheBerman.com. All rights reserved.
//

#import "MessageBanner.h"


@implementation MessageBanner
@synthesize messageLabel, message;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithMessage:(NSString *)_message{
    self = [self initWithNibName:@"MessageBanner" bundle:nil];
    if (self) {
        self.message = _message;
    }
    return self;
}


- (void)didReceiveMemoryWarning{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.messageLabel setText:self.message];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self performSelector:@selector(animateOut) withObject:self afterDelay:kBannerAnimationDelay+kBannerDuration];
}

//
//
//

- (void) animateOut{
    
    [UIView beginAnimations:@"" context:@""];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(viewWasRemoved)];
    [UIView setAnimationDuration:kBannerSpeed];
    
    //
    //  TODO: Hide this through a notification or something
    //
    
    [self.view setFrame:CGRectMake(self.view.frame.origin.x, -self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height)];
    
    [UIView commitAnimations];
}

//
//  Finish cleaning up and alert the delegate 
//

- (void)viewWasRemoved{
    [kNotificationCenter postNotificationName:kAlertWasHiddenNotification object:self userInfo:nil];
    [self.view removeFromSuperview];    
}

//
//
//

- (void)viewDidUnload{
    [self setMessageLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

@end
