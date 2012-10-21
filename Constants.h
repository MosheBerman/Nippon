/*
 *  Constants.h
 *  Nippon
 *
 *  Created by Moshe Berman on 1/9/11.
 *  Copyright 2011 MosheBerman.com. All rights reserved.
 *
 */


/* --------------------------- Shortcut Constants ------------------------------ */

//A shortcut to the Settings Objects
#define kSettings [NSUserDefaults standardUserDefaults]

//A shortcut to the notification center
#define kNotificationCenter [NSNotificationCenter defaultCenter]

//A shortcut to the ¥ (YEN) symbol
#define kYen @"¥"

//A shrtcut to the game center leaderboard name constant
#define kLeaderboardCategory @"com.yetanotheriphoneapp.nippon.highscores"

//A shortcut to the game center leaderboard name constant
#define kDoubleLeaderboardCategory @"com.yetanotheriphoneapp.nippon.doublehighscores"

//A shrtcut to the game center leaderboard name constant
#define kCheaterLeaderboardCategory @"com.nippon.yetanotheriphoneapp.enhanced"

//The Travel View Row Height
#define kRowHeight 70.0f

//The Travel View Row Height
#define kRowHeightiPad 160.0f

//The height of the rows in the deal view
#define kDealViewRowHeight 52.0f

//The Deal view row height on iPad
#define kRowHeightDealViewiPad 72.0f

//The font size for the travel view 
#define kFontSizeForiPad 26.0f

//A shortcut to the temporary scores array
#define kTempScores [kSettings objectForKey:@"tempScores"]

//A shortcut to the cache of achievements
#define kTempAchievements [kSettings objectForKey:@"tempAchievements"]

//How long to postpone the banner display (float/double >=0)
#define kBannerAnimationDelay 0.1

//Achievement banner Transition speed (float/double >=0)
#define kBannerSpeed 0.75

//How long to show the banner (float/double >=0)
#define kBannerDuration 2


//A shortcut for converting degrees to radians - not 
//used currently, but useful for rotating views on iPad
#define degreesToRadians(x) (M_PI * x / 180.0)

/* ------------------- Number Grouping Format Constants -------------------------*/

//A shortcut for the formatting seperator
#define kFormatterGroupingSeparator [[NSLocale currentLocale] objectForKey:NSLocaleGroupingSeparator]

//Should we use a grouping separator altogether?
#define kFormatterEnabled YES

/* ------------------------- "How To Play" Constants --------------------------- */

//How many help slides there are
#define kNumberOfSlides 7

/* --------------------------------- Color Constants --------------------------- */

//The tint color for the navbar
#define kRedColor [UIColor colorWithRed:0.5 green:0 blue:0 alpha:1]

/* -------------------------- Game Options "Getter" Constants ------------------ */

//Is the user in the middle of a game?
#define kInGame [kSettings boolForKey:@"inGame"]

//The number of days left
#define kDaysLeft [kSettings objectForKey:@"daysLeft"]

//The number of items your cart can hold
#define kMaxCart [kSettings objectForKey:@"maxCart"]

//How much cash you have
#define kCash [kSettings objectForKey:@"cash"]

//How much debt you have
#define kDebt [kSettings objectForKey:@"debt"]

//How much savings you have
#define kSavings [kSettings objectForKey:@"savings"]

//The last location which was travelled to
#define kLastLocation [kSettings objectForKey:@"lastLocation"]

//The items in your cart
#define kCart [kSettings objectForKey:@"cart"]

//Set up the developer mode
#define kDevMode [kSettings objectForKey:@"devMode"]

//Check if the player cheated
#define kCheated [kSettings boolForKey:@"cheated"]

/* --------------- Game Options Default Initial Settings Constants ------------ */

//How many days to wait before prompting the user to rate
#define kNumberOfDaysBeforeRatingPrompt 10

//
//	TODO: Confirm values before posting to the App Store
//

//The initial number of days remaining (int) - default is 30
#define kInitialDaysLeft 30

//The initial number of items your cart can hold - default is 100
#define kInitialCart 100

//The initial amount of cash - default is 2000
#define kInitialCash 2000

//The initial amount of debt - default is 5500
#define kInitialDebt 5500

//The initial amount of savings
#define kInitialSavings 0

//How long it takes (in days) to travel from one location to another
#define kTravelTime 1

//How many items must be sold to earn the "Day Trader" achievement
#define kDayTraderThreshold 4500

//The maximum number of items that can qualify for Reserved Buisnessman
#define kReservedThreshold 1000

//How many items must be bought to earn the "Corner The Market" achievement
#define kCornerTheMarketThreshold 30000

//How many times a Funazushi must occur for the "Funazushi" Achievement
#define kFunazushiThreshold 15

//How large a cart must be to qualify for Manifest Destiny
#define kManifestDestinyThreshold 300

/* ------------------------------  Interest Constants -------------------------- */

//The amount of interest the bank gives per day (including principal)
#define kBankInterest 1.0285

//The amount of interest the credit union charges per day (including principal)
#define kDebtInterest 1.159

//The maximum amount of debt you can incur and still receive a loan - Default is 1,000,000
#define kDebtCap 2000000

/* --------------------------- Financial View Modes ---------------------------- */

//The mode in which the Credit Union is shown
#define kModeCreditUnion @"credit union"

//The mode in which the bank is shown
#define kModeBank @"bank"

//The "regular" mode where items are traded
#define kModeItem @"item"

//Developer mode
#define kModeDeveloper @"developer mode"

/*--------------------------------  Names of items ----------------------------- */

//Nagiri
#define kItemsNagiri @"Nagiri"

//Maki
#define kItemsMaki @"Maki"

//Oshi
#define kItemsOshi @"Oshi"

//Inari
#define kItemsInari @"Inari"

//Sashimi
#define kItemsSashimi @"Sashimi"

//Chirashi
#define kItemsChirashi @"Chirashi"

//Nare
#define kItemsNare @"Nare"

//Sushizushi
#define kItemsSushizushi @"Sushizushi"

/* -------------------------  Price "Getter" Constants ------------------------- */

//The getter for the price of Nagiri
#define kPriceOfNagiri [kSettings objectForKey:@"priceOfNagiri"]

//The getter for the price of Maki
#define kPriceOfMaki [kSettings objectForKey:@"priceOfMaki"]

//The getter for the price of Oshi
#define kPriceOfOshi [kSettings objectForKey:@"priceOfOshi"]

//The getter for the price of Inari
#define kPriceOfInari [kSettings objectForKey:@"priceOfInari"]

//The getter for the price of Sashimi
#define kPriceOfSashimi [kSettings objectForKey:@"priceOfSashimi"]

//The getter for the price of Chirashi
#define kPriceOfChirashi [kSettings objectForKey:@"priceOfChirashi"]

//The getter for the price of Nare
#define kPriceOfNare [kSettings objectForKey:@"priceOfNare"]

//The getter for the price of Sushizushi
#define kPriceOfSushizushi [kSettings objectForKey:@"priceOfSushizushi"]

/* ---------------------------  Price Range Constants -------------------------- */

//The minimum and maximum prices of Nagiri (Should be between 3,000 and 7,500)
#define kPriceNagiriMin 3000
#define kPriceNagiriMax 7350

//The minimum and maximum price of Maki (Should be betwen 10,000 and 25,000)
#define kPriceMakiMin 11000
#define kPriceMakiMax 26500

//The minimum and maximum price of Oshi (Should be between 10 and 200)
#define kPriceOshiMin 15
#define kPriceOshiMax 205

//The minimum and maximum price of Inari (Should be between 13,000 and 16,000)
#define kPriceInariMin 13000
#define kPriceInariMax 16000

//The minimum and maximum price of Sashimi (Should be between 3,000 and 8,000)
#define kPriceSashimiMin 3500	
#define kPriceSashimiMax 82000

//The minimum and maximum price of Chirashi (Should  be between 250 and 600)
#define kPriceChirashiMin 250
#define kPriceChirashiMax 600

//The minimum and maximum price of Nare (Should be between 500 and 1,200)
#define kPriceNareMin 500
#define kPriceNareMax 1208

//The minimum and maximum price of Sushizushi (Should be between 400,000 and  1,500,000)
#define kPriceSushizushiMin 400500
#define kPriceSushizushiMax 1600505

/* ---------------------------- Notification Constants ------------------------- */

//A notification that says that the game should start anew
#define kStartNewGameNotification @"start a new game"

//A notification that says that the game should resume
#define kResumeGameNotification @"resume the existing game"

//A notification that says that the app should show instructions
#define kShowInstructionsNotification @"show the instructions view"

//A notification that says that the game should show Game Center options
#define kShowGameCenterNotification @"show the game center action sheet"

//A notification that says that the game should hide the instructions
#define kHideInstructionsNotification @"hide the instructions view"

//A notification that says that the game should hide the game view
#define kHideGameNotification @"hide the game view"

//A notification saying to show the bank
#define kShowBankNotification @"show the bank view"

//A notification saying to show the credit union
#define kShowCreditUnionNotification @"show the credit union view"

//A notificaiton saying that the game is over
#define kGameOverNotification @"the game is over"

//A notification that says that the Credit Union Easter Egg was activated
#define kEasterEggNotification @"the credit union easter egg just occurred"

//A notification that says that a purchase occured
#define kPurchaseOccurredNotification @"a purchase occurred"

//A notification that says that a sale occurred
#define kSaleOccurredNotification @"a sale occurred"

//A notification that says that a Funazushi occurred
#define kFunazushiOccurredNotification @"a funazushi occurred"

//A notificaiton that says that the Player's sushi was taken
#define kSushiWasHalvedNotification @"players sushi was halved"

//A notificaiton that says that the player is well rounded
#define kPlayerIsWellRoundedNotification @"player is well rounded"

//A notificaiton that says that the player is well rounded
#define kPlayerIsInForOneNotification @"player is in for one"

//A notificaiton that says that the player is well rounded
#define kPlayerHasSushizushiNotification @"player has sushizushi"

//A notification saying that all of the random events have occurred
#define kRandomEventsAreDoneNotification @"random events are done"

//A notification sayig that an alert banner should be shown
#define kShowAlertNotification @"please present an alert"

//A notification saying that an alert banner was hidden
#define kAlertWasHiddenNotification @"alert was hidden"

/* ------------------------- Random Events Constants --------------------------- */

//All your sushi is spoiled and must be thrown
#define kRandomEventSpoiled	NSLocalizedString(@"Funazushi!", @"")

//You found a few Sushi
#define kRandomEventFoundAFew NSLocalizedString(@"Found Sushi!", @"")

//Do you want to buy a bigger cart?
#define kRandomEventBiggerCart NSLocalizedString(@"Buy a Bigger Cart?", @"")

//Extremely high prices on a particular item
#define kRandomEventPricesSkyrocket NSLocalizedString(@"Prices Rise:", @"")

//Extremely low prices on a particular item
#define kRandomEventPricesBottomOut NSLocalizedString(@"Prices Fall:", @"")

//A mob of fans is chasing you (Give them some of your sushi or run away)
#define kRandomEventMobOfFans NSLocalizedString(@"Mob!", @"")

//You lost some money
#define kRandomEventLostMoney NSLocalizedString(@"Lost Money...", @"")


/* -------------------- Random Events Probability Constants -------------------- */

//
//	These probabilities are numbers between zero and one hundred.
//	If the divisor is larger, the event is LESS likely.
//

//How often "all of your items spoil"
#define kProbabilityOfSpoiled 1000/105

//How often you find items
#define kProbabilityOfFoundAFew 1000/65

//The maximum number of items you can find
#define kMaxItemsFound 15

//How often the player is offered a bigger cart
#define kProbabilityOfBiggerCart 1000/75

//how often prices go up
#define kProbabilityOfPricesSkyrocket 1000/60

//how often prices drop to extreme lows
#define kProbabilityOfPricesBottomOut 1000/65

//how often the player is chased by a mob of fans
#define kProbabilityOfMobOfFans 1000/85

//How often you can lose money
#define kProbabilityOfLosingMoney 1000/96

//
//	These are not divisors, but thresholds
//

//This is the maximum threshold for the number 
//representing the probability of ditching 
//the mob of fans (approximately 40)
#define kProbabilityOfDitchingTheMob 44

//how much cheaper items become when the prices drop
//The current price is divided by this integer (Approximately 20-30)
#define kBottomOutFactor 28

//How much more expensive an item becomes when the price skyrockets
//The current price is multiplied by this integer (Approximately 10)
#define kSkyrocketPriceFactor 12

/* ------------------------- Alert Button Constants ---------------------------- */

//Yes Button Titler
#define kButtonTitleYes NSLocalizedString(@"Yes", @"")

//No Button Title
#define kButtonTitleNo NSLocalizedString(@"No", @"")

//Run Button Title
#define kButtonTitleRun NSLocalizedString(@"Run", @"")

//Share Button Title
#define kButtonTitleShare NSLocalizedString(@"Share", @"")

/* ---------------------- Game Center Related Constants ------------------------ */

//The leaderboards button title
#define kLeaderBoardsButtonTitle NSLocalizedString(@"High Scores", @"")

//The achievements button title
#define kAchievementsButtonTitle NSLocalizedString(@"Achievements", @"")

//How many games have been played through (for "Master Chef")
#define kNumberOfGamesPlayed [kSettings objectForKey:@"numberOfGamesPlayed"]

//How many items were sold during a single game (Day Trader)
#define kNumberOfItemsSold [kSettings objectForKey:@"numberOfItemsSold"]
 
//How many items the player has bought over all games (Corner the market)
#define kNumberOfItemsBought [kSettings objectForKey:@"numberOfItemsBought"]

//How many times the player's sushi spoiled (Funazushi)
#define kNumberOfTimesFunazushi [kSettings objectForKey:@"numberOfTimesFunazushi"]

//Has the player gone without buying Nori?
#define kNoNori [kSettings objectForKey:@"noNori"]

//Has the player gone without buying or finding nori?
#define kIsAllergic [kSettings objectForKey:@"isAllergic"]


/* -------------------------- Achievement Identifier Constants ----------------- */

//Reminisce - Download the game - (1 point)
#define kAchievementReminisce @"nippon.reminisce"

//Well Rounded - Carry at least four kinds of Sushi at once (10 points)
#define kAchievementWellRounded @"nippon.wellrounded"

//Master Chef - Play through five games of Nippon (10 points)
#define kAchievementMasterChef @"nippon.masterchef"

//Overstock - Have a full cart at the end of the game (10 points)
#define kAchievementOverstock @"nippon.overstock"

//Ashamed - Finished a game with a negative score 11 points)
#define kAchievementShameful @"nippon.ashamed"

//No Nori - Complete the game with a positive score without 
//buying Maki, Oshi, Insari, Nare or Sushizushi (12 points)
#define kAchievementNoNori @"nippon.nonori"

//Day Trader - Sell at least 4,500 items in one game (15 points)
#define kAchievementDayTrader @"nippon.daytrader"

//Corner The Market - Sell at least 30,000 items through one or multiple games (20 points)
#define kAchievementCornerTheMarket @"nippon.cornerthemarket"

//Funazushi - All of your Sushi spoils 5 times (20 points)
#define kAchievementFunazushi @"nippon.funazushi"

//Five Zero - Get 500 yen from the Credit Union (25 point)
#define kAchievementFiveO @"nippon.fiveO"

//Allergic - Play through a game without buying or finding
//Maki, Oshi, Inari, Nare or Sushizushi (25 points)
#define kAchievementAllergic @"nippon.allergic"

//Wealthy - Buy one Sushizushi (36 points)
#define kAchievementWealthy @"nippon.wealthy"

//In for One - Carry one of everything at once in a single game (36 points)
#define kAchievementInForOne @"nippon.inforone"

//Merlin's Beard - Find Merlin
#define kAchievementMerlinsBeard @"nippon.merlinsbeard"

//Inheritance - Sell 100 sushizushi
#define kAchievementInheritance @"nippon.inheritance"

//Reserved Businessman - Win while selling less than 1000 items
#define kAchievementReserved @"nippon.reserved"

//Mnifest Destiny - Expand a cart to hold over 300 items
#define kAchievementManifestDestiny @"nippon.manifest"

//Zero - Score exactly sero during one of your games 
#define kAchievementZero @"nippon.zero"


/* ------------------------------- Menu Layout constants --------------------- */

//The locations of the "New Game Button"
#define kRectsButtonNewGameLandscape CGRectMake(170, 160, 279, 52)
#define kRectsButtonNewGamePortrait CGRectMake(82, 285, 279, 52)

//The locations of the "Continue Game" Button
#define kRectsButtonContinueGameLandscape CGRectMake(176, 245, 267, 52)
#define kRectsButtonContinueGamePortrait CGRectMake(89, 365, 267, 52)

//The locations of the "How To Play" Button
#define kRectsButtonHowToPlayLandscape CGRectMake(202, 325, 215, 52)
#define kRectsButtonHowToPlayPortrait CGRectMake(115, 445, 215, 52)

//The locations of the "Game Center" button
#define kRectsButtonGameCenterPortrait CGRectMake(109, 525, 226, 52)
#define kRectsButtonGameCenterLandscape CGRectMake(200, 405 , 226, 52)

//The Version label
#define kRectsLabelVersionPortrait CGRectMake(725, 873, 42, 21)
#define kRectsLabelVersionLandscape CGRectMake(957, 680, 42, 21)

