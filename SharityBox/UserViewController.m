//
//  UserViewController.m
//  SharityBox
//
//  Created by North on 6/22/2557 BE.
//  Copyright (c) 2557 North. All rights reserved.
//

#import "UserViewController.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import "AFHTTPRequestOperationManager.h"
#import "ProductTableViewCell.h"
#import "ProductDetailViewController.h"
#import "AttitudeTableViewController.h"

@interface UserViewController ()
{
    AppDelegate *appDelegate;
    
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
    
    NSMutableArray *mySharing;
    
    NSString *tmpSharing;
}
@end

@implementation UserViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [_imageViewAvatar setClipsToBounds:YES];
    
    appDelegate = [[UIApplication sharedApplication] delegate];
    
    self.imageDownloadingQueue = [[NSOperationQueue alloc] init];
    self.imageDownloadingQueue.maxConcurrentOperationCount = 4;
    self.imageCache = [[NSCache alloc] init];
    
    self.navigationItem.titleView = [appDelegate addTitleApp :@"Loading..."];
    if (IS_OS_7_OR_LATER) {
        self.navigationController.navigationBar.topItem.title = @"";
    }
    
    [appDelegate changeFontOfView:self.view :@"Thai Sans Lite"];
    
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
    
    mySharingActive = [[NSMutableArray alloc] init];
    mySharingNoActive = [[NSMutableArray alloc] init];
    mySharingSold = [[NSMutableArray alloc] init];
    mySharingUnSold = [[NSMutableArray alloc] init];
    mySharing = [[NSMutableArray alloc] init];
    
    _tableSharing.separatorColor = [UIColor clearColor];
    _tableSharing.backgroundColor = [UIColor colorWithRed:243.0f/255.0f green:243.0f/255.0f blue:243.0f/255.0f alpha:1.0f];
    
    [mySharing addObject:@"View All"];
    [mySharing addObject:@"Non Active"];
    [mySharing addObject:@"Active Bidding"];
    [mySharing addObject:@"Sold"];
    [mySharing addObject:@"Unsold"];
    
    tmpSharing = @"View All";
    
    self.labelNatural.userInteractionEnabled = YES;
    self.labelNegative.userInteractionEnabled = YES;
    self.labelPositive.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tapGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(attitudeTapped)];
    UITapGestureRecognizer *tapGesture2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(attitudeTapped)];
    UITapGestureRecognizer *tapGesture3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(attitudeTapped)];
    
    [self.labelPositive addGestureRecognizer:tapGesture1];
    [self.labelNegative addGestureRecognizer:tapGesture2];
    [self.labelNatural addGestureRecognizer:tapGesture3];
    
    [self loadProfile];
    
    [self startTimer];

}

-(void)viewDidAppear:(BOOL)animated {
    
    [self loadSharing:@"NOTACTIVE"];
    [self loadSharing:@"ACTIVE"];
    [self loadSharing:@"SOLD"];
    [self loadSharing:@"UNSOLD"];
    [_tableSharing reloadData];
}

-(void)attitudeTapped
{
    UIStoryboard *storyboard = self.navigationController.storyboard;
    AttitudeTableViewController *attitude = [storyboard instantiateViewControllerWithIdentifier:@"AttitudeTableView"];

    attitude.userId = self.userId;
    attitude.userName = _userName.text;
    
    [self.navigationController pushViewController:attitude animated:YES];
}


-(void)startTimer
{
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateCounter:) userInfo:nil repeats:YES];
    }
}
-(void)updateCounter:(NSTimer *)theTimer
{
    [self.tableSharing reloadData];
}

-(void)loadProfile
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSURL *jsonURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/user/index/id/%@.json?x-api-key=%@", BASE_URL, self.userId, API_KEY]];
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
        
        self.navigationItem.titleView = [appDelegate addTitleApp :[NSString stringWithFormat:@"%@ %@", first, last]];
    }
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

-(void)loadSharing:(NSString*)status
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    NSURL *jsonURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/user/sharing/id/%@/status/%@.json?x-api-key=%@", BASE_URL, self.userId, status, API_KEY]];
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
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == _tableSharing) {
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
    
    if (tableView == _tableSharing) {
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
     if (tableView == _tableSharing) {
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
    if (tableView == _tableSharing){
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
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *storyboard = self.navigationController.storyboard;
    ProductDetailViewController *productDetail = [storyboard instantiateViewControllerWithIdentifier:@"ProductDetailView"];
    
    NSDictionary *tmpDict;
    
    if (tableView == _tableSharing){
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
    
    if (tableView == _tableSharing) {
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
    
    NSTimeInterval timeIn = [[tmpDict objectForKey:time] doubleValue];
    
    NSDate *futureDate = [NSDate dateWithTimeIntervalSince1970:timeIn];
    
    NSString *result = [appDelegate getCountTime:futureDate];
    
    cell.productTime.text = result;
    cell.productTime.textColor = [appDelegate getColorTime:futureDate];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
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
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == actionSheet.cancelButtonIndex) {
        return;
    }
    
    if (actionSheet == _actionSheetSharing) {
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
