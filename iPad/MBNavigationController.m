//
//  MBNavigationController.m
//  Nippon
//
//  Created by Moshe Berman on 2/13/11.
//  Copyright 2011 MosheBerman.com. All rights reserved.
//

#import "MBNavigationController.h"


@implementation MBNavigationController

/*
- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
    }
    return self;
}
*/
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
}
*/

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
	return YES;
}

- (void)dealloc {
    [super dealloc];
}


@end
