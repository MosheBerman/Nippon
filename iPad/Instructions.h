//
//  Instructions.h
//  Nippon
//
//  Created by Moshe Berman on 3/16/11.
//  Copyright 2011 MosheBerman.com. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface Instructions : UIViewController <UIScrollViewDelegate>{
	IBOutlet UIScrollView *scroller;
	IBOutlet UIPageControl *pageControl;   
}

@property (nonatomic, strong) UIScrollView *scroller;
@property (nonatomic, strong) UIPageControl *pageControl;

- (void) setUpHelpInfo;

@end
