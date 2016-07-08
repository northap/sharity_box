//
//  ProductDetailViewController.h
//  SharityBox
//
//  Created by North on 5/9/2557 BE.
//  Copyright (c) 2557 North. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductDetailViewController : UIViewController <NSXMLParserDelegate, UITextFieldDelegate, UIAlertViewDelegate>
{
    BOOL pageControlBeingUsed;
}

@property (strong, nonatomic) IBOutlet UILabel *labelShippingFee;
@property (strong, nonatomic) IBOutlet UILabel *labelDelivery;
@property (strong, nonatomic) IBOutlet UIImageView *imageViewRank;
@property (strong, nonatomic) IBOutlet UILabel *labelRank;

@property (strong, nonatomic) IBOutlet UILabel *labelProductDetail;
@property (strong, nonatomic) IBOutlet UITextField *txtfieldProductDetailPrice;
@property (strong, nonatomic) IBOutlet UILabel *labelProductDetailTime;
@property (strong, nonatomic) IBOutlet UILabel *labelProductDetailPrice;
@property (strong, nonatomic) IBOutlet UILabel *labelProductDetailOwner;
@property (strong, nonatomic) IBOutlet UILabel *labelProductDetailUser;
@property (strong, nonatomic) IBOutlet UILabel *productDetailTime;
@property (strong, nonatomic) IBOutlet UILabel *productDetailPrice;
@property (strong, nonatomic) IBOutlet UILabel *productDetailOwner;
@property (strong, nonatomic) IBOutlet UILabel *productDetailUser;
@property (strong, nonatomic) IBOutlet UILabel *productDetailName;
@property (strong, nonatomic) IBOutlet UIButton *btnBid;
@property (strong, nonatomic) IBOutlet UILabel *productDetailDesc;

@property (strong, nonatomic) NSString *productDetailId;
@property (strong, nonatomic) IBOutlet UILabel *labelProductDetailShipping;
@property (strong, nonatomic) IBOutlet UILabel *labelProductDetailCondition;
@property (strong, nonatomic) IBOutlet UILabel *productDetailShipping;
@property (strong, nonatomic) IBOutlet UILabel *productDetailCondition;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollViewProductDetail;
@property (strong, nonatomic) IBOutlet UIView *subViewDetail;

- (IBAction)btnBidClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControlPhoto;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollViewPhoto;
- (IBAction)changedPage:(id)sender;

@end
