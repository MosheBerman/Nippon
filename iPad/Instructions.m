//
//  Instructions.m
//  Nippon
//
//  Created by Moshe Berman on 3/16/11.
//  Copyright 2011 MosheBerman.com. All rights reserved.
//

#import "Instructions.h"


@implementation Instructions
@synthesize scroller, pageControl;
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
 */

- (void)dealloc{
	[scroller release];
	[pageControl release];    
    [super dealloc];
}

- (void)didReceiveMemoryWarning{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
	//
	//	Set up the scroller
	//
	
	[scroller setPagingEnabled:YES];
	[scroller setShowsHorizontalScrollIndicator: NO];
	[scroller setShowsVerticalScrollIndicator:NO];
	[scroller setScrollsToTop: NO];
	[scroller setClipsToBounds:YES];
	[scroller setBounds:[self.view frame]];
	[scroller setDelegate:self];
	[scroller setContentSize:CGSizeMake(scroller.frame.size.width * kNumberOfSlides, scroller.frame.size.height)];
    [scroller setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    [scroller setContentOffset:CGPointMake(0, 0)];
    
	
	//
	//	Load the first slide into memory
	//
	
	[self setUpHelpInfo];
	
	//
	//
	//
	
	[pageControl setNumberOfPages:kNumberOfSlides];
	
	//
	//	Create the close button
	//
	
	UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStyleDone target:[[UIApplication sharedApplication] delegate] action:@selector(hideInstructions)];
	self.navigationItem.leftBarButtonItem = closeButton;
	[closeButton release];
	
	//
	//	Set the title
	//
	
	[self setTitle:NSLocalizedString(@"How To Play", @"")];
	
	//
	//	Set the background color
	//
	
	[self.view setBackgroundColor:[UIColor whiteColor]];

	
	//
	//	Tint the Navigation Bar
	//
	
	[self.navigationController.navigationBar setTintColor:[UIColor darkGrayColor]];
   	[self.navigationController.navigationBar setTranslucent:YES]; 
    
    [TestFlight passCheckpoint:@"Viewed Instructions."];
}

- (void)viewDidUnload{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    // Return YES for supported orientations
	return YES;
}

#pragma -
#pragma ScrollView Delegate

#pragma mark -
- (void) scrollViewDidScroll:(UIScrollView *)scrollView{
	
	[self setUpHelpInfo];
	
}


- (void) setUpHelpInfo{
	
	//Clear the subviews of the scroller
	[scroller.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
	
	//Determine which image we are up to
	int offset = scroller.contentOffset.x/scroller.frame.size.width;
	
	[pageControl setCurrentPage:offset];
	
	if(offset > 0){
		
		//Load the image
		UIImage *prevSlideImage = [UIImage imageNamed:[NSString stringWithFormat:@"%iPad.png", offset-1]];
		
		//Create the image view
		UIImageView *previousSlide = [[UIImageView alloc] initWithImage:prevSlideImage];
		
		[previousSlide setContentMode:UIViewContentModeScaleAspectFit];
		
		//Position the image
		[previousSlide setFrame:CGRectMake((offset-1)*scroller.frame.size.width, 0, scroller.frame.size.width, scroller.contentSize.height)];
		
		//Add the image to the screen
		[scroller addSubview:previousSlide];
		
		//release the image from memory
		[previousSlide release];
		
	}
	
	//Load the image
	UIImage *currSlideImage = [UIImage imageNamed:[NSString stringWithFormat:@"%iPad.png", offset]];
	
	//Create the image view
	UIImageView *currSlide = [[UIImageView alloc] initWithImage:currSlideImage];
	
	//Position the image
	[currSlide setFrame:CGRectMake(offset*scroller.frame.size.width, 0, scroller.frame.size.width, scroller.contentSize.height)];
	
	[currSlide setContentMode:UIViewContentModeScaleAspectFit];
	
	//add the image to the screen
	[scroller addSubview:currSlide];
	
	//release the image from memory
	[currSlide release];
	
	
	if(offset < kNumberOfSlides-1){
        
		//Load the image
		UIImage *nextSlideImage = [UIImage imageNamed:[NSString stringWithFormat:@"%iPad.png", offset+1]];
		
		//Create the image view
		UIImageView *nextSlide = [[UIImageView alloc] initWithImage:nextSlideImage];
		
		//Position the image
		[nextSlide setFrame:CGRectMake((offset+1)*scroller.frame.size.width, 0, scroller.frame.size.width, scroller.frame.size.height)];
		
		[nextSlide setContentMode:UIViewContentModeScaleAspectFit];
		
		//Add the image to the screen
		[scroller addSubview:nextSlide];
		
		//release the image from memory
		[nextSlide release];
	}
	
	
}

@end
