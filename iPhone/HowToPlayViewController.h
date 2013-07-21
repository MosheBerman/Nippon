//
//  HowToPlayViewController.h
//  Nippon
//
//  Created by Moshe Berman on 1/24/11.
//  Copyright 2011 MosheBerman.com. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface HowToPlayViewController : UIViewController <UIScrollViewDelegate> {
	IBOutlet UIWebView *helpWebView;
	IBOutlet UIScrollView *scroller;
	IBOutlet UIPageControl *pageControl;
	
}

@property (nonatomic, strong) UIWebView *helpWebView;
@property (nonatomic, strong) UIScrollView *scroller;
@property (nonatomic, strong) UIPageControl *pageControl;

- (void) setUpHelpInfo;

@end
