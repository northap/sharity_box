//
//  NewAuctionViewController.h
//  SharityBox
//
//  Created by North on 5/29/2557 BE.
//  Copyright (c) 2557 North. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewAuctionViewController : UIViewController <NSXMLParserDelegate, UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate ,UIAlertViewDelegate>

@property (strong, nonatomic) IBOutlet UILabel *labelAuctionName;
@property (strong, nonatomic) IBOutlet UILabel *labelAuctionDes;
@property (strong, nonatomic) IBOutlet UILabel *labelAuctionCon;
@property (strong, nonatomic) IBOutlet UILabel *labelAuctionCat;
@property (strong, nonatomic) IBOutlet UILabel *labelAuctionStartPrice;
@property (strong, nonatomic) IBOutlet UILabel *labelAuctionPrice;
@property (strong, nonatomic) IBOutlet UILabel *labelAuctionImage;
@property (strong, nonatomic) IBOutlet UILabel *labelAuctionDonate;
@property (strong, nonatomic) IBOutlet UILabel *labelAuctionShipping;
@property (strong, nonatomic) IBOutlet UILabel *labelAuctionShipFee;
@property (strong, nonatomic) IBOutlet UILabel *labelAuctionEnd;

@property (strong, nonatomic) IBOutlet UILabel *labelAuctionDeliver;
@property (strong, nonatomic) IBOutlet UILabel *labelAuctionStart;
@property (strong, nonatomic) IBOutlet UILabel *labelAuctionBidCon;
@property (strong, nonatomic) IBOutlet UIButton *btnAddNewAuction;

@property (strong, nonatomic) IBOutlet UIButton *btnAuctionDonate;
- (IBAction)btnAuctionDonateClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *btnAuctionProCon;
@property (strong, nonatomic) IBOutlet UIButton *btnAuctionEnd;
- (IBAction)btnAuctionCategoryClicked:(id)sender;

- (IBAction)btnAuctionProConClicked:(id)sender;
- (IBAction)btnAuctionEndClicked:(id)sender;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollViewAuction;
@property (strong, nonatomic) IBOutlet UIButton *btnAuctionShipping;
- (IBAction)btnAuctionShippingClicked:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *btnAuctionBidding;
- (IBAction)btnAuctionBiddingClicked:(id)sender;

@property (strong, nonatomic) IBOutlet UIImageView *imageViewAuction1;
@property (strong, nonatomic) IBOutlet UIImageView *imageViewAuction2;
@property (strong, nonatomic) IBOutlet UIImageView *imageViewAuction3;
@property (strong, nonatomic) IBOutlet UIImageView *imageViewAuction4;
@property (strong, nonatomic) IBOutlet UIImageView *imageViewAuction5;
- (IBAction)btnAuctionDateClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *labelAuctionDate;
@property (strong, nonatomic) IBOutlet UIButton *btnAuctionDate;
- (IBAction)btnAddNewAuctionClicked:(id)sender;

@property (strong, nonatomic) IBOutlet UITextField *txtProductName;
@property (strong, nonatomic) IBOutlet UITextView *txtDescription;
@property (strong, nonatomic) IBOutlet UITextField *txtStartPrice;
@property (strong, nonatomic) IBOutlet UITextField *txtAuctionPrice;
@property (strong, nonatomic) IBOutlet UITextField *txtFee;
@property (strong, nonatomic) IBOutlet UITextField *txtDelivery;
@property (strong, nonatomic) IBOutlet UIButton *btnAuctionCategory;

@property UIDatePicker *datePicker;
@property UIBarButtonItem *doneDateButton;

@property UIActionSheet *actionSheetPhoto;
@property UIActionSheet *actionSheetProCon;
@property UIActionSheet *actionSheetDonate;
@property UIActionSheet *actionSheetShipping;
@property UIActionSheet *actionSheetBidCon;
@property UIActionSheet *actionSheetEndAuction;
@property UIActionSheet *actionSheetStartAuction;
@property UIActionSheet *actionSheetCategory1;
@property UIActionSheet *actionSheetCategory2;
@property UIActionSheet *actionSheetCategory3;

@end
