//
//  UIViewController+BannerMessages.m
//  Nippon
//
//  Created by Moshe Berman on 8/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UIViewController+BannerMessages.h"

@implementation UIViewController (UIViewController_BannerMessages)

- (void)presentBannerWithMessage:(NSString *)message
{
    [kNotificationCenter postNotificationName:kShowAlertNotification object:nil userInfo:[NSDictionary dictionaryWithObject:message forKey:@"message"]];
}
@end
