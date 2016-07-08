//
//  SecondViewController.h
//  SharityBox
//
//  Created by North on 5/8/2557 BE.
//  Copyright (c) 2557 North. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchViewController : UIViewController <UIActionSheetDelegate>
@property (strong, nonatomic) IBOutlet UILabel *labelSearchKeyword;
@property (strong, nonatomic) IBOutlet UILabel *labelSearshFoundation;
@property (strong, nonatomic) IBOutlet UIButton *btnSearch;
@property (strong, nonatomic) IBOutlet UIButton *dropDownFoundation;
- (IBAction)dropDownFoundationClicked:(id)sender;
- (IBAction)btnSearchClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *labelSearchResult;
@property (strong, nonatomic) IBOutlet UITextField *txtSearchKeyword;
@property (strong, nonatomic) IBOutlet UITableView *tableViewSearch;
@property NSCache *imageCache;
@property NSOperationQueue *imageDownloadingQueue;
@property NSTimer *timer;
@end
