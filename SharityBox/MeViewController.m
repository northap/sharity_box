//
//  MeViewController.m
//  SharityBox
//
//  Created by North on 5/8/2557 BE.
//  Copyright (c) 2557 North. All rights reserved.
//

#import "MeViewController.h"
#import "AppDelegate.h"
#import "ProductTableViewCell.h"
#import <QuartzCore/QuartzCore.h>
#import "ProductDetailViewController.h"
#import "MBProgressHUD.h"
#import "OpenDisputeViewController.h"
#import "ResponseViewController.h"
#import "FeedbackViewController.h"
#import "ShippingViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "AttitudeTableViewController.h"

@interface MeViewController ()
{
    AppDelegate *appDelegate;
    
    NSMutableArray *myObject;
    NSMutableArray *myBiddingOn;
    NSMutableArray *myBiddingWon;
    NSMutableArray *myBiddingNotWon;
    NSMutableArray *mySharingNoActive;
    NSMutableArray *mySharingActive;
    NSMutableArray *mySharingSold;
    NSMutableArray *mySharingUnSold;
    
    NSDictionary *dict;
    
    NSString *image;
    NSString *name;
    NSString *price;
    NSString *time;
    NSString *productId;
    NSString *orderStatus;
    NSString *auctionId;
    NSString *orderId;
    NSString *trackingCode;
    NSString *trackingBackCode;
    NSString *bidderCount;
    
    NSMutableArray *myBidding;
    NSMutableArray *mySharing;
    
    NSString *tmpBidding;
    NSString *tmpSharing;
    
    bool isLoadBidding;
    bool isLoadSharing;
    
    int countRefresh;
    
    bool isRefreshData;
}
@end

@implementation MeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.imageDownloadingQueue = [[NSOperationQueue alloc] init];
    self.imageDownloadingQueue.maxConcurrentOperationCount = 4;
    self.imageCache = [[NSCache alloc] init];
    
    _productTable.tableHeaderView = nil;
    [_productTable setHidden:FALSE];
    [_viewSharing setHidden:TRUE];
    [_viewBidding setHidden:TRUE];
    
    [_imageViewAvatar setClipsToBounds:YES];
    
    appDelegate = [[UIApplication sharedApplication] delegate];

    image = @"image_file";
    name = @"product_name";
    price = @"auction_last_price";
    time = @"auction_end_date";
    productId = @"product_id";
    orderStatus = @"order_status";
    auctionId = @"auction_id";
    orderId = @"order_id";
    trackingCode = @"tracking_code";
    trackingBackCode = @"tracking_back_code";
    bidderCount = @"bidder_count";
    
    myObject = [[NSMutableArray alloc] init];
    myBiddingOn = [[NSMutableArray alloc] init];
    myBiddingWon = [[NSMutableArray alloc] init];
    myBiddingNotWon = [[NSMutableArray alloc] init];
    mySharingActive = [[NSMutableArray alloc] init];
    mySharingNoActive = [[NSMutableArray alloc] init];
    mySharingSold = [[NSMutableArray alloc] init];
    mySharingUnSold = [[NSMutableArray alloc] init];
    myBidding = [[NSMutableArray alloc] init];
    mySharing = [[NSMutableArray alloc] init];
    
    _productTable.separatorColor = [UIColor clearColor];
    _tableBidding.separatorColor = [UIColor clearColor];
    _tableSharing.separatorColor = [UIColor clearColor];
    _productTable.backgroundColor = [UIColor colorWithRed:243.0f/255.0f green:243.0f/255.0f blue:243.0f/255.0f alpha:1.0f];
    _tableBidding.backgroundColor = [UIColor colorWithRed:243.0f/255.0f green:243.0f/255.0f blue:243.0f/255.0f alpha:1.0f];
    _tableSharing.backgroundColor = [UIColor colorWithRed:243.0f/255.0f green:243.0f/255.0f blue:243.0f/255.0f alpha:1.0f];
    
    [appDelegate changeFontOfView:self.view :@"Thai Sans Lite"];
    
    [self defineSegmentControlStyle];
    
    [myBidding addObject:@"View All"];
    [myBidding addObject:@"On Bidding"];
    [myBidding addObject:@"Won"];
    [myBidding addObject:@"Don't Won"];
    
    [mySharing addObject:@"View All"];
    [mySharing addObject:@"Non Active"];
    [mySharing addObject:@"Active Bidding"];
    [mySharing addObject:@"Sold"];
    [mySharing addObject:@"Unsold"];
    
    tmpBidding = @"View All";
    tmpSharing = @"View All";
    
    UITapGestureRecognizer *tapGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(attitudeTapped)];
    UITapGestureRecognizer *tapGesture2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(attitudeTapped)];
    UITapGestureRecognizer *tapGesture3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(attitudeTapped)];
    
    self.labelNatural.userInteractionEnabled = YES;
    self.labelNegative.userInteractionEnabled = YES;
    self.labelPositive.userInteractionEnabled = YES;
    
    [self.labelPositive addGestureRecognizer:tapGesture1];
    [self.labelNegative addGestureRecognizer:tapGesture2];
    [self.labelNatural addGestureRecognizer:tapGesture3];
    
    [self loadProfile];

    [self startTimer];
    
}

-(void)attitudeTapped
{
    UIStoryboard *storyboard = self.navigationController.storyboard;
    AttitudeTableViewController *attitude = [storyboard instantiateViewControllerWithIdentifier:@"AttitudeTableView"];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *userId = [prefs objectForKey:@"userId"];
    
    attitude.userId = userId;
    attitude.userName = _userName.text;
    
    [self.navigationController pushViewController:attitude animated:YES];
}

-(void)defineSegmentControlStyle
{
    //normal segment
    NSDictionary *normalAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                      [UIFont fontWithName:@"Thai Sans Lite" size:17],UITextAttributeFont, nil];
    [_menuUser setTitleTextAttributes:normalAttributes forState:UIControlStateNormal];
    
    NSDictionary *selectedAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [UIFont fontWithName:@"Thai Sans Lite" size:17],UITextAttributeFont,
                                        [UIColor whiteColor], UITextAttributeTextColor,
                                        [UIColor clearColor], UITextAttributeTextShadowColor,
                                        [NSValue valueWithUIOffset:UIOffsetMake(0, 1)], UITextAttributeTextShadowOffset,
                                        nil];
    [_menuUser setTitleTextAttributes:selectedAttributes forState:UIControlStateSelected];
    
}

-(void)startTimer
{
    if (!_timer) {
        countRefresh = 0;
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateCounter:) userInfo:nil repeats:YES];
    }
}

-(void)updateCounter:(NSTimer *)theTimer
{
    countRefresh += 1;
    if (countRefresh >= TIMER_REFRESH)
    {
        countRefresh = 0;
        if (!_viewBidding.hidden) {
            [self loadBidding:@"BIDDING"];
            [self loadBidding:@"WON"];
            [self loadBidding:@"NOTWON"];
        }
        
        if (!_viewSharing.hidden) {
            [self loadSharing:@"NOTACTIVE"];
            [self loadSharing:@"ACTIVE"];
            [self loadSharing:@"SOLD"];
            [self loadSharing:@"UNSOLD"];
        }
        
        if (!_productTable.hidden) {
            [self loadWatching];
        }
    }

    [self.productTable reloadData];
    [self.tableBidding reloadData];
    [self.tableSharing reloadData];
}

-(void)loadProfile
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    NSString *userId = [prefs objectForKey:@"userId"];

    NSURL *jsonURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/user/index/id/%@.json?x-api-key=%@", BASE_URL, userId, API_KEY]];
    NSData *jsonData = [NSData dataWithContentsOfURL:jsonURL];
    
    id jsonObjects = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    
     NSString *error = [jsonObjects objectForKey:@"error"];
    
    if (error)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:error delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        NSString *first = [jsonObjects objectForKey:@"user_first_name"];
        NSString *last = [jsonObjects objectForKey:@"user_last_name"];
        _userName.text = [NSString stringWithFormat:@"%@ %@", first, last];
        NSString *point = [jsonObjects objectForKey:@"user_point"];
        _userPoint.text = [NSString stringWithFormat:@"%@", point];
        NSString *rank = [jsonObjects objectForKey:@"user_rank"];
        _labelRank.text = [NSString stringWithFormat:@"(%@)", rank];
        
        _labelPositive.attributedText = [appDelegate getUnderline:[NSString stringWithFormat:@"%@ Positive", [jsonObjects objectForKey:@"user_positive"]]];
        _labelNatural.attributedText = [appDelegate getUnderline:[NSString stringWithFormat:@"%@ Natural", [jsonObjects objectForKey:@"user_natural"]]];
        _labelNegative.attributedText = [appDelegate getUnderline:[NSString stringWithFormat:@"%@ Negative", [jsonObjects objectForKey:@"user_nagative"]]];
        
        NSString *imName =[[NSString alloc] initWithFormat:@"%@/files/avatar_images/%@", BASE_URL, [jsonObjects objectForKey:@"user_avatar"]];
        NSData *imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:imName]];
        _imageViewAvatar.image = [[UIImage alloc] initWithData:imageData];
        
        _imageViewRank.image = [UIImage imageNamed:[appDelegate getRankImage:rank]];
        
        CALayer *imageLayer = _imageViewAvatar.layer;
        [imageLayer setCornerRadius:_imageViewAvatar.frame.size.width/2];
        [imageLayer setMasksToBounds:YES];
    }
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

-(void)loadWatching
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    NSString *userId = [prefs objectForKey:@"userId"];
    
    NSURL *jsonURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/user/favorite/id/%@.json?x-api-key=%@", BASE_URL, userId, API_KEY]];
    NSData *jsonData = [NSData dataWithContentsOfURL:jsonURL];
    
    id jsonObjects = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    
    [myObject removeAllObjects];
    
    @try {
        for (NSDictionary *dataDict in jsonObjects)
        {
            NSString *strImage = [NSString stringWithFormat:@"%@", [dataDict objectForKey:image]];
            NSString *strName = [NSString stringWithFormat:@"%@", [dataDict objectForKey:name]];
            NSString *strPrice = [NSString stringWithFormat:@"%@", [dataDict objectForKey:price]];
            NSString *strTime = [NSString stringWithFormat:@"%@", [dataDict objectForKey:time]];
            NSString *strProductId = ([dataDict objectForKey:productId]) ? [dataDict objectForKey:productId] : [NSNull null];
            NSString *strBidderCount = [NSString stringWithFormat:@"%@", [dataDict objectForKey:bidderCount]];
            
            dict = [NSDictionary dictionaryWithObjectsAndKeys:
                    strImage, image,
                    strName, name,
                    strPrice, price,
                    strTime, time,
                    strProductId, productId,
                    strBidderCount, bidderCount,
                    nil];
            [myObject addObject:dict];
        }
    }
    @catch (NSException *exception)
    {
        //NSString *error = [jsonObjects objectForKey:@"error"];
        
        //UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:error delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        //[alert show];
    }
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

-(void)loadBidding:(NSString*)status
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    NSString *userId = [prefs objectForKey:@"userId"];
    
    NSURL *jsonURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/user/bidding/id/%@/status/%@.json?x-api-key=%@", BASE_URL, userId, status, API_KEY]];
    NSData *jsonData = [NSData dataWithContentsOfURL:jsonURL];
    
    id jsonObjects = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    
    if ([status isEqualToString:@"BIDDING"]) {
        [myBiddingOn removeAllObjects];
    }
    else if ([status isEqualToString:@"WON"]) {
        [myBiddingWon removeAllObjects];
    }
    else if ([status isEqualToString:@"NOTWON"]) {
        [myBiddingNotWon removeAllObjects];
    }
    
    @try {
        for (NSDictionary *dataDict in jsonObjects)
        {
            NSString *strImage = [NSString stringWithFormat:@"%@", [dataDict objectForKey:image]];
            NSString *strName = [NSString stringWithFormat:@"%@", [dataDict objectForKey:name]];
            NSString *strPrice = [NSString stringWithFormat:@"%@", [dataDict objectForKey:price]];
            NSString *strTime = [NSString stringWithFormat:@"%@", [dataDict objectForKey:time]];
            NSString *strProductId = ([dataDict objectForKey:productId]) ? [dataDict objectForKey:productId] : [NSNull null];
            NSString *strOrderStatus = ([dataDict objectForKey:orderStatus]) ? [dataDict objectForKey:orderStatus] : [NSNull null];
            NSString *strAuctionId = ([dataDict objectForKey:auctionId]) ? [dataDict objectForKey:auctionId] : [NSNull null];
            NSString *strOrderId = ([dataDict objectForKey:orderId]) ? [dataDict objectForKey:orderId] : [NSNull null];
            NSString *strTrackingCode = ([dataDict objectForKey:trackingCode]) ? [dataDict objectForKey:trackingCode] : [NSNull null];
            NSString *strTrackingBackCode = ([dataDict objectForKey:trackingBackCode]) ? [dataDict objectForKey:trackingBackCode] : [NSNull null];
            NSString *strBidderCount = [NSString stringWithFormat:@"%@", [dataDict objectForKey:bidderCount]];
            
            dict = [NSDictionary dictionaryWithObjectsAndKeys:
                    strImage, image,
                    strName, name,
                    strPrice, price,
                    strTime, time,
                    strProductId, productId,
                    strOrderStatus, orderStatus,
                    strAuctionId, auctionId,
                    strOrderId, orderId,
                    strTrackingCode, trackingCode,
                    strTrackingBackCode, trackingBackCode,
                    strBidderCount, bidderCount,
                    nil];

            if ([status isEqualToString:@"BIDDING"]) {
                [myBiddingOn addObject:dict];
            }
            else if ([status isEqualToString:@"WON"]) {
                [myBiddingWon addObject:dict];
            }
            else if ([status isEqualToString:@"NOTWON"]) {
                [myBiddingNotWon addObject:dict];
            }
        }
    }
    @catch (NSException *exception)
    {
        //NSString *error = [jsonObjects objectForKey:@"error"];
        
        //UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:error delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        //[alert show];
    }
    
    if ([status isEqualToString:@"BIDDING"]) {
        NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:time ascending:YES];
        NSArray *sortObject = [myBiddingOn sortedArrayUsingDescriptors:[NSArray arrayWithObjects:descriptor, nil]];
        myBiddingOn = [NSMutableArray arrayWithArray:sortObject];
    }
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

-(void)loadSharing:(NSString*)status
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    NSString *userId = [prefs objectForKey:@"userId"];
    
    NSURL *jsonURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/user/sharing/id/%@/status/%@.json?x-api-key=%@", BASE_URL, userId, status, API_KEY]];
    NSData *jsonData = [NSData dataWithContentsOfURL:jsonURL];
    
    id jsonObjects = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    
    if ([status isEqualToString:@"NOTACTIVE"]) {
        [mySharingNoActive removeAllObjects];
    }
    else if ([status isEqualToString:@"ACTIVE"]) {
        [mySharingActive removeAllObjects];
    }
    else if ([status isEqualToString:@"SOLD"]) {
        [mySharingSold removeAllObjects];
    }
    else if ([status isEqualToString:@"UNSOLD"]) {
        [mySharingUnSold removeAllObjects];
    }
    
    @try {
        for (NSDictionary *dataDict in jsonObjects)
        {
            NSString *strImage = [NSString stringWithFormat:@"%@", [dataDict objectForKey:image]];
            NSString *strName = [NSString stringWithFormat:@"%@", [dataDict objectForKey:name]];
            NSString *strPrice = [NSString stringWithFormat:@"%@", [dataDict objectForKey:price]];
            NSString *strTime = [NSString stringWithFormat:@"%@", [dataDict objectForKey:time]];
            NSString *strProductId = ([dataDict objectForKey:productId]) ? [dataDict objectForKey:productId] : [NSNull null];
            NSString *strOrderStatus = ([dataDict objectForKey:orderStatus]) ? [dataDict objectForKey:orderStatus] : [NSNull null];
            NSString *strAuctionId = ([dataDict objectForKey:auctionId]) ? [dataDict objectForKey:auctionId] : [NSNull null];
            NSString *strOrderId = ([dataDict objectForKey:orderId]) ? [dataDict objectForKey:orderId] : [NSNull null];
            NSString *strTrackingCode = ([dataDict objectForKey:trackingCode]) ? [dataDict objectForKey:trackingCode] : [NSNull null];
            NSString *strTrackingBackCode = ([dataDict objectForKey:trackingBackCode]) ? [dataDict objectForKey:trackingBackCode] : [NSNull null];
            NSString *strBidderCount = [NSString stringWithFormat:@"%@", [dataDict objectForKey:bidderCount]];
            
            dict = [NSDictionary dictionaryWithObjectsAndKeys:
                    strImage, image,
                    strName, name,
                    strPrice, price,
                    strTime, time,
                    strProductId, productId,
                    strOrderStatus, orderStatus,
                    strAuctionId, auctionId,
                    strOrderId, orderId,
                    strTrackingCode, trackingCode,
                    strTrackingBackCode, trackingBackCode,
                    strBidderCount, bidderCount,
                    nil];
            
            if ([status isEqualToString:@"NOTACTIVE"]) {
                [mySharingNoActive addObject:dict];
            }
            else if ([status isEqualToString:@"ACTIVE"]) {
                [mySharingActive addObject:dict];
            }
            else if ([status isEqualToString:@"SOLD"]) {
                [mySharingSold addObject:dict];
            }
            else if ([status isEqualToString:@"UNSOLD"]) {
                [mySharingUnSold addObject:dict];
            }
        }
    }
    @catch (NSException *exception)
    {
        //NSString *error = [jsonObjects objectForKey:@"error"];
        
        //UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:error delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        //[alert show];
    }
    
    if ([status isEqualToString:@"ACTIVE"]) {
        NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:time ascending:YES];
        NSArray *sortObject = [mySharingActive sortedArrayUsingDescriptors:[NSArray arrayWithObjects:descriptor, nil]];
        mySharingActive = [NSMutableArray arrayWithArray:sortObject];
    }
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

-(void)viewDidAppear:(BOOL)animated {
    if (!_viewBidding.hidden) {
        [self loadBidding:@"BIDDING"];
        [self loadBidding:@"WON"];
        [self loadBidding:@"NOTWON"];
        [_tableBidding reloadData];
    }
    
    if (!_viewSharing.hidden) {
        [self loadSharing:@"NOTACTIVE"];
        [self loadSharing:@"ACTIVE"];
        [self loadSharing:@"SOLD"];
        [self loadSharing:@"UNSOLD"];
        [_tableSharing reloadData];
    }
    
    if (!_productTable.hidden) {
        [self loadWatching];
        [_productTable reloadData];
    }
}

-(void)viewWillAppear:(BOOL)animated {
    self.tabBarController.navigationItem.titleView = [appDelegate addTitleApp:@"Profile"];
    self.tabBarController.navigationItem.hidesBackButton = YES;
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc]
                                  initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addAuctionView)];
    
    UIImage *imageSet = [UIImage imageNamed:@"setting_icon.png"];
    CGRect frame = CGRectMake(0, 0, imageSet.size.width, imageSet.size.height);
    
    UIButton *button = [[UIButton alloc] initWithFrame:frame];
    [button setBackgroundImage:imageSet forState:UIControlStateNormal];
    [button addTarget:self action:@selector(settingClicked) forControlEvents:UIControlEventTouchUpInside ];
    
    UIBarButtonItem *logOutButton = [[UIBarButtonItem alloc]
                                     initWithCustomView:button];
    
    self.tabBarController.navigationItem.rightBarButtonItems = [[NSArray alloc] initWithObjects:logOutButton, addButton, nil];
    
    self.tabBarController.delegate = self;

}

-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    
    if ([viewController class] == [self class]) {
        if (isRefreshData) {
            if (!_viewBidding.hidden) {
                [self loadBidding:@"BIDDING"];
                [self loadBidding:@"WON"];
                [self loadBidding:@"NOTWON"];
                [_tableBidding reloadData];
            }
            
            if (!_viewSharing.hidden) {
                [self loadSharing:@"NOTACTIVE"];
                [self loadSharing:@"ACTIVE"];
                [self loadSharing:@"SOLD"];
                [self loadSharing:@"UNSOLD"];
                [_tableSharing reloadData];
            }
            
            if (!_productTable.hidden) {
                [self loadWatching];
                [_productTable reloadData];
            }
        }
        
        isRefreshData = YES;
    }
    else
    {
        isRefreshData = NO;
    }
}

-(void)settingClicked
{
    UIStoryboard *storyboard = self.navigationController.storyboard;
    UIViewController *setting = [storyboard instantiateViewControllerWithIdentifier:@"Setting"];
    [self.navigationController pushViewController:setting animated:YES];
}

-(void)addAuctionView
{
    UIStoryboard *storyboard = self.navigationController.storyboard;
    UIViewController *addAuction = [storyboard instantiateViewControllerWithIdentifier:@"AddNewAuction"];
    [self.navigationController pushViewController:addAuction animated:YES];
}

- (UIView *)addTitleIconApp
{
    UILabel *tmpTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(85, 7, 110, 20)];
    tmpTitleLabel.text = @"Product Detail";
    tmpTitleLabel.font = [UIFont fontWithName:@"Century Gothic" size:16];
    tmpTitleLabel.backgroundColor = [UIColor clearColor];
    tmpTitleLabel.textColor = [UIColor whiteColor];
    
    CGRect applicationFrame = CGRectMake(00, 0, 300, 40);
    UIView *newView = [[UIView alloc] initWithFrame:applicationFrame];
    [newView addSubview:tmpTitleLabel];
    return newView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == _productTable) {
        return 0;
    }
    else if (tableView == _tableBidding) {
        if ([tmpBidding isEqualToString:@"View All"]){
            switch (section) {
                case 0:
                    if ([myBiddingOn count] > 0) {
                        return 27;
                    }
                    else {
                        return  0;
                    }
                case 1:
                    if ([myBiddingWon count] > 0) {
                        return 27;
                    }
                    else {
                        return 0;
                    }
                case 2:
                    if ([myBiddingNotWon count] > 0) {
                        return 27;
                    }
                    else {
                        return 0;
                    }
            }
        }
        else {
            return 0;
        }
    }
    else if (tableView == _tableSharing) {
        if ([tmpSharing isEqualToString:@"View All"]){
            switch (section) {
                case 0:
                    if ([mySharingNoActive count] > 0) {
                        return 27;
                    }
                    else {
                        return 0;
                    }
                case 1:
                    if ([mySharingActive count] > 0) {
                        return 27;
                    }
                    else {
                        return 0;
                    }
                case 2:
                    if ([mySharingSold count] > 0) {
                        return 27;
                    }
                    else {
                        return 0;
                    }
                case 3:
                    if ([mySharingUnSold count] > 0) {
                        return 27;
                    }
                    else {
                        return 0;
                    }
            }
        }
        else {
            return 0;
        }
    }
    
    return 0;
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 18)];
    /* Create custom view to display section header... */
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, tableView.frame.size.width, 18)];
    [label setFont:[UIFont fontWithName:@"Thai Sans Lite" size:14]];
    
    NSString *string;
    
    if (tableView == _productTable) {
        return nil;
    }
    else if (tableView == _tableBidding) {
        if ([tmpBidding isEqualToString:@"View All"]){
            switch (section) {
                case 0:
                    if ([myBiddingOn count] > 0) {
                        string = @"On Bidding";
                    }
                    else {
                        return  nil;
                    }
                    break;
                case 1:
                    if ([myBiddingWon count] > 0) {
                        string = @"Won";
                    }
                    else {
                        return nil;
                    }
                    break;
                case 2:
                    if ([myBiddingNotWon count] > 0) {
                        string = @"Don't Won";
                    }
                    else {
                        return nil;
                    }
                    break;
            }
        }
        else {
            return nil;
        }
    }
    else if (tableView == _tableSharing) {
        if ([tmpSharing isEqualToString:@"View All"]){
            switch (section) {
                case 0:
                    if ([mySharingNoActive count] > 0) {
                        string = @"Non Active";
                    }
                    else {
                        return nil;
                    }
                    break;
                case 1:
                    if ([mySharingActive count] > 0) {
                        string = @"Active Bidding";
                    }
                    else {
                        return nil;
                    }
                    break;
                case 2:
                    if ([mySharingSold count] > 0) {
                        string = @"Sold";
                    }
                    else {
                        return nil;
                    }
                    break;
                case 3:
                    if ([mySharingUnSold count] > 0) {
                         string = @"Unsold";
                    }
                    else {
                        return nil;
                    }
                    break;
            }
        }
        else {
            return nil;
        }
    }
    
    [label setText:string];
    [view addSubview:label];

    [view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"header_list_bg.png"]]];
    
    return view;
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == _productTable) {
        return 1;
    }
    else if (tableView == _tableBidding) {
        if ([tmpBidding isEqualToString:@"View All"]){
            return 3;
        }
        else {
            return 1;
        }
    }
    else if (tableView == _tableSharing) {
        if ([tmpSharing isEqualToString:@"View All"]){
            return 4;
        }
        else {
            return 1;
        }
    }
    else {
        return 0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _productTable) {
            return myObject.count;
    }
    else if (tableView == _tableBidding){
        if ([tmpBidding isEqualToString:@"View All"]){
            switch (section) {
                case 0:
                    return [myBiddingOn count];
                case 1:
                    return [myBiddingWon count];
                case 2:
                    return [myBiddingNotWon  count];
                default:
                    return 0;
            }
        }
        else if ([tmpBidding isEqualToString:@"On Bidding"]){
            return [myBiddingOn count];
        }
        else if ([tmpBidding isEqualToString:@"Won"]){
            return [myBiddingWon count];
        }
        else if ([tmpBidding isEqualToString:@"Don't Won"]){
            return [myBiddingNotWon count];
        }
        else return  0;
    }
    else if (tableView == _tableSharing){
        if ([tmpSharing isEqualToString:@"View All"]){
            switch (section) {
                case 0:
                    return [mySharingNoActive count];
                case 1:
                    return [mySharingActive count];
                case 2:
                    return [mySharingSold  count];
                case 3:
                    return [mySharingUnSold  count];
                default:
                    return 0;
            }
        }
        else if ([tmpSharing isEqualToString:@"Non Active"]){
            return [mySharingNoActive count];
        }
        else if ([tmpSharing isEqualToString:@"Active Bidding"]){
            return [mySharingActive count];
        }
        else if ([tmpSharing isEqualToString:@"Sold"]){
            return [mySharingSold count];
        }
        else if ([tmpSharing isEqualToString:@"Unsold"]){
            return [mySharingUnSold count];
        }
        else return  0;
    }
    else {
        return 0;
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    
    ProductTableViewCell *cell = (ProductTableViewCell *) [tableView dequeueReusableCellWithIdentifier : CellIdentifier];
    
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ProductTableCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    NSDictionary *tmpDict;
    
    if (tableView == _productTable) {
        tmpDict = [myObject objectAtIndex:indexPath.row];
        
        [cell.btnWatch setTitle:@"Watching" forState:UIControlStateNormal];
        
        cell.btnBid.tag = indexPath.row;
        [cell.btnBid addTarget:self action:@selector(btnBidClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.btnWatch.tag = indexPath.row;
        [cell.btnWatch addTarget:self action:@selector(btnRemoveWatchClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    else if (tableView == _tableBidding) {
        if ([tmpBidding isEqualToString:@"View All"]){
            switch (indexPath.section) {
                case 0:
                    tmpDict = [self setBiddingOn:tmpDict :cell :indexPath];
                    break;
                case 1:
                    tmpDict = [self setBiddingWon:tmpDict :cell :indexPath];
                    break;
                case 2:
                    tmpDict = [self setBiddingNotWon:tmpDict :cell :indexPath];
                    break;
                default:
                    break;
            }
        }
        else if ([tmpBidding isEqualToString:@"On Bidding"]){
            tmpDict = [self setBiddingOn:tmpDict :cell :indexPath];
        }
        else if ([tmpBidding isEqualToString:@"Won"]){
            tmpDict = [self setBiddingWon:tmpDict :cell :indexPath];
        }
        else if ([tmpBidding isEqualToString:@"Don't Won"]){
            tmpDict = [self setBiddingNotWon:tmpDict :cell :indexPath];
        }
    }
    else if (tableView == _tableSharing) {
        if ([tmpSharing isEqualToString:@"View All"]){
            switch (indexPath.section) {
                case 0:
                    tmpDict = [self setSharingNoActive:tmpDict :cell :indexPath];
                    break;
                case 1:
                    tmpDict = [self setSharingActive:tmpDict :cell :indexPath];
                    break;
                case 2:
                    tmpDict = [self setSharingSold:tmpDict :cell :indexPath];
                    break;
                case 3:
                    tmpDict = [self setSharingUnSold:tmpDict :cell :indexPath];
                    break;
                default:
                    break;
            }
        }
        else if ([tmpSharing isEqualToString:@"Non Active"]){
            tmpDict = [self setSharingNoActive:tmpDict :cell :indexPath];
        }
        else if ([tmpSharing isEqualToString:@"Active Bidding"]){
            tmpDict = [self setSharingActive:tmpDict :cell :indexPath];
        }
        else if ([tmpSharing isEqualToString:@"Sold"]){
            tmpDict = [self setSharingSold:tmpDict :cell :indexPath];
        }
        else if ([tmpSharing isEqualToString:@"Unsold"]){
            tmpDict = [self setSharingUnSold:tmpDict :cell :indexPath];
        }
        
        [cell.btnBid setHidden:YES];
        [cell.btnWatch setHidden:YES];
    }
    
    NSString *imName =[[NSString alloc] initWithFormat:@"%@/files/product_images/%@", BASE_URL, [tmpDict objectForKey:image]];
    
    UIImage *imageProduct = [_imageCache objectForKey:imName];
    
    if (imageProduct) {
        cell.productImage.image = imageProduct;
    }
    else {
        [self.imageDownloadingQueue addOperationWithBlock:^{
            NSData *imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:imName]];
            
            UIImage *imageProduct = nil;
            if (imageData) {
                imageProduct = [UIImage imageWithData:imageData];
            }
            
            if (imageProduct) {
                [self.imageCache setObject:imageProduct forKey:imName];
                
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    UITableViewCell *updateCell = [tableView cellForRowAtIndexPath:indexPath];
                    if (updateCell) {
                        cell.productImage.image = imageProduct;
                    }
                }];
            }
        }];
    }

    cell.productName.text = [tmpDict objectForKey:name];
    cell.productPrice.text = [NSString stringWithFormat: @"฿ %@",[tmpDict objectForKey:price]];
    
    CGFloat widthPrice = [appDelegate widthOfString:cell.productPrice.text withFont:[UIFont fontWithName:@"Thai Sans Lite" size:14]];
    CGFloat diffLength = widthPrice - cell.productPrice.frame.size.width;
    CGRect rectPrice = CGRectMake(cell.productPrice.frame.origin.x, cell.productPrice.frame.origin.y, widthPrice, cell.productPrice.frame.size.height);
    cell.productPrice.frame = rectPrice;
    
    cell.productBids.text = [NSString stringWithFormat: @"   (%@ Bids)", [tmpDict objectForKey:bidderCount]];
    CGRect rectBids = CGRectMake(cell.productBids.frame.origin.x + diffLength, cell.productBids.frame.origin.y, cell.productBids.frame.size.width, cell.productBids.frame.size.height);
    cell.productBids.frame = rectBids;
    
    NSTimeInterval timeIn = [[tmpDict objectForKey:time] doubleValue];
    
    NSDate *futureDate = [NSDate dateWithTimeIntervalSince1970:timeIn];

    NSString *result = [appDelegate getCountTime:futureDate];
    
    cell.productTime.text = result;
    cell.productTime.textColor = [appDelegate getColorTime:futureDate];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(NSDictionary*)setBiddingOn:(NSDictionary*)tmpDict :(ProductTableViewCell*)cell :(NSIndexPath *)indexPath
{
    tmpDict = [myBiddingOn objectAtIndex:indexPath.row];
    
    [cell.labelTime setHidden:NO];
    [cell.productTime setHidden:NO];
    [cell.btnBid setHidden:NO];
    [cell.btnWatch setHidden:NO];
    
    cell.btnBid.tag = indexPath.row;
    [cell.btnBid addTarget:self action:@selector(btnBidClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.btnWatch.tag = indexPath.row;
    [cell.btnWatch addTarget:self action:@selector(btnAddWatchClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    return tmpDict;
}

-(NSDictionary*)setBiddingWon:(NSDictionary*)tmpDict :(ProductTableViewCell*)cell :(NSIndexPath *)indexPath
{
    tmpDict = [myBiddingWon objectAtIndex:indexPath.row];
    
    [cell.labelTime setHidden:YES];
    [cell.productTime setHidden:YES];
    [cell.btnBid setHidden:YES];
    [cell.btnWatch setHidden:YES];
    
    int code = [[tmpDict objectForKey:orderStatus] intValue];
    
    if (code >= 1) {
        [cell.labelOrderCode setText:[NSString stringWithFormat:@"Order #%@", [self convertStatusId:[tmpDict objectForKey:orderId]]]];
        [cell.labelOrderCode setHidden:NO];
    }

    if (code >= 4) {
        if ([[tmpDict objectForKey:trackingBackCode] isEqual:[NSNull null]])
            [cell.labelTrackingCode setText:[NSString stringWithFormat:@"Tracking Number %@", [tmpDict objectForKey:trackingCode]]];
        else
            [cell.labelTrackingCode setText:[NSString stringWithFormat:@"Tracking Number %@", [tmpDict objectForKey:trackingBackCode]]];
       [cell.labelTrackingCode setHidden:NO];
    }
    
    [cell.labelOrderStatus setText:[self getStatusName:code :YES]];
    cell.productName.frame = CGRectMake(cell.productName.frame.origin.x, cell.productName.frame.origin.y, 107, cell.productName.frame.size.height);
    [cell.labelOrderStatus setHidden:NO];
    [self setStatusButton:code :YES :cell :indexPath];
    
    return tmpDict;
}

-(NSDictionary*)setBiddingNotWon:(NSDictionary*)tmpDict :(ProductTableViewCell*)cell :(NSIndexPath *)indexPath
{
    tmpDict = [myBiddingNotWon objectAtIndex:indexPath.row];
    
    [cell.labelTime setHidden:YES];
    [cell.productTime setHidden:YES];
    [cell.btnBid setHidden:YES];
    [cell.btnWatch setHidden:YES];
    
    return tmpDict;
}

-(NSDictionary*)setSharingNoActive:(NSDictionary*)tmpDict :(ProductTableViewCell*)cell :(NSIndexPath *)indexPath
{
    tmpDict = [mySharingNoActive objectAtIndex:indexPath.row];
    
    [cell.labelTime setHidden:YES];
    [cell.productTime setHidden:YES];
    
    return tmpDict;
}

-(NSDictionary*)setSharingActive:(NSDictionary*)tmpDict :(ProductTableViewCell*)cell :(NSIndexPath *)indexPath
{
    tmpDict = [mySharingActive objectAtIndex:indexPath.row];
    
    [cell.labelTime setHidden:NO];
    [cell.productTime setHidden:NO];
    
    return tmpDict;
}

-(NSDictionary*)setSharingSold:(NSDictionary*)tmpDict :(ProductTableViewCell*)cell :(NSIndexPath *)indexPath
{
    tmpDict = [mySharingSold objectAtIndex:indexPath.row];
    
    [cell.labelTime setHidden:YES];
    [cell.productTime setHidden:YES];
    
    int code = [[tmpDict objectForKey:orderStatus] intValue];
    
    if (code >= 1) {
        [cell.labelOrderCode setText:[NSString stringWithFormat:@"Order#%@", [self convertStatusId:[tmpDict objectForKey:orderId]]]];
        [cell.labelOrderCode setHidden:NO];
    }
    
    if (code >= 4) {
        if ([[tmpDict objectForKey:trackingBackCode] isEqual:[NSNull null]])
            [cell.labelTrackingCode setText:[NSString stringWithFormat:@"Tracking Number %@", [tmpDict objectForKey:trackingCode]]];
        else
            [cell.labelTrackingCode setText:[NSString stringWithFormat:@"Tracking Number %@", [tmpDict objectForKey:trackingBackCode]]];
        [cell.labelTrackingCode setHidden:NO];
    }
    
    [cell.labelOrderStatus setText:[self getStatusName:code :NO]];
    cell.productName.frame = CGRectMake(cell.productName.frame.origin.x, cell.productName.frame.origin.y, 107, cell.productName.frame.size.height);
    [cell.labelOrderStatus setHidden:NO];
    [self setStatusButton:code :NO :cell :indexPath];
    
    return tmpDict;
}

-(NSDictionary*)setSharingUnSold:(NSDictionary*)tmpDict :(ProductTableViewCell*)cell :(NSIndexPath *)indexPath
{
    tmpDict = [mySharingUnSold objectAtIndex:indexPath.row];
    
    [cell.labelTime setHidden:YES];
    [cell.productTime setHidden:YES];
    
    return tmpDict;
}

- (IBAction)btnBidClicked:(UIButton *)sender
{
    UIStoryboard *storyboard = self.navigationController.storyboard;
    ProductDetailViewController *productDetail = [storyboard instantiateViewControllerWithIdentifier:@"ProductDetailView"];

    NSDictionary *tmpDict = [myObject objectAtIndex:sender.tag];
    productDetail.productDetailId = [tmpDict objectForKey:productId];
    
    [self.navigationController pushViewController:productDetail animated:YES];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *storyboard = self.navigationController.storyboard;
    ProductDetailViewController *productDetail = [storyboard instantiateViewControllerWithIdentifier:@"ProductDetailView"];
    
    NSDictionary *tmpDict;
    
    if (tableView == _productTable) {
        tmpDict = [myObject objectAtIndex:indexPath.row];
    }
    else if (tableView == _tableBidding){
        if ([tmpBidding isEqualToString:@"View All"]){
            switch (indexPath.section) {
                case 0:
                    tmpDict = [myBiddingOn objectAtIndex:indexPath.row];
                    break;
                case 1:
                    tmpDict = [myBiddingWon objectAtIndex:indexPath.row];
                    break;
                case 2:
                    tmpDict = [myBiddingNotWon objectAtIndex:indexPath.row];
                    break;
                default:
                    break;
            }
        }
        else if ([tmpBidding isEqualToString:@"On Bidding"]){
            tmpDict = [myBiddingOn objectAtIndex:indexPath.row];
        }
        else if ([tmpBidding isEqualToString:@"Won"]){
            tmpDict = [myBiddingWon objectAtIndex:indexPath.row];
        }
        else if ([tmpBidding isEqualToString:@"Don't Won"]){
            tmpDict = [myBiddingNotWon objectAtIndex:indexPath.row];
        }
    }
    else if (tableView == _tableSharing){
        if ([tmpSharing isEqualToString:@"View All"]){
            switch (indexPath.section) {
                case 0:
                    tmpDict = [mySharingNoActive objectAtIndex:indexPath.row];
                    break;
                case 1:
                    tmpDict = [mySharingActive objectAtIndex:indexPath.row];
                    break;
                case 2:
                    tmpDict = [mySharingSold objectAtIndex:indexPath.row];
                    break;
                case 3:
                    tmpDict = [mySharingUnSold objectAtIndex:indexPath.row];
                    break;
                default:
                    break;
            }
        }
        else if ([tmpSharing isEqualToString:@"Non Active"]){
            tmpDict = [mySharingNoActive objectAtIndex:indexPath.row];
        }
        else if ([tmpSharing isEqualToString:@"Active Bidding"]){
            tmpDict = [mySharingActive objectAtIndex:indexPath.row];
        }
        else if ([tmpSharing isEqualToString:@"Sold"]){
            tmpDict = [mySharingSold objectAtIndex:indexPath.row];
        }
        else if ([tmpSharing isEqualToString:@"Unsold"]){
            tmpDict = [mySharingUnSold objectAtIndex:indexPath.row];
        }
    }
    
    productDetail.productDetailId = [tmpDict objectForKey:productId];
    
    [self.navigationController pushViewController:productDetail animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)menuUserClicked:(id)sender
{
    UISegmentedControl *segmented = (UISegmentedControl *)sender;
    
    switch (segmented.selectedSegmentIndex) {
        case 0:
            [self loadWatching];
            [_productTable reloadData];
            [_productTable setHidden:FALSE];
            [_viewSharing setHidden:TRUE];
            [_viewBidding setHidden:TRUE];
            break;
        case 1:
                [self loadBidding:@"BIDDING"];
                [self loadBidding:@"WON"];
                [self loadBidding:@"NOTWON"];
                [_tableBidding reloadData];
            
            [_productTable setHidden:TRUE];
            [_viewSharing setHidden:TRUE];
            [_viewBidding setHidden:FALSE];
            break;
        case 2:
                [self loadSharing:@"NOTACTIVE"];
                [self loadSharing:@"ACTIVE"];
                [self loadSharing:@"SOLD"];
                [self loadSharing:@"UNSOLD"];
                [_tableSharing reloadData];
            
            [_productTable setHidden:TRUE];
            [_viewSharing setHidden:FALSE];
            [_viewBidding setHidden:TRUE];
            break;
        default:
            break;
    }
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == actionSheet.cancelButtonIndex) {
        return;
    }
    
    if (actionSheet == _actionSheetBidding) {
        tmpBidding = [myBidding objectAtIndex:buttonIndex];
        [_btnCatBidding setTitle:tmpBidding forState:UIControlStateNormal];
        [_tableBidding reloadData];
    }
    else if (actionSheet == _actionSheetSharing) {
        tmpSharing = [mySharing objectAtIndex:buttonIndex];
        [_btnCatSharing setTitle:tmpSharing forState:UIControlStateNormal];
        [_tableSharing reloadData];
    }
}

- (IBAction)btnCatSharingClicked:(id)sender
{
    _actionSheetSharing = [[UIActionSheet alloc] initWithTitle:@"Sharing" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    
    for (NSString *item in mySharing)
    {
        [_actionSheetSharing addButtonWithTitle:item];
    }
    
    [_actionSheetSharing addButtonWithTitle:@"Cancel"];
    _actionSheetSharing.cancelButtonIndex = [mySharing count];
    
    [_actionSheetSharing showInView:self.view];
}

- (IBAction)btnCatBiddingClicked:(id)sender
{
    _actionSheetBidding = [[UIActionSheet alloc] initWithTitle:@"Bidding" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    
    for (NSString *item in myBidding)
    {
        [_actionSheetBidding addButtonWithTitle:item];
    }
    
    [_actionSheetBidding addButtonWithTitle:@"Cancel"];
    _actionSheetBidding.cancelButtonIndex = [myBidding count];
    
    [_actionSheetBidding showInView:self.view];
}

-(NSString*)getStatusName:(int)code :(bool)isBidder
{
    switch (code) {
        case 0:
            return @"Cancel";
        case 1:
            return @"Waiting confirm";
        case 2:
            return @"Waiting payment";
        case 3:
            return @"Paid";
        case 4:
            return @"Shipped";
        case 5:
            return @"Close";
        case 6:
            if (isBidder)
                return @"Waiting response";
            else
                return @"Opened case";
        case 7:
            return @"Seller request send back";
        case 8:
            return @"Waiting sent back";
        default:
            return @"";
    }
}

-(void)setStatusButton:(int)code :(bool)isBidder :(ProductTableViewCell*)cell :(NSIndexPath *)indexPath

{
    switch (code) {
        case 0:
        case 1:
        case 2:
        case 5:
            [cell.btnStatusLeft setHidden:YES];
            [cell.btnStatusRight setHidden:YES];
            break;
        case 3:
            if (!isBidder) {
                cell.btnStatusRight.tag = indexPath.row;
                [cell.btnStatusRight setHidden:NO];
                [cell.btnStatusLeft setHidden:YES];
                [cell.btnStatusRight setTitle:@"Shipped" forState:UIControlStateNormal];
                [cell.btnStatusRight addTarget:self action:@selector(btnShippedClicked:) forControlEvents:UIControlEventTouchUpInside];
            }
            break;
        case 4:
            if (isBidder) {
                cell.btnStatusLeft.tag = indexPath.row;
                cell.btnStatusRight.tag = indexPath.row;
                [cell.btnStatusRight setHidden:NO];
                [cell.btnStatusLeft setHidden:NO];
                [cell.btnStatusLeft setTitle:@"Confirm Receive" forState:UIControlStateNormal];
                [cell.btnStatusRight setTitle:@"Open Dispute" forState:UIControlStateNormal];
                [cell.btnStatusLeft addTarget:self action:@selector(btnReceiveBidderClicked:) forControlEvents:UIControlEventTouchUpInside];
                [cell.btnStatusRight addTarget:self action:@selector(btnDisputeClicked:) forControlEvents:UIControlEventTouchUpInside];
            }
            break;
        case  6:
            if (isBidder) {
                cell.btnStatusLeft.tag = indexPath.row;
                cell.btnStatusRight.tag = indexPath.row;
                [cell.btnStatusRight setHidden:NO];
                [cell.btnStatusLeft setHidden:NO];
                [cell.btnStatusLeft setTitle:@"Response Case" forState:UIControlStateNormal
                 ];
                [cell.btnStatusRight setTitle:@"Close" forState:UIControlStateNormal];
                [cell.btnStatusLeft addTarget:self action:@selector(btnResponseBidderClicked:) forControlEvents:UIControlEventTouchUpInside];
                [cell.btnStatusRight addTarget:self action:@selector(btnCloselicked:) forControlEvents:UIControlEventTouchUpInside];
            }
            else {
                cell.btnStatusRight.tag = indexPath.row;
                [cell.btnStatusRight setHidden:NO];
                [cell.btnStatusLeft setHidden:YES];
                [cell.btnStatusRight setTitle:@"Response Case" forState:UIControlStateNormal];
                [cell.btnStatusRight addTarget:self action:@selector(btnResponseSellerClicked:) forControlEvents:UIControlEventTouchUpInside];
            }
            break;
        case 7:
            if (isBidder) {
                cell.btnStatusLeft.tag = indexPath.row;
                cell.btnStatusRight.tag = indexPath.row;
                [cell.btnStatusRight setHidden:NO];
                [cell.btnStatusLeft setHidden:NO];
                [cell.btnStatusLeft setTitle:@"Send Back" forState:UIControlStateNormal
                 ];
                [cell.btnStatusRight setTitle:@"Close" forState:UIControlStateNormal];
                [cell.btnStatusLeft addTarget:self action:@selector(btnSendBackClicked:) forControlEvents:UIControlEventTouchUpInside];
                [cell.btnStatusRight addTarget:self action:@selector(btnCloselicked:) forControlEvents:UIControlEventTouchUpInside];
            }
        case 8:
            if (!isBidder) {
                cell.btnStatusRight.tag = indexPath.row;
                [cell.btnStatusRight setHidden:NO];
                [cell.btnStatusLeft setHidden:YES];
                [cell.btnStatusRight setTitle:@"Confirm Receive" forState:UIControlStateNormal];
                [cell.btnStatusRight addTarget:self action:@selector(btnReceiveSellerClicked:) forControlEvents:UIControlEventTouchUpInside];
            }
        default:
            if (isBidder) {
                cell.btnStatusRight.tag = indexPath.row;
                [cell.btnStatusRight setHidden:NO];
                [cell.btnStatusLeft setHidden:YES];
                [cell.btnStatusRight setTitle:@"Add to cart" forState:UIControlStateNormal];
                [cell.btnStatusRight addTarget:self action:@selector(btnAddCartClicked:) forControlEvents:UIControlEventTouchUpInside];
            }
            break;
    }
}

- (IBAction)btnShippedClicked:(UIButton *)sender
{
    UIStoryboard *storyboard = self.navigationController.storyboard;
    ShippingViewController *ship = [storyboard instantiateViewControllerWithIdentifier:@"ShippingView"];
    
    NSDictionary *tmpDict = [mySharingSold objectAtIndex:sender.tag];
    ship.productName = [tmpDict objectForKey:name];
    ship.productPrice = [tmpDict objectForKey:price];
    ship.productImage = [tmpDict objectForKey:image];
    ship.orderId = [tmpDict objectForKey:orderId];
    ship.isBidder = NO;
    
    [self.navigationController pushViewController:ship animated:YES];
}

- (IBAction)btnReceiveBidderClicked:(UIButton *)sender
{
    UIStoryboard *storyboard = self.navigationController.storyboard;
    FeedbackViewController *feedback = [storyboard instantiateViewControllerWithIdentifier:@"FeedbackView"];
    
    NSDictionary *tmpDict = [myBiddingWon objectAtIndex:sender.tag];
    feedback.productId = [tmpDict objectForKey:productId];
    feedback.productName = [tmpDict objectForKey:name];
    feedback.productPrice = [tmpDict objectForKey:price];
    feedback.productImage = [tmpDict objectForKey:image];
    feedback.auctionId = [tmpDict objectForKey:auctionId];
    feedback.orderId = [tmpDict objectForKey:orderId];
    
    [self.navigationController pushViewController:feedback animated:YES];
}

- (IBAction)btnDisputeClicked:(UIButton *)sender
{
    UIStoryboard *storyboard = self.navigationController.storyboard;
    OpenDisputeViewController *openDispute = [storyboard instantiateViewControllerWithIdentifier:@"OpenDisputeView"];
    
    NSDictionary *tmpDict = [myBiddingWon objectAtIndex:sender.tag];
    openDispute.productId = [tmpDict objectForKey:productId];
    openDispute.productName = [tmpDict objectForKey:name];
    openDispute.productPrice = [tmpDict objectForKey:price];
    openDispute.productImage = [tmpDict objectForKey:image];
    openDispute.orderId = [tmpDict objectForKey:orderId];
    
    [self.navigationController pushViewController:openDispute animated:YES];
}

- (IBAction)btnResponseBidderClicked:(UIButton *)sender
{
    UIStoryboard *storyboard = self.navigationController.storyboard;
    ResponseViewController *response = [storyboard instantiateViewControllerWithIdentifier:@"ResponseView"];
    
    NSDictionary *tmpDict = [myBiddingWon objectAtIndex:sender.tag];
    response.orderId = [tmpDict objectForKey:orderId];
    response.isBidder = YES;
    
    [self.navigationController pushViewController:response animated:YES];
}

- (IBAction)btnCloselicked:(UIButton *)sender
{
    NSDictionary *tmpDict = [mySharingSold objectAtIndex:sender.tag];
    NSString *order = [tmpDict objectForKey:orderId];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [appDelegate setOrderStatus:order :@"5"];
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
    if (!_viewBidding.hidden) {
        [self loadBidding:@"BIDDING"];
        [self loadBidding:@"WON"];
        [self loadBidding:@"NOTWON"];
        [_tableBidding reloadData];
    }
    
    if (!_viewSharing.hidden) {
        [self loadSharing:@"NOTACTIVE"];
        [self loadSharing:@"ACTIVE"];
        [self loadSharing:@"SOLD"];
        [self loadSharing:@"UNSOLD"];
        [_tableSharing reloadData];
    }
    
}

- (IBAction)btnSendBackClicked:(UIButton *)sender
{
    UIStoryboard *storyboard = self.navigationController.storyboard;
    ShippingViewController *ship = [storyboard instantiateViewControllerWithIdentifier:@"ShippingView"];
    
    NSDictionary *tmpDict = [myBiddingWon objectAtIndex:sender.tag];
    ship.productName = [tmpDict objectForKey:name];
    ship.productPrice = [tmpDict objectForKey:price];
    ship.productImage = [tmpDict objectForKey:image];
    ship.orderId = [tmpDict objectForKey:orderId];
    ship.isBidder = YES;
    
    [self.navigationController pushViewController:ship animated:YES];
}

- (IBAction)btnResponseSellerClicked:(UIButton *)sender
{
    UIStoryboard *storyboard = self.navigationController.storyboard;
    ResponseViewController *response = [storyboard instantiateViewControllerWithIdentifier:@"ResponseView"];
    
    NSDictionary *tmpDict = [mySharingSold objectAtIndex:sender.tag];
    response.orderId = [tmpDict objectForKey:orderId];
    response.isBidder = NO;
    
    [self.navigationController pushViewController:response animated:YES];
}

- (IBAction)btnReceiveSellerClicked:(UIButton *)sender
{
    NSDictionary *tmpDict = [mySharingSold objectAtIndex:sender.tag];
    NSString *order = [tmpDict objectForKey:orderId];
    
    [appDelegate setOrderStatus:order :@"5"];
}

- (IBAction)btnAddCartClicked:(UIButton *)sender
{
    NSDictionary *tmpDict = [myBiddingWon objectAtIndex:sender.tag];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:tmpDict forKey:@"cartProduct"];
    
    self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:3];
}

-(NSString*)convertStatusId :(NSString*)code
{
    NSUInteger count = [code length];
    NSString *number = @"";
    
    for (int i = 0; i < 6 - count; i++) {
        number = [number stringByAppendingString:@"0"];
    }
    
    number = [number stringByAppendingString:code];
    
    return number;
}

- (IBAction)btnRemoveWatchClicked:(UIButton *)sender
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSDictionary *tmpDict = [myObject objectAtIndex:sender.tag];
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject:[prefs objectForKey:@"userId"] forKey:@"user_id"];
    [params setObject:[tmpDict objectForKey:productId] forKey:@"product_id"];
    [params setObject:API_KEY forKey:@"x-api-key"];
    
    NSString *url = [NSString stringWithFormat:@"%@/api/user/delete_favorite.json", BASE_URL];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         
         id jsonObjects = [appDelegate parseJson:[operation responseString]];
         
         NSString *message = [jsonObjects objectForKey:@"message"];
         
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
         [alert show];
         
         [self loadWatching];
         [_productTable reloadData];
     }
     failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         
         id jsonObjects = [appDelegate parseJson:[operation responseString]];
         
         NSString *message = [jsonObjects objectForKey:@"message"];
         
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
         [alert show];
     }];
    
}

- (IBAction)btnAddWatchClicked:(UIButton *)sender
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSDictionary *tmpDict = [myObject objectAtIndex:sender.tag];
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject:[prefs objectForKey:@"userId"] forKey:@"user_id"];
    [params setObject:[tmpDict objectForKey:productId] forKey:@"product_id"];
    [params setObject:API_KEY forKey:@"x-api-key"];
    
    NSString *url = [NSString stringWithFormat:@"%@/api/user/add_favorite.json", BASE_URL];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         
         id jsonObjects = [appDelegate parseJson:[operation responseString]];
         
         NSString *message = [jsonObjects objectForKey:@"message"];
         
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
         [alert show];
         
         [self loadWatching];
         [_productTable reloadData];
     }
     failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         
         id jsonObjects = [appDelegate parseJson:[operation responseString]];
         
         NSString *message = [jsonObjects objectForKey:@"message"];
         
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
         [alert show];
     }];
    
}

-(void)willPresentActionSheet:(UIActionSheet *)actionSheet
{
    for (UIView *_currentView in actionSheet.subviews) {
        if ([_currentView isKindOfClass:[UIButton class]]) {
            [((UIButton *)_currentView).titleLabel setFont:[UIFont fontWithName:@"Thai Sans Lite" size:20]];
        }
        if ([_currentView isKindOfClass:[UILabel class]]) {
            [((UILabel *)_currentView) setFont:[UIFont fontWithName:@"Thai Sans Lite" size:15]];
        }
    }
}

@end
