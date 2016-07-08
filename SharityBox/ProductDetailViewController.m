//
//  ProductDetailViewController.m
//  SharityBox
//
//  Created by North on 5/9/2557 BE.
//  Copyright (c) 2557 North. All rights reserved.
//

#import "ProductDetailViewController.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import "AFHTTPRequestOperationManager.h"
#import "UserViewController.h"
#import "ImageFullViewController.h"

@interface ProductDetailViewController ()
{
    NSMutableArray *myPhoto;
    NSMutableArray *myObject;
    
    NSDictionary *dict;
    
    NSString *image;
    NSString *name;
    NSString *price;
    NSString *time;
    NSString *foundation;
    NSString *user;
    NSString *userLast;
    NSString *detail;
    NSString *productId;
    NSString *shpping;
    NSString *condition;
    NSString *auctionId;
    NSString *fee;
    NSString *delivery;
    NSString *allowBidding;
    NSString *userId;
    NSString *minBidding;
    NSString *rank;
    
    NSTimer *timer;

    int hours, minutes, seconds;
    long elapsedSeconds;
    
    NSDate *nowDate, *futureDate;
    
    AppDelegate *appDelegate;
    
    int finalPrice;
    
    int countRefresh;
    
    bool firstTime;
}

@end

@implementation ProductDetailViewController

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
    
    [self.scrollViewProductDetail setHidden:YES];
    
    appDelegate = [[UIApplication sharedApplication] delegate];
    
    self.navigationItem.titleView = [appDelegate addTitleApp :@"Loading..."];
    
    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc]
                                  initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(shareProduct)];
    
    self.navigationItem.rightBarButtonItem = shareButton;
    
    if (IS_OS_7_OR_LATER) {
        self.navigationController.navigationBar.topItem.title = @"";
    }
    
    [_btnBid setImage:[UIImage imageNamed:@"icon_auction.png"]
             forState:UIControlStateNormal];
    [_btnBid setTitle:@"Auction" forState:UIControlStateNormal];
    [_btnBid setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    int topButton = (_btnBid.frame.size.height - 16) / 2;
    int leftButton = (_btnBid.frame.size.width - 14 ) /2;
    [_btnBid setImageEdgeInsets:UIEdgeInsetsMake(topButton + 2 , leftButton - 25, topButton - 2, leftButton + 25)];
    
    [appDelegate changeFontOfView:self.view :@"Thai Sans Lite"];
    
    [self setupUserProfile];
    
    [self setupTapPhoto];

    image = @"image_file";
    name = @"product_name";
    price = @"auction_last_price";
    time = @"auction_end_date";
    foundation = @"foundation_name";
    user = @"user_first_name";
    userLast = @"user_last_name";
    detail = @"product_detail";
    productId = @"product_id";
    condition = @"product_condition";
    auctionId = @"auction_id";
    fee = @"shipping_fee";
    delivery = @"shipping_deliver_day";
    allowBidding =@"allow_bidding";
    userId = @"user_id";
    minBidding =@"auction_min_bidding_price";
    rank = @"user_rank";
    
    myObject = [[NSMutableArray alloc] init];
    myPhoto = [[NSMutableArray alloc] init];
    
    self.scrollViewProductDetail.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tapGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewTapped)];
    
    [self.scrollViewProductDetail addGestureRecognizer:tapGesture1];
    
    firstTime = YES;
 
}

-(void)viewDidAppear:(BOOL)animated {
    if (firstTime) {
        [self loadProduct];
        [self setUpScrollImage];
        firstTime = NO;
    }
}

-(void)setUpScrollImage
{
    int y = CGRectGetMaxY(_productDetailDesc.frame);
    [_scrollViewProductDetail setContentSize:CGSizeMake(320, y + 20)];
    
    CGFloat screenWidth = self.scrollViewPhoto.frame.size.width;
    CGFloat screenHeight = self.scrollViewPhoto.frame.size.height;
    
    for (int i = 0; i < [myPhoto count]; i++) {
        CGRect frame;
        frame.origin.x = self.scrollViewPhoto.frame.size.width * i;
        frame.origin.y = 0;
        frame.size = self.scrollViewPhoto.frame.size;
        
        NSString *imName =[[NSString alloc] initWithFormat:@"%@/files/product_images/%@", BASE_URL, [myPhoto objectAtIndex:i]];
        
        NSData *imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:imName]];
        
        UIImage *theImage = [[UIImage alloc] initWithData:imageData];
        
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(screenWidth*i, 0, screenWidth, screenHeight)];
        img.image = theImage;
        
        img.contentMode = UIViewContentModeScaleAspectFit;
        
        [self.scrollViewPhoto addSubview:img];
    }
    
    self.scrollViewPhoto.contentSize = CGSizeMake(self.scrollViewPhoto.frame.size.width * [myPhoto count], self.scrollViewPhoto.frame.size.height-100);
    [self.scrollViewPhoto setShowsHorizontalScrollIndicator:NO];
    [self.scrollViewPhoto setPagingEnabled:YES];
    
    self.pageControlPhoto.currentPage = 0;
    self.pageControlPhoto.numberOfPages = [myPhoto count];
}

-(void)loadProduct
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSURL *jsonURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/product/index/id/%@.json?x-api-key=%@", BASE_URL, self.productDetailId, API_KEY]];
    NSData *jsonData = [NSData dataWithContentsOfURL:jsonURL];
    
    id jsonObjects = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    
    [myObject removeAllObjects];
    [myPhoto removeAllObjects];
    
    @try {
        
        NSDictionary *dataDict = jsonObjects;
        
        NSString *strImage = [NSString stringWithFormat:@"%@", [dataDict objectForKey:image]];
        NSString *strName = [NSString stringWithFormat:@"%@", [dataDict objectForKey:name]];
        NSString *strPrice = [NSString stringWithFormat:@"%@", [dataDict objectForKey:price]];
        NSString *strTime = [NSString stringWithFormat:@"%@", [dataDict objectForKey:time]];
        NSString *strFoundation = [dataDict objectForKey:foundation];
        NSString *strUser = [NSString stringWithFormat:@"%@", [dataDict objectForKey:user]];
        NSString *strUserLast = [NSString stringWithFormat:@"%@", [dataDict objectForKey:userLast]];
        NSString *strDetail = [NSString stringWithFormat:@"%@", [dataDict objectForKey:detail]];
        NSString *strProductId = [dataDict objectForKey:productId];
        NSString *strCondition = [NSString stringWithFormat:@"%@", [dataDict objectForKey:condition]];
        NSString *strAuctionId = [dataDict objectForKey:auctionId];
        NSString *strFee = [NSString stringWithFormat:@"%@", [dataDict objectForKey:fee]];
        NSString *strDelivery = [NSString stringWithFormat:@"%@", [dataDict objectForKey:delivery]];
        NSString *strAllowBidding = [NSString stringWithFormat:@"%@", [dataDict objectForKey:allowBidding]];
        NSString *strUserId= [dataDict objectForKey:userId];
        NSString *strMinBidding = [NSString stringWithFormat:@"%@", [dataDict objectForKey:minBidding]];
        NSString *strRank = [NSString stringWithFormat:@"%@", [dataDict objectForKey:rank]];
        
        dict = [NSDictionary dictionaryWithObjectsAndKeys:
                strImage, image,
                strName, name,
                strPrice, price,
                strTime, time,
                strProductId, productId,
                strFoundation, foundation,
                strUser, user,
                strUserLast, userLast,
                strDetail, detail,
                strCondition, condition,
                strAuctionId, auctionId,
                strFee, fee,
                strDelivery, delivery,
                strAllowBidding, allowBidding,
                strUserId, userId,
                strMinBidding, minBidding,
                strRank, rank,
                nil];
        [myObject addObject:dict];
        
        [self showContent];
        
        NSDictionary *dictPhoto = [dataDict objectForKey:@"image_items"];
        
        for (NSDictionary *item in dictPhoto)
        {
            [myPhoto addObject:[item objectForKey:@"image_file"]];
        }
        
    }
    @catch (NSException *exception)
    {
        NSString *error = [jsonObjects objectForKey:@"error"];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:error delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    
    [self.scrollViewProductDetail setHidden:NO];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

-(void)shareProduct
{
    NSString *textToShare = [NSString stringWithFormat:@"ร่วมประมูล %@ ให้กับ %@", _productDetailName.text, _productDetailOwner.text];
    
    NSString *imName =[[NSString alloc] initWithFormat:@"%@/files/product_images/%@", BASE_URL, [myPhoto objectAtIndex:0]];
    NSData *imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:imName]];
    UIImage *shareImage = [[UIImage alloc] initWithData:imageData];
    
    NSArray *itemsToShare = @[textToShare, shareImage];
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:itemsToShare applicationActivities:nil];
    activityVC.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeCopyToPasteboard, UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll];
    [self presentViewController:activityVC animated:YES completion:nil];
    
    activityVC.completionHandler = ^(NSString *activityType, BOOL completed) {
        if (completed) {
            [self setProductShareCallback];
        }
    };
}

-(void)scrollViewTapped
{
    [self.view endEditing:YES];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    int index = scrollView.contentOffset.x/scrollView.frame.size.width;
    [_pageControlPhoto setCurrentPage:index];
}

- (IBAction)changedPage:(id)sender {
	// Update the scroll view to the appropriate page
	CGRect frame;
	frame.origin.x = self.scrollViewPhoto.frame.size.width * self.pageControlPhoto.currentPage;
	frame.origin.y = 0;
	frame.size = self.scrollViewPhoto.frame.size;
	[self.scrollViewPhoto scrollRectToVisible:frame animated:YES];
}

- (void)viewDidUnload {
	self.scrollViewPhoto = nil;
	self.pageControlPhoto = nil;
}

-(void)counterdownTimer
{
    countRefresh = 0;
    
    hours = minutes = seconds = 0;
    
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateCounter:) userInfo:nil repeats:YES];
}

-(void)updateCounter:(NSTimer *)theTimer
{
    NSString *result = [appDelegate getCountTime:futureDate];
    _productDetailTime.text = result;
    _productDetailTime.textColor = [appDelegate getColorTime:futureDate];
    
    countRefresh += 1;
    if (countRefresh >= TIMER_REFRESH)
    {
        [timer invalidate];
        countRefresh = 0;
        [self loadProduct];
    }
}

-(void)updateCounterRefresh:(NSTimer *)theTimer
{
    [self loadProduct];
}


-(void)showContent
{
    NSDictionary *tmpDict = [myObject objectAtIndex:0];
    
    int allow = [[tmpDict objectForKey:allowBidding] intValue];
    
    if (allow != 0) {
        [_txtfieldProductDetailPrice setHidden:YES];
        [_btnBid setHidden:YES];
    }
    
    self.navigationItem.titleView = [appDelegate addTitleApp :[tmpDict objectForKey:name]];
    _productDetailName.text = [tmpDict objectForKey:name];
    _productDetailDesc.text = [tmpDict objectForKey:detail];
    
    CGSize maxLabelSize = CGSizeMake(280, FLT_MAX);
    CGSize expectedLabelSize = [_productDetailDesc.text sizeWithFont:_productDetailDesc.font constrainedToSize:maxLabelSize lineBreakMode:_productDetailDesc.lineBreakMode];
    CGRect newFrame = _productDetailDesc.frame;
    newFrame.size.height = expectedLabelSize.height;
    _productDetailDesc.frame = newFrame;
    
    CGSize expectedLabelSize2 = [_productDetailName.text sizeWithFont:_productDetailName.font constrainedToSize:maxLabelSize lineBreakMode:_productDetailName.lineBreakMode];
    CGRect newFrame2 = _productDetailName.frame;
    CGFloat differHeight2 = expectedLabelSize2.height - newFrame2.size.height;
    newFrame2.size.height = expectedLabelSize2.height;
    _productDetailName.frame = newFrame2;
    
    CGRect frame = _subViewDetail.frame;
    frame.origin = CGPointMake(_subViewDetail.frame.origin.x, _subViewDetail.frame.origin.y + differHeight2);
    _subViewDetail.frame = frame;
    
    CGRect frame2 = _productDetailDesc.frame;
    frame2.origin = CGPointMake(_productDetailDesc.frame.origin.x, _productDetailDesc.frame.origin.y + differHeight2);
    _productDetailDesc.frame = frame2;

    _productDetailUser.text = [NSString stringWithFormat: @"%@ %@",[tmpDict objectForKey:user], [tmpDict objectForKey:userLast]];
    _productDetailOwner.text = [tmpDict objectForKey:foundation];
    _productDetailPrice.text = [NSString stringWithFormat: @"%@ บาท",[tmpDict objectForKey:price]];
    _productDetailCondition.text = [tmpDict objectForKey:condition];
    _labelShippingFee.text = [NSString stringWithFormat:@"Shipping fee %@ baht", [tmpDict objectForKey:fee]];
    _labelDelivery.text = [NSString stringWithFormat:@"Delivery in %@ days", [tmpDict objectForKey:delivery]];
    _labelRank.text = [NSString stringWithFormat:@"(%@)", [tmpDict objectForKey:rank]];
    
    _imageViewRank.image = [UIImage imageNamed:[appDelegate getRankImage:[tmpDict objectForKey:rank]]];
    
    int curPrice = [[tmpDict objectForKey:price] intValue];
    int minBid = [[tmpDict objectForKey:minBidding] intValue];
    finalPrice = curPrice + minBid;
    
    _txtfieldProductDetailPrice.text = [NSString stringWithFormat:@"%d", finalPrice];

    NSTimeInterval timeIn = [[tmpDict objectForKey:time] doubleValue];
    
    futureDate = [NSDate dateWithTimeIntervalSince1970:timeIn];

    NSString *result = [appDelegate getCountTime:futureDate];

    _productDetailTime.text = result;
    _productDetailTime.textColor = [appDelegate getColorTime:futureDate];
    
    [self counterdownTimer];
    
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

- (IBAction)btnBidClicked:(id)sender
{
    if ([_txtfieldProductDetailPrice.text isEqual:@""])
    {
        [appDelegate alertBox:@"Oops!" :@"Please fill in all fields"];
        return;
    }
    
    int inputPrice = [_txtfieldProductDetailPrice.text intValue];
    
    if (inputPrice < finalPrice) {
        [appDelegate alertBox:@"Oops!" :[NSString stringWithFormat:@"Not Less than %d", finalPrice]];
        return;
    }
    
    if ([_productDetailTime.text isEqualToString:@"-"]) {
        [appDelegate alertBox:@"Oops!" :@"Time is up"];
        return;
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Confirm" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    [alert show];
    
    alert.delegate = self;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        return;
    }
    else if (buttonIndex == 1)
    {
        [self sendAuction];
    }
    
}

-(void)sendAuction
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSDictionary *tmpDict = [myObject objectAtIndex:0];
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject:[tmpDict objectForKey:auctionId] forKey:@"auction_id"];
    [params setObject:[tmpDict objectForKey:productId] forKey:@"product_id"];
    [params setObject:[prefs objectForKey:@"userId"] forKey:@"user_id"];
    [params setObject:_txtfieldProductDetailPrice.text forKey:@"auction_amount"];
    [params setObject:API_KEY forKey:@"x-api-key"];
    
    NSString *url = [NSString stringWithFormat:@"%@/api/user/add_bid.json", BASE_URL];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         //id jsonObjects = [appDelegate parseJson:[operation responseString]];
         
         //NSString *message = [jsonObjects objectForKey:@"message"];
         
         [self loadProduct];
         
         //UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
         //[alert show];
         
         //_productDetailPrice.text = [NSString stringWithFormat: @"%@ บาท",_txtfieldProductDetailPrice.text];
         //_txtfieldProductDetailPrice.text = @"";
     }
          failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         id jsonObjects = [appDelegate parseJson:[operation responseString]];
         
         NSString *message = [jsonObjects objectForKey:@"message"];
         
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
         [alert show];
     }];
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect aRect = self.view.frame;
    aRect.origin.y -= 170;
    self.view.frame = aRect;
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    CGRect aRect = self.view.frame;
    aRect.origin.y += 170;
    self.view.frame = aRect;
}

-(void)setupTapPhoto
{
    self.scrollViewPhoto.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tapGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewPhotoTapped)];
    
    [self.scrollViewPhoto addGestureRecognizer:tapGesture1];
}

-(void)scrollViewPhotoTapped
{
    UIStoryboard *storyboard = self.navigationController.storyboard;
    ImageFullViewController *imageView = [storyboard instantiateViewControllerWithIdentifier:@"ImageFullView"];
    
    NSString *imName =[[NSString alloc] initWithFormat:@"%@/files/product_images/%@", BASE_URL, [myPhoto objectAtIndex:self.pageControlPhoto.currentPage]];
    
    
    NSDictionary *tmpDict = [myObject objectAtIndex:0];
    
    imageView.imagePath = imName;
    imageView.productName = [tmpDict objectForKey:name];
    
    [self.navigationController pushViewController:imageView animated:YES];
}

-(void)setupUserProfile
{
    self.productDetailUser.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tapGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userProfileTapped)];
    
    [self.productDetailUser addGestureRecognizer:tapGesture1];
}

- (void)userProfileTapped
{
    UIStoryboard *storyboard = self.navigationController.storyboard;
    UserViewController *userView = [storyboard instantiateViewControllerWithIdentifier:@"UserView"];
    
    NSDictionary *tmpDict = [myObject objectAtIndex:0];
    userView.userId = [tmpDict objectForKey:userId];
    
    [self.navigationController pushViewController:userView animated:YES];
}

-(void)setProductShareCallback
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject:productId forKey:@"product_id"];
    [params setObject:[prefs objectForKey:@"userId"] forKey:@"user_id"];
    [params setObject:API_KEY forKey:@"x-api-key"];
    
    NSString *url = [NSString stringWithFormat:@"%@/api/product/share_callback.json", BASE_URL];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         //id jsonObjects = [self parseJson:[operation responseString]];
         
         //NSString *message = [jsonObjects objectForKey:@"message"];
         
         //UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
         //[alert show];
         
     }
    failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         //id jsonObjects = [self parseJson:[operation responseString]];
         
         //NSString *message = [jsonObjects objectForKey:@"message"];
         
         //UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
         //[alert show];
     }];
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

@end
