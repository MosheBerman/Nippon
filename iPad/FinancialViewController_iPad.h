//
//  FinancialViewController.h
//  Nippon
//
//  Created by Moshe Berman on 1/12/11.
//  Copyright 2011 MosheBerman.com. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FinancialViewController_iPad : UIViewController {
	
	//
	//	The mode of the view
	//
	
	NSString *mode;
	
	//
	//	The price of the item
	//
	
	NSInteger price;
	
	//
	//	The input box's outlet
	//
	
	IBOutlet UITextField *amountBox;
	
	//
	//	An outlet for the buy and sell
	//
	
	IBOutlet UISegmentedControl *modeSelector;
	
	//
	//
	//
		
	IBOutlet UIView *newInput;
}

@property(nonatomic, retain) NSString *mode;
@property NSInteger price;
@property (nonatomic, retain) UITextField *amountBox;
@property (nonatomic, retain) UISegmentedControl *modeSelector;

//
//	Initialize the financial view and pass a mode, item and price
//

- (id)initWithMode:(NSString *)mode andItem:(NSString *)item atPrice:(NSNumber *)price;

//
//	Handle the "confirm" button
//

- (IBAction) handleConfirm;

//
//	Perform a purchase
//

- (BOOL) performPurchase;

//
//	Sell an itme
//

- (BOOL) performSale;

//
//	Withdraw money from the bank
//

- (BOOL) performWithdrawal;

//
//	Deposit money into the bank
//

- (BOOL) performDeposit;

//
//	Borrow from the loan shark
//

- (BOOL) performBorrow;

//
//	Pay the loan shark
//

- (BOOL) performPayment;


//
//	Handle changes to the mode selector
//

- (IBAction) modeSelectorChanged;

//
//	Handle the Max Button
//

- (IBAction) handleMaxButton;

//
//	Set the placeholder text on the textbox
//

- (void) setPlaceholderText;

//
//	Set the information label
//

- (void) setInformationLabelText:(NSString *)text;

//
//
//

- (IBAction) AddNumber:(id)sender;

//
//	Clear the last item in the box
//

- (IBAction)deleteLast:(id)sender;

//
//	Clear the text box
//

- (IBAction) clearBox;

//
//
//

BOOL isGameCenterAvailable();

@end
