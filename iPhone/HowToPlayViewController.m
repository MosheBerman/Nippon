//
//  HowToPlayViewController.m
//  Nippon
//
//  Created by Moshe Berman on 1/24/11.
//  Copyright 2011 MosheBerman.com. All rights reserved.
//

#import "HowToPlayViewController.h"


@implementation HowToPlayViewController

@synthesize helpWebView;
@synthesize scroller, pageControl;
// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
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
	[scroller setBounds:[[UIScreen mainScreen] applicationFrame]];
	[scroller setDelegate:self];
	[scroller setContentSize:CGSizeMake(scroller.frame.size.width * kNumberOfSlides, scroller.frame.size.height)];
	//[scroller setBounces:NO];

	
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
	
	[self.view setBackgroundColor:[UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0]];
	
	//
	//	Tint the Navigation Bar
	//
	
	[self.navigationController.navigationBar setTintColor:[UIColor darkGrayColor]];
	
	
	//
	//	Set the background color on the web view to transparent
	//
	
	[self.helpWebView setBackgroundColor:[UIColor clearColor]];
	[self.helpWebView setOpaque:NO];
	//
	//	Build the Help HTML string
	//
	
	NSString *openingHTML = @"<html><head><style>body{background-color:transparent; text-align: center; font-family:sans, sans-serif;}</style></head>";
	
	NSString *closeHTML = @"<body></body></html>";
	
	NSString *firstParagraph = @"<p>\"Nippon\" is the name of the land in its native tounge, Japanese. Thank you for downloading this app, I hope you'll enjoy it.</p>";

	NSString *secondParagraph = @"<p></p>Nippon is a trading game. <p></p>To play Nippon, open the app from your home screen and tap \"Start New Game\". If you already have a game in progress, you will be prompted to overwrite the saved game, or go back to the menu, where you can continue the saved game by tapping \"Continue Game\".<p></p>You are a sushi vendor in Nippon. The object of the game is to pay off your debts to the Credit Union  and make as much money as you can in thirty days.<p></p>Once you have begun (or resumed) the game, you will be presented with the \"Travel\" menu, a list of some locations in Nippon. You travel to a city in Nippon by tapping on that city's name. Each time you travel to a new location, you lose one day. The game starts with thirty days and ends when you run out of time.<p></p>When you arrive at a new location, you will see the available items in the “Trade” menu. Some items are more expensive than others and prices change each time you travel. Each item's price is listed beneath it, as well as how many of that item you carry. To buy or sell an item, tap on it.<p></p>When you tap on an item, you will be shown a \"Financial Screen\", where you can buy or sell the item which you selected. Choose \"Buy\" or \"Sell\" from the toolbar above the keyboard. Enter how many of the item you want to sell in the box. If you want fill the box with as many as you can afford or as many as you have to sell, hit the \"Max\" button. When you are done, hit \"Confirm\". <p></p>When you travel to Tokyo, you will be prompted to visit the bank. In the bank, you can deposit your money and it will be safe from your most loyal fans, who occasionally get carried away. The bank offers two percent interest on your money. In Osaka, the Credit Union is headquartered. You will want to make sure that you pay off your debts to them. They charge twenty percent interest per day. The longer you wait, the more expensive your loan will be. <p></p>Nippon also includes support for Game Center leaderboards so you can compete against your friends, and achievements, so you can explore Nippon in ways you never <p></p>Enjoy!</p>";
	
	
	NSString *middleHTML = [NSString stringWithFormat:@"%@%@", firstParagraph, secondParagraph];
	
	NSString *html = [NSString stringWithFormat:@"%@%@%@", openingHTML, middleHTML, closeHTML];
	
	//
	//	Load the help HTML into the view
	//
	
	[self.helpWebView loadHTMLString:html baseURL:nil];
}


#pragma mark -
#pragma ScrollView Delegate

- (void) scrollViewDidScroll:(UIScrollView *)scrollView{
	
	[self setUpHelpInfo];
	
}


- (void) setUpHelpInfo{
	
	//Clear the subviews of the scroller
	[scroller.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
	
	//Determine which image we are up to
	int offset = scroller.contentOffset.x/scroller.frame.size.width;
	
	[pageControl setCurrentPage:offset];
	//[pageControl setBackgroundColor:[UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:0.4]];
	
	if(offset > 0){
		
		//Load the image
		UIImage *prevSlideImage = [UIImage imageNamed:[NSString stringWithFormat:@"%i.png", offset-1]];
		
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
	UIImage *currSlideImage = [UIImage imageNamed:[NSString stringWithFormat:@"%i.png", offset]];
	
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
		UIImage *nextSlideImage = [UIImage imageNamed:[NSString stringWithFormat:@"%i.png", offset+1]];
		
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

#pragma mark -

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[scroller release];
	[pageControl release];
	[helpWebView release];
    [super dealloc];
}


@end
