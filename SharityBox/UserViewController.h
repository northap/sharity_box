//
//  UserViewController.h
//  SharityBox
//
//  Created by North on 6/22/2557 BE.
//  Copyright (c) 2557 North. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *imageViewRank;
@property (strong, nonatomic) IBOutlet UILabel *labelRank;

@property (strong, nonatomic) NSString *userId;
@property (strong, nonatomic) IBOutlet UIButton *btnCatSharing;

- (IBAction)btnCatSharingClicked:(id)sender;

@property (strong, nonatomic) IBOutlet UITableView *tableSharing;
@property (strong, nonatomic) IBOutlet UIImageView *imageViewAvatar;
@property (strong, nonatomic) IBOutlet UILabel *userName;
@property (strong, nonatomic) IBOutlet UILabel *labelPositive;
@property (strong, nonatomic) IBOutlet UILabel *labelNatural;
@property (strong, nonatomic) IBOutlet UILabel *labelNegative;
@property (strong, nonatomic) IBOutlet UILabel *userPoint;

@property UIActionSheet *actionSheetSharing;

@property NSCache *imageCache;
@property NSOperationQueue *imageDownloadingQueue;
@property NSTimer *timer;

@end
