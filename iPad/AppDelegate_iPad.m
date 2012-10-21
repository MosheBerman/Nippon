//
//  AppDelegate_iPad.m
//  Nippon
//
//  Created by Moshe Berman on 1/9/11.
//  Copyright 2011 MosheBerman.com. All rights reserved.
//

#import "AppDelegate_iPad.h"

//
// Localize this file
//

@implementation AppDelegate_iPad


//
//	Report a particular achievement
//

- (void) reportAchievementIdentifier: (NSString*) identifier percentComplete: (float) percent{
    GKAchievement *achievement = [self achievementForIdentifier:identifier];
    if (achievement){
        
        if ([achievement respondsToSelector:@selector(showsCompletionBanner)]) {
            achievement.showsCompletionBanner = YES;
        }
        
        
		achievement.percentComplete = percent;
		[achievement reportAchievementWithCompletionHandler:^(NSError *error){
            if (error != nil){
                
				// NSLog(@"<MBGameCenter:> Could not report Achievement: %@. \n %@", achievement.identifier, [error description]);
                
                //
                //		Retain the achievement object and try again later.
                //
                
                [self.tempAchievements setObject:achievement forKey:achievement.identifier];
                
                [kSettings setObject:self.tempAchievements forKey:@"tempAchievements"];
                
                //
                //		Write the new temporary array to disk
                //
                
                [kSettings synchronize];
                
            }else {
				// NSLog(@"<MBGameCenter:> Reported achievement: %@", [achievement identifier]);
                
                if ([achievement percentComplete] == 100.0 && ![[achievement identifier] isEqualToString:kAchievementReminisce]) {
                    BOOL isUsingVersionFive = NO;
                    NSString *reqSysVer = @"5.0";
                    
                    NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
                    
                    if ([currSysVer compare:reqSysVer options:NSNumericSearch] != NSOrderedAscending){
                        //On iOS 5, otherwise rely on default message
                        isUsingVersionFive = YES;
                        return;
                    }
                    
                    NSDictionary *achivementLookup = [NSDictionary  dictionaryWithObjectsAndKeys:
                                                      @"Reminisce", kAchievementReminisce,
                                                      @"Manifest Destiny", kAchievementManifestDestiny, 
                                                      @"Well Rounded", kAchievementWellRounded,
                                                      @"Master Chef", kAchievementMasterChef,
                                                      @"Overstock", kAchievementOverstock,
                                                      @"Shameful", kAchievementShameful,
                                                      @"No Nori",
                                                      kAchievementNoNori,                                        
                                                      @"Day Trader",
                                                      kAchievementDayTrader,
                                                      @"Corner The Market",kAchievementCornerTheMarket,
                                                      @"Funazushi",                                                       kAchievementFunazushi,
                                                      @"Five-0",                                                       kAchievementFiveO,
                                                      @"Allergic",                                                       kAchievementAllergic,
                                                      @"Wealthy",                                                       kAchievementWealthy,
                                                      @"In For One",                                                       kAchievementInForOne,
                                                      @"Merlin's Beard",kAchievementMerlinsBeard,
                                                      @"Inheritance", kAchievementInheritance,
                                                      @"Reserved", kAchievementReserved,
                                                      @"Zero",                                                       kAchievementZero,
                                                      nil];

                    //
                    // Create the alert banner
                    //
                    
                    MessageBanner *alert = [[MessageBanner alloc] initWithMessage:[NSString stringWithFormat:@"%@", [achivementLookup objectForKey:[achievement identifier]]]];
                    
                    //
                    //  Position the frame
                    //
                    
                    [alert.view setFrame:CGRectMake((self.window.frame.size.width/2)-(alert.view.frame.size.width/2), -alert.view.frame.size.height, alert.view.frame.size.width, alert.view.frame.size.height)];
                    
                    
                    //
                    //
                    //
                    
                    //
                    //  check for UI orientation
                    //
                    
                    
                    if ([[UIApplication sharedApplication]statusBarOrientation] == UIInterfaceOrientationLandscapeLeft) {
                        
                        //
                        //
                        //
                        
                        alert.view.transform = CGAffineTransformRotate(alert.view.transform, degreesToRadians(-90));
                        
                    }else if([[UIApplication sharedApplication]statusBarOrientation] == UIInterfaceOrientationLandscapeRight){
                        
                        
                        //
                        //
                        //
                        
                        alert.view.transform = CGAffineTransformRotate(alert.view.transform, degreesToRadians(90));
                        
                    }else if([[UIApplication sharedApplication]statusBarOrientation] == UIInterfaceOrientationPortrait){
                        
                        //
                        //  No need to rotate the view
                        //
                        
                    }else if([[UIApplication sharedApplication]statusBarOrientation] == UIInterfaceOrientationPortraitUpsideDown){
                        
                        //
                        //  Flip the view
                        //
                        
                        alert.view.transform = CGAffineTransformRotate(alert.view.transform, degreesToRadians(180));
                    }
                    
                    //
                    // Add self as an observer for this notification
                    //
                    
                    [kNotificationCenter addObserver:self selector:@selector(alertWasHidden:) name:kAlertWasHiddenNotification object:nil];
                    
                    //
                    // Add the banner to the display hierarchy
                    //
                    
                    [self.window addSubview:alert.view];
                    
                    //
                    // Animate it into view
                    //
                    
                    [UIView beginAnimations:@"" context:@""];
                    [UIView setAnimationDelay:kBannerAnimationDelay];
                    [UIView setAnimationDuration:kBannerSpeed];
                    
                    
                    //  Working location
                    [alert.view setFrame:CGRectMake((self.window.frame.size.width/2)-(alert.view.frame.size.width/2), 10.0, alert.view.frame.size.width, alert.view.frame.size.height)];
                    
                    
                    
                    //
                    // Increment the number of visible alerts
                    //
                    
                    numberOfVisibleAlerts = numberOfVisibleAlerts + 1;
                    
                    [UIView commitAnimations];
                    
                    [alert release];
                    
                }
            }
            
        }];
    }
}

//
//
//
/*
 
 //
 //  check for UI orientation
 //
 
 
 if ([[UIApplication sharedApplication]statusBarOrientation] == UIInterfaceOrientationLandscapeLeft) {
 
 }else if([[UIApplication sharedApplication]statusBarOrientation] == UIInterfaceOrientationLandscapeLeft){
 
 }else if([[UIApplication sharedApplication]statusBarOrientation] == UIInterfaceOrientationPortrait){
 
 [alert.view setFrame:CGRectMake((self.window.frame.size.width/2)-(alert.view.frame.size.width/2), -alert.view.frame.size.height, alert.view.frame.size.width, alert.view.frame.size.height)];
 
 }else if([[UIApplication sharedApplication]statusBarOrientation] == UIInterfaceOrientationPortraitUpsideDown){
 
 [alert.view setFrame:CGRectMake((self.window.frame.size.width/2)-(alert.view.frame.size.width/2), self.window.frame.size.height + alert.view.frame.size.height, alert.view.frame.size.width, alert.view.frame.size.height)];                        
 }
 
 */



@end
