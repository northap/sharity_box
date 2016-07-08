//
//  MeViewController.h
//  SharityBox
//
//  Created by North on 5/8/2557 BE.
//  Copyright (c) 2557 North. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MeViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate, UITabBarControllerDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *imageViewRank;
@property (strong, nonatomic) IBOutlet UILabel *labelRank;

@property (strong, nonatomic) IBOutlet UILabel *userName;
@property (strong, nonatomic) IBOutlet UILabel *userPoint;
@property (strong, nonatomic) IBOutlet UILabel *labelUserPoint;
@property (strong, nonatomic) IBOutlet UISegmentedControl *menuUser;
@property (strong, nonatomic) IBOutlet UIImageView *imageViewAvatar;
- (IBAction)btnCatSharingClicked:(id)sender;
- (IBAction)btnCatBiddingClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *btnCatBidding;
@property (strong, nonatomic) IBOutlet UIButton *btnCatSharing;
@property (strong, nonatomic) IBOutlet UILabel *labelPositive;
@property (strong, nonatomic) IBOutlet UILabel *labelNatural;
@property (strong, nonatomic) IBOutlet UILabel *labelNegative;

@property (strong, nonatomic) IBOutlet UITableView *productTable;
- (IBAction)menuUserClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *viewSharing;
@property (strong, nonatomic) IBOutlet UITableView *tableSharing;
@property (strong, nonatomic) IBOutlet UIView *viewBidding;
@property (strong, nonatomic) IBOutlet UITableView *tableBidding;

@property UIActionSheet *actionSheetBidding;
@property UIActionSheet *actionSheetSharing;
@property NSCache *imageCache;
@property NSOperationQueue *imageDownloadingQueue;
@property NSTimer *timer;

@end
