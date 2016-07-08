//
//  NewAuctionViewController.m
//  SharityBox
//
//  Created by North on 5/29/2557 BE.
//  Copyright (c) 2557 North. All rights reserved.
//

#import "NewAuctionViewController.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import "AFHTTPRequestOperationManager.h"
#import "ProductDetailViewController.h"

#define CAMERA_BUTTON_INDEX 0
#define PHOTO_LIBRARY_BUTTON_INDEX 1

@interface NewAuctionViewController ()
{
    AppDelegate *appDelegate;
    
    NSMutableArray *myFoundation;
    NSMutableArray *myCondition;
    NSMutableArray *myShipping;
    NSMutableArray *myBidding;
    NSMutableArray *myEndAuction;
    NSMutableArray *myStartAuction;
    NSMutableArray *myCategory1;
    NSMutableArray *myCategory2;
    NSMutableArray *myCategory3;
    
    NSString *foundationId;
    NSString *foundationName;

    NSDictionary *dictFound;
    NSDictionary *dictCon;
    NSDictionary *dictShip;
    NSDictionary *dictBid;
    NSDictionary *dictCat1;
    NSDictionary *dictCat2;
    NSDictionary *dictCat3;
    
    NSDictionary *tmpDictFound;
    NSDictionary *tmpDictCon;
    NSDictionary *tmpDictShip;
    NSDictionary *tmpDictBid;
    NSString *tmpEndAuction;
    NSString *tmpStartAuction;
    NSDictionary *tmpDictCat1;
    NSDictionary *tmpDictCat2;
    NSDictionary *tmpDictCat3;
    
    NSString *conditionEnum;
    NSString *conditionName;
    
    NSString *shippingId;
    NSString *shippingName;
    
    NSString *biddingId;
    NSString *biddingName;
    
    NSString *categoryId;
    NSString *categoryName;
    
    NSString *imageViewTap;
    
    NSMutableArray *images;
}

@end

@implementation NewAuctionViewController


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
    
    appDelegate = [[UIApplication sharedApplication] delegate];
    
    self.navigationItem.titleView = [appDelegate addTitleApp :@"New Auction"];
    if (IS_OS_7_OR_LATER) {
        self.navigationController.navigationBar.topItem.title = @"";
    }
    
    foundationId = @"foundation_id";
    foundationName = @"foundation_name";
    
    conditionName = @"condition_name";
    conditionEnum = @"condition_enum";
    
    shippingId = @"shipping_id";
    shippingName = @"shipping_name";
    
    biddingId = @"bidding_id";
    biddingName = @"bidding_name";
    
    categoryId = @"category_id";
    categoryName = @"category_name";
    
    myFoundation = [[NSMutableArray alloc] init];
    myCondition = [[NSMutableArray alloc] init];
    myShipping = [[NSMutableArray alloc] init];
    myBidding = [[NSMutableArray alloc] init];
    myEndAuction = [[NSMutableArray alloc] init];
    myStartAuction = [[NSMutableArray alloc] init];
    myCategory1 = [[NSMutableArray alloc] init];
    myCategory2 = [[NSMutableArray alloc] init];
    myCategory3 = [[NSMutableArray alloc] init];
    
    [_imageViewAuction1 setClipsToBounds:YES];
    [_imageViewAuction2 setClipsToBounds:YES];
    [_imageViewAuction3 setClipsToBounds:YES];
    [_imageViewAuction4 setClipsToBounds:YES];
    [_imageViewAuction5 setClipsToBounds:YES];
    
    [appDelegate changeFontOfView:self.view :@"Thai Sans Lite"];
    
    NSURL *jsonURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/foundation/all.json?x-api-key=%@", BASE_URL, API_KEY]];
    NSData *jsonData = [NSData dataWithContentsOfURL:jsonURL];
    
    id jsonObjects = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    
    for (NSDictionary *dataDict in jsonObjects)
    {
        NSString *strFoundationId = [dataDict objectForKey:foundationId];
        NSString *strFoundationName = [dataDict objectForKey:foundationName];
        
         dictFound = [NSDictionary dictionaryWithObjectsAndKeys:
                strFoundationId, foundationId,
                strFoundationName, foundationName,
                nil];
        [myFoundation addObject:dictFound];
    }
    
    NSURL *jsonURL2 = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/category/all/parent/0.json?x-api-key=%@", BASE_URL, API_KEY]];
    NSData *jsonData2 = [NSData dataWithContentsOfURL:jsonURL2];
    
    id jsonObjects2 = [NSJSONSerialization JSONObjectWithData:jsonData2 options:NSJSONReadingMutableContainers error:nil];
    
    for (NSDictionary *dataDict in jsonObjects2)
    {
        NSString *strCategoryId = [dataDict objectForKey:categoryId];
        NSString *strCategoryName = [dataDict objectForKey:categoryName];
        
        dictCat1 = [NSDictionary dictionaryWithObjectsAndKeys:
                     strCategoryId, categoryId,
                     strCategoryName, categoryName,
                     nil];
        [myCategory1 addObject:dictCat1];
    }
    
    dictCon = [NSDictionary dictionaryWithObjectsAndKeys:
               @"New Product", conditionName,
               @"NEW", conditionEnum,
                nil];
    [myCondition addObject:dictCon];

    dictCon = [NSDictionary dictionaryWithObjectsAndKeys:
               @"Used Product", conditionName,
               @"USED", conditionEnum,
               nil];
    [myCondition addObject:dictCon];
    
    dictShip = [NSDictionary dictionaryWithObjectsAndKeys:
               @"Picker", shippingName,
               @"1", shippingId,
               nil];
    [myShipping addObject:dictShip];
    
    dictShip = [NSDictionary dictionaryWithObjectsAndKeys:
               @"Post", shippingName,
               @"2", shippingId,
               nil];
    [myShipping addObject:dictShip];
    
    dictBid = [NSDictionary dictionaryWithObjectsAndKeys:
                @"All bidding", biddingName,
                @"0", biddingId,
                nil];
    [myBidding addObject:dictBid];
    
    dictBid = [NSDictionary dictionaryWithObjectsAndKeys:
                @"No member feedback nagative", biddingName,
                @"1", biddingId,
                nil];
    [myBidding addObject:dictBid];
    
    [myEndAuction addObject:@"3"];
    [myEndAuction addObject:@"5"];
    [myEndAuction addObject:@"7"];
    
    [myStartAuction addObject:@"Now"];
    [myStartAuction addObject:@"Select Date"];
        
    [_scrollViewAuction setContentSize:CGSizeMake(320, 1000)];
    
    [self setupImageView];
    
    int y = CGRectGetMaxY(_btnAddNewAuction.frame);
    [_scrollViewAuction setContentSize:CGSizeMake(320, y + 10)];
    
    _datePicker = [[UIDatePicker alloc] init];
    _datePicker.backgroundColor = [UIColor colorWithRed:243.0f/255.0f green:243.0f/255.0f blue:243.0f/255.0f alpha:1.0f];
    
    CGRect screenRect = [self.view frame];
    
    CGSize pickerSize = [self.datePicker sizeThatFits:CGSizeZero];
    
    CGRect pickerRect = CGRectMake(0.0, screenRect.origin.y + screenRect.size.height - pickerSize.height, pickerSize.width, pickerSize.height);
    self.datePicker.frame = pickerRect;
    
    [self.view addSubview:self.datePicker];
    
    [_datePicker setHidden:TRUE];
    
    self.scrollViewAuction.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tapScrollView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewTap)];
    
    [self.scrollViewAuction addGestureRecognizer:tapScrollView];
    
}

-(void)scrollViewTap
{
    [self.view endEditing:YES];
}

-(void)setupImageView
{
    self.imageViewAuction1.userInteractionEnabled = YES;
    self.imageViewAuction2.userInteractionEnabled = YES;
    self.imageViewAuction3.userInteractionEnabled = YES;
    self.imageViewAuction4.userInteractionEnabled = YES;
    self.imageViewAuction5.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tapGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTapped1)];
    UITapGestureRecognizer *tapGesture2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTapped2)];
    UITapGestureRecognizer *tapGesture3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTapped3)];
    UITapGestureRecognizer *tapGesture4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTapped4)];
    UITapGestureRecognizer *tapGesture5 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTapped5)];
    
    [self.imageViewAuction1 addGestureRecognizer:tapGesture1];
    [self.imageViewAuction2 addGestureRecognizer:tapGesture2];
    [self.imageViewAuction3 addGestureRecognizer:tapGesture3];
    [self.imageViewAuction4 addGestureRecognizer:tapGesture4];
    [self.imageViewAuction5 addGestureRecognizer:tapGesture5];
    
    _actionSheetPhoto = [[UIActionSheet alloc] initWithTitle:@"Select Source" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera", @"Photo Library", nil];
}

- (void)imageViewTapped1
{
    imageViewTap = @"1";
    
    [_actionSheetPhoto showInView:self.view];
}

- (void)imageViewTapped2
{
    imageViewTap = @"2";

    [_actionSheetPhoto showInView:self.view];
}

- (void)imageViewTapped3
{
    imageViewTap = @"3";
    
    [_actionSheetPhoto showInView:self.view];
}

- (void)imageViewTapped4
{
    imageViewTap = @"4";
    
    [_actionSheetPhoto showInView:self.view];
}

- (void)imageViewTapped5
{
    imageViewTap = @"5";

    [_actionSheetPhoto showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == actionSheet.cancelButtonIndex) {
        return;
    }
    
    if (actionSheet == _actionSheetPhoto) {
        if (buttonIndex == CAMERA_BUTTON_INDEX) {
            [self callImagePickerWithSourceType:CAMERA_BUTTON_INDEX];
        } else if (buttonIndex == PHOTO_LIBRARY_BUTTON_INDEX) {
            [self callImagePickerWithSourceType:PHOTO_LIBRARY_BUTTON_INDEX];
        }
    }
    else if (actionSheet == _actionSheetProCon) {
        tmpDictCon = [myCondition objectAtIndex:buttonIndex];
        [_btnAuctionProCon setTitle:[tmpDictCon objectForKey:conditionName] forState:UIControlStateNormal];
    }
    else if (actionSheet == _actionSheetDonate) {
        tmpDictFound = [myFoundation objectAtIndex:buttonIndex];
        [_btnAuctionDonate setTitle:[tmpDictFound objectForKey:foundationName] forState:UIControlStateNormal];
    }
    else if (actionSheet == _actionSheetShipping) {
        tmpDictShip = [myShipping objectAtIndex:buttonIndex];
        [_btnAuctionShipping setTitle:[tmpDictShip objectForKey:shippingName] forState:UIControlStateNormal];
    }
    else if (actionSheet == _actionSheetBidCon) {
        tmpDictBid = [myBidding objectAtIndex:buttonIndex];
        [_btnAuctionBidding setTitle:[tmpDictBid objectForKey:biddingName] forState:UIControlStateNormal];
    }
    else if (actionSheet == _actionSheetEndAuction) {
        tmpEndAuction = [myEndAuction objectAtIndex:buttonIndex];
        [_btnAuctionEnd setTitle:[NSString stringWithFormat:@"%@ days", tmpEndAuction] forState:UIControlStateNormal];
    }
    else if (actionSheet == _actionSheetStartAuction) {
        tmpStartAuction = [myStartAuction objectAtIndex:buttonIndex];
        [_btnAuctionDate setTitle:tmpStartAuction forState:UIControlStateNormal];
        if (buttonIndex == 1) {
            [_datePicker setHidden:FALSE];
            
            if (self.doneDateButton == nil) {
                self.doneDateButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(dateSelected:)];
            }
            
            self.navigationItem.rightBarButtonItem = self.doneDateButton;
        }
    }
    else if (actionSheet == _actionSheetCategory1) {
        tmpDictCat1 = [myCategory1 objectAtIndex:buttonIndex];
        NSString *catId = [tmpDictCat1 objectForKey:categoryId];
        
        NSURL *jsonURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/category/all/parent/%@.json?x-api-key=%@", BASE_URL, catId, API_KEY]];
        NSData *jsonData = [NSData dataWithContentsOfURL:jsonURL];
        
        id jsonObjects = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
        
        [myCategory2 removeAllObjects];
        
        for (NSDictionary *dataDict in jsonObjects)
        {
            NSString *strCategoryId = [dataDict objectForKey:categoryId];
            NSString *strCategoryName = [dataDict objectForKey:categoryName];
            
            dictCat2 = [NSDictionary dictionaryWithObjectsAndKeys:
                        strCategoryId, categoryId,
                        strCategoryName, categoryName,
                        nil];
            [myCategory2 addObject:dictCat2];
        }
        
        _actionSheetCategory2 = [[UIActionSheet alloc] initWithTitle:@"Category 2" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
        
        for (NSDictionary *item in myCategory2)
        {
            [_actionSheetCategory2 addButtonWithTitle:[item objectForKey:categoryName]];
        }
        
        [_actionSheetCategory2 addButtonWithTitle:@"Cancel"];
        _actionSheetCategory2.cancelButtonIndex = [myCategory2 count];
        
        [_actionSheetCategory2 showInView:self.view];
    }
    else if (actionSheet == _actionSheetCategory2) {
        tmpDictCat2 = [myCategory2 objectAtIndex:buttonIndex];
        NSString *catId = [tmpDictCat2 objectForKey:categoryId];
        
        NSURL *jsonURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/category/all/parent/%@.json?x-api-key=%@", BASE_URL, catId, API_KEY]];
        NSData *jsonData = [NSData dataWithContentsOfURL:jsonURL];
        
        id jsonObjects = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
        
        [myCategory3 removeAllObjects];
        
        for (NSDictionary *dataDict in jsonObjects)
        {
            NSString *strCategoryId = [dataDict objectForKey:categoryId];
            NSString *strCategoryName = [dataDict objectForKey:categoryName];
            
            dictCat3 = [NSDictionary dictionaryWithObjectsAndKeys:
                        strCategoryId, categoryId,
                        strCategoryName, categoryName,
                        nil];
            [myCategory3 addObject:dictCat3];
        }
        
        _actionSheetCategory3 = [[UIActionSheet alloc] initWithTitle:@"Category 3" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
        
        for (NSDictionary *item in myCategory3)
        {
            [_actionSheetCategory3 addButtonWithTitle:[item objectForKey:categoryName]];
        }
        
        [_actionSheetCategory3 addButtonWithTitle:@"Cancel"];
        _actionSheetCategory3.cancelButtonIndex = [myCategory3 count];
        
        [_actionSheetCategory3 showInView:self.view];
    }
    else if (actionSheet == _actionSheetCategory3) {
        tmpDictCat3 = [myCategory3 objectAtIndex:buttonIndex];
        NSString *result = [NSString stringWithFormat:@"%@ > %@ > %@", [tmpDictCat1 objectForKey:categoryName], [tmpDictCat2 objectForKey:categoryName], [tmpDictCat3 objectForKey:categoryName]];
        [_btnAuctionCategory setTitle:result forState:UIControlStateNormal];
    }
    
    [self.view endEditing:YES];

}

-(void)callImagePickerWithSourceType:(NSUInteger)type
{
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.delegate = self;
    
    if(type == CAMERA_BUTTON_INDEX && [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    } else {
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    [self presentViewController:picker animated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if ([imageViewTap  isEqual: @"1"]) {
        self.imageViewAuction1.image = info[UIImagePickerControllerOriginalImage];
    } else if ([imageViewTap  isEqual: @"2"]) {
        self.imageViewAuction2.image = info[UIImagePickerControllerOriginalImage];
    } else if ([imageViewTap  isEqual: @"3"]) {
        self.imageViewAuction3.image = info[UIImagePickerControllerOriginalImage];
    } else if ([imageViewTap  isEqual: @"4"]) {
        self.imageViewAuction4.image = info[UIImagePickerControllerOriginalImage];
    } else if ([imageViewTap  isEqual: @"5"]) {
        self.imageViewAuction5.image = info[UIImagePickerControllerOriginalImage];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
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

- (IBAction)btnAuctionDonateClicked:(id)sender
{
    _actionSheetDonate = [[UIActionSheet alloc] initWithTitle:@"Donate to" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    
    for (NSDictionary *item in myFoundation)
    {
        [_actionSheetDonate addButtonWithTitle:[item objectForKey:foundationName]];
    }
    
    [_actionSheetDonate addButtonWithTitle:@"Cancel"];
    _actionSheetDonate.cancelButtonIndex = [myFoundation count];
    
    [_actionSheetDonate showInView:self.view];
}

- (IBAction)btnAuctionCategoryClicked:(id)sender
{
    _actionSheetCategory1 = [[UIActionSheet alloc] initWithTitle:@"Category 1" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    
    for (NSDictionary *item in myCategory1)
    {
        [_actionSheetCategory1 addButtonWithTitle:[item objectForKey:categoryName]];
    }
    
    [_actionSheetCategory1 addButtonWithTitle:@"Cancel"];
    _actionSheetCategory1.cancelButtonIndex = [myCategory1 count];
    
    [_actionSheetCategory1 showInView:self.view];
}

- (IBAction)btnAuctionProConClicked:(id)sender
{
    _actionSheetProCon = [[UIActionSheet alloc] initWithTitle:@"Product Condition" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    
    for (NSDictionary *item in myCondition)
    {
        [_actionSheetProCon addButtonWithTitle:[item objectForKey:conditionName]];
    }
    
    [_actionSheetProCon addButtonWithTitle:@"Cancel"];
    _actionSheetProCon.cancelButtonIndex = [myCondition count];
    
    [_actionSheetProCon showInView:self.view];
}

- (IBAction)btnAuctionEndClicked:(id)sender
{
    _actionSheetEndAuction = [[UIActionSheet alloc] initWithTitle:@"End auction" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    
    for (NSString *item in myEndAuction)
    {
        [_actionSheetEndAuction addButtonWithTitle:[NSString stringWithFormat:@"%@ days", item]];
    }
    
    [_actionSheetEndAuction addButtonWithTitle:@"Cancel"];
    _actionSheetEndAuction.cancelButtonIndex = [myEndAuction count];
    
    [_actionSheetEndAuction showInView:self.view];
}

- (IBAction)btnAuctionShippingClicked:(id)sender
{
    _actionSheetShipping = [[UIActionSheet alloc] initWithTitle:@"Shipping method" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    
    for (NSDictionary *item in myShipping)
    {
        [_actionSheetShipping addButtonWithTitle:[item objectForKey:shippingName]];
    }
    
    [_actionSheetShipping addButtonWithTitle:@"Cancel"];
    _actionSheetShipping.cancelButtonIndex = [myShipping count];
    
    [_actionSheetShipping showInView:self.view];
}
- (IBAction)btnAuctionBiddingClicked:(id)sender
{
    _actionSheetBidCon = [[UIActionSheet alloc] initWithTitle:@"Bidding condition" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    
    for (NSDictionary *item in myBidding)
    {
        [_actionSheetBidCon addButtonWithTitle:[item objectForKey:biddingName]];
    }
    
    [_actionSheetBidCon addButtonWithTitle:@"Cancel"];
    _actionSheetBidCon.cancelButtonIndex = [myBidding count];
    
    [_actionSheetBidCon showInView:self.view];
}


- (IBAction)btnAuctionDateClicked:(id)sender
{
    
    _actionSheetStartAuction= [[UIActionSheet alloc] initWithTitle:@"Start auction" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    
    for (NSString *item in myStartAuction)
    {
        [_actionSheetStartAuction addButtonWithTitle:item];
    }
    
    [_actionSheetStartAuction addButtonWithTitle:@"Cancel"];
    _actionSheetStartAuction.cancelButtonIndex = [myStartAuction count];
    
    [_actionSheetStartAuction showInView:self.view];
}

-(void)dateSelected:(id)sender
{
    self.navigationItem.rightBarButtonItem = nil;
    
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en-US"];
    
    NSDate *pickerDate = [_datePicker date];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setLocale:usLocale];
    [format setDateFormat:@"dd-MM-YYYY HH:mm"];
    NSString *result = [format stringFromDate:pickerDate];
    
    [_btnAuctionDate setTitle:result forState:UIControlStateNormal];
    
    [_datePicker setHidden:TRUE];
}

- (IBAction)btnAddNewAuctionClicked:(id)sender
{
    if ([_txtProductName.text isEqual:@""] ||
        [_txtDescription.text isEqual:@""] ||
        !_btnAuctionProCon.titleLabel.text ||
        !_btnAuctionCategory.titleLabel.text ||
        !_btnAuctionShipping.titleLabel.text ||
        [_txtFee.text isEqual:@""] ||
        [_txtDelivery.text isEqual:@""] ||
        !_btnAuctionDonate.titleLabel.text ||
        [_txtStartPrice.text isEqual:@""] ||
        [_txtAuctionPrice.text isEqual:@""] ||
        !_btnAuctionDate.titleLabel.text ||
        !_btnAuctionEnd.titleLabel.text ||
        !_btnAuctionBidding.titleLabel.text)
    {
        [appDelegate alertBox:@"Oops!" :@"Please fill in all fields"];
        return;
    }
    
    images = [[NSMutableArray alloc] init];
    if (_imageViewAuction1.image) [images addObject:_imageViewAuction1.image];
    if (_imageViewAuction2.image) [images addObject:_imageViewAuction2.image];
    if (_imageViewAuction3.image) [images addObject:_imageViewAuction3.image];
    if (_imageViewAuction4.image) [images addObject:_imageViewAuction4.image];
    if (_imageViewAuction5.image) [images addObject:_imageViewAuction5.image];
    
    if ([images count] < 1) {
        [appDelegate alertBox:@"Oops!" : @"Plase add at least one photo"];
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
        [self newAuction];
    }
}

-(void)newAuction
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject:_txtProductName.text forKey:@"product_name"];
    [params setObject:_txtDescription.text forKey:@"product_detail"];
    [params setObject:[tmpDictCon objectForKey:conditionEnum] forKey:@"product_condition"];
    [params setObject:[tmpDictCat3 objectForKey:categoryId] forKey:@"product_category_id"];
    [params setObject:[tmpDictShip objectForKey:shippingId] forKey:@"shipping_id"];
    [params setObject:_txtFee.text forKey:@"shipping_fee"];
    [params setObject:_txtDelivery.text forKey:@"shipping_deliver_day"];
    [params setObject:[tmpDictFound objectForKey:foundationId] forKey:@"foundation_id"];
    [params setObject:_txtStartPrice.text forKey:@"auction_start_price"];
    [params setObject:_txtAuctionPrice.text forKey:@"auction_min_bidding_price"];
    
    if (![_btnAuctionDate.titleLabel.text  isEqual: @"Now"]) {
        NSString *startUnixTime = [NSString stringWithFormat:@"%.0f", [[_datePicker date] timeIntervalSince1970]];
        [params setObject:startUnixTime forKey:@"auction_start_date"];
    }
    
    [params setObject:tmpEndAuction forKey:@"auction_end_day"];
    [params setObject:[tmpDictCon objectForKey:conditionEnum] forKey:@"auction_condition_id"];
    [params setObject:[prefs objectForKey:@"userId"] forKey:@"user_id"];
    [params setObject:API_KEY forKey:@"x-api-key"];
    
    NSString *url = [NSString stringWithFormat:@"%@/api/product/create.json", BASE_URL];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
     {
         int i = 1;
         for (UIImage *image in images)
         {
             NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
             NSString *paramName = [NSString stringWithFormat:@"product_image_%d", i];
             i++;
             [formData appendPartWithFileData:imageData name:paramName fileName:@"image.jpg" mimeType:@"image/jpeg"];
         }
     }
    success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         
         //id jsonObjects = [appDelegate parseJson:[operation responseString]];
         
         //NSString *productId = [jsonObjects objectForKey:@"product_id"];
         
         //UIStoryboard *storyboard = self.navigationController.storyboard;
         //ProductDetailViewController *productDetail = [storyboard instantiateViewControllerWithIdentifier:@"ProductDetailView"];
         
         //productDetail.productDetailId = productId;
         
         //[self.navigationController pushViewController:productDetail animated:YES];
         
         //NSMutableArray *allView = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
         //[allView removeObjectIdenticalTo:self];
         //self.navigationController.viewControllers = allView;
         
        
         [self.navigationController popViewControllerAnimated:YES];
     }
    failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         
         id jsonObjects = [appDelegate parseJson:[operation responseString]];
         
         NSString *message = [jsonObjects objectForKey:@"message"];
         
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
         [alert show];
         
         alert.delegate = nil;
     }];
    
    
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect aRect = self.view.frame;
    aRect.origin.y -= 60;
    self.view.frame = aRect;

}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    CGRect aRect = self.view.frame;
    aRect.origin.y += 60;
    self.view.frame = aRect;
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
