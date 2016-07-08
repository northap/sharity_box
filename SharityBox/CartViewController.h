//
//  CartViewController.h
//  SharityBox
//
//  Created by North on 5/8/2557 BE.
//  Copyright (c) 2557 North. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CartViewController : UIViewController <UIActionSheetDelegate>

@property (strong, nonatomic) IBOutlet UILabel *cartName;
@property (strong, nonatomic) IBOutlet UILabel *cartPrice;
@property (strong, nonatomic) IBOutlet UILabel *labelCartPrice;
@property (strong, nonatomic) IBOutlet UILabel *labelCatBillAddress;
@property (strong, nonatomic) IBOutlet UILabel *labelCartFirstName;
@property (strong, nonatomic) IBOutlet UILabel *labelCartLastName;
@property (strong, nonatomic) IBOutlet UILabel *labelCartAddress;
@property (strong, nonatomic) IBOutlet UILabel *labelCartPostcode;
@property (strong, nonatomic) IBOutlet UILabel *labelCartCountry;
@property (strong, nonatomic) IBOutlet UILabel *labelCartPayment;
@property (strong, nonatomic) IBOutlet UILabel *labelCartTotal;
@property (strong, nonatomic) IBOutlet UILabel *cartTotalPrice;
@property (strong, nonatomic) IBOutlet UIButton *btnCheckout;
@property (strong, nonatomic) IBOutlet UIView *viewCart;
@property (strong, nonatomic) IBOutlet UITextField *txtFirstname;
@property (strong, nonatomic) IBOutlet UITextField *txtLastname;
@property (strong, nonatomic) IBOutlet UITextField *txtAddress;
@property (strong, nonatomic) IBOutlet UITextField *txtPostcode;
@property (strong, nonatomic) IBOutlet UIButton *btnCountry;

@property UIActionSheet *actionSheetCountry;
@property UIActionSheet *actionSheetPayment;
- (IBAction)btnPaymentClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *btnPayment;
@property (strong, nonatomic) IBOutlet UIImageView *imageViewCart;
- (IBAction)btnCheckoutClicked:(id)sender;
- (IBAction)btnCountryClicked:(id)sender;

@end
