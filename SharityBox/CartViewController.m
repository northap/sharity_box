//
//  CartViewController.m
//  SharityBox
//
//  Created by North on 5/8/2557 BE.
//  Copyright (c) 2557 North. All rights reserved.
//

#import "CartViewController.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import "AFHTTPRequestOperationManager.h"

@interface CartViewController ()
{
    NSMutableArray *myPayment;
    NSMutableArray *myCountry;
    
    NSDictionary *dictPayment;
    NSDictionary *dictCountry;
    
    NSDictionary *tmpDictPayment;
    NSDictionary *tmpDictCountry;
    
    NSString *paymentName;
    NSString *paymentEnum;
    
    NSString *countryId;
    NSString *countryName;
    
    AppDelegate *appDelegate;
    
    bool firstTime;
}

@end

@implementation CartViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    appDelegate = [[UIApplication sharedApplication] delegate];
    
    paymentName = @"payment_name";
    paymentEnum = @"payment_enum";
    
    countryId = @"location_id";
    countryName = @"location_name";
    
    myPayment = [[NSMutableArray alloc] init];
    myCountry = [[NSMutableArray alloc] init];
    
    [_imageViewCart setClipsToBounds:YES];
    
    [appDelegate changeFontOfView:self.view :@"Thai Sans Lite"];

    dictPayment = [NSDictionary dictionaryWithObjectsAndKeys:
               @"Bank Transfer", paymentName,
               @"BANKTRANSFER", paymentEnum,
               nil];
    [myPayment addObject:dictPayment];
    
    dictPayment = [NSDictionary dictionaryWithObjectsAndKeys:
                   @"Paysbuy Credit Card", paymentName,
                   @"PSBCREDITCARD", paymentEnum,
                   nil];
    [myPayment addObject:dictPayment];
    
    dictPayment = [NSDictionary dictionaryWithObjectsAndKeys:
                   @"Paysbuy Counter Service", paymentName,
                   @"PSBCOUNTERSERVICE", paymentEnum,
                   nil];
    [myPayment addObject:dictPayment];
    
    dictPayment = [NSDictionary dictionaryWithObjectsAndKeys:
                   @"Paysbuy Online Banking", paymentName,
                   @"PSBONLINEBANKING", paymentEnum,
                   nil];
    [myPayment addObject:dictPayment];
    
    firstTime = YES;
}

-(void)viewDidAppear:(BOOL)animated {
    if (firstTime) {
        [self loadCountry];
        firstTime = NO;
    }
}

-(void)loadCountry
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSURL *jsonURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/purchase/location_list/file.json?x-api-key=%@", BASE_URL, API_KEY]];
    NSData *jsonData = [NSData dataWithContentsOfURL:jsonURL];
    
    id jsonObjects = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    
    for (NSDictionary *dataDict in jsonObjects)
    {
        NSString *strCountryId = [dataDict objectForKey:countryId];
        NSString *strCountryName = [dataDict objectForKey:countryName];
        
        dictCountry = [NSDictionary dictionaryWithObjectsAndKeys:
                     strCountryId, countryId,
                     strCountryName, countryName,
                     nil];
        [myCountry addObject:dictCountry];
    }
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    self.tabBarController.navigationItem.hidesBackButton = YES;
    self.tabBarController.navigationItem.titleView = [appDelegate addTitleApp:@"My Cart"];
    self.tabBarController.navigationItem.rightBarButtonItems = nil;
    
    [self getCart];
}

-(void)getCart
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSDictionary *tmpDictCart = [prefs objectForKey:@"cartProduct"];
    
    if (tmpDictCart) {
        [_viewCart setHidden:NO];
        NSString *imName =[[NSString alloc] initWithFormat:@"%@/files/product_images/%@", BASE_URL, [tmpDictCart objectForKey:@"image_file"]];
        
        NSData *imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:imName]];
        
        _imageViewCart.image = [[UIImage alloc] initWithData:imageData];
        _cartName.text = [tmpDictCart objectForKey:@"product_name"];
        _cartPrice.text = [NSString stringWithFormat: @"฿ %@", [tmpDictCart objectForKey:@"auction_last_price"]];
        _cartTotalPrice.text = [NSString stringWithFormat: @"฿ %@", [tmpDictCart objectForKey:@"auction_last_price"]];
    }
    else {
        [_viewCart setHidden:YES];
    }

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
    
    if (actionSheet == _actionSheetPayment) {
        tmpDictPayment = [myPayment objectAtIndex:buttonIndex];
        [_btnPayment setTitle:[tmpDictPayment objectForKey:paymentName] forState:UIControlStateNormal];
    }
    else if (actionSheet == _actionSheetCountry) {
        tmpDictCountry = [myCountry objectAtIndex:buttonIndex];
        [_btnCountry setTitle:[tmpDictCountry objectForKey:countryName] forState:UIControlStateNormal];
    }
    
}

- (IBAction)btnPaymentClicked:(id)sender
{
    _actionSheetPayment = [[UIActionSheet alloc] initWithTitle:@"Payment Method" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    
    for (NSDictionary *item in myPayment)
    {
        [_actionSheetPayment addButtonWithTitle:[item objectForKey:paymentName]];
    }
    
    [_actionSheetPayment addButtonWithTitle:@"Cancel"];
    _actionSheetPayment.cancelButtonIndex = [myPayment count];
    
    [_actionSheetPayment showInView:self.view];
}

- (IBAction)btnCheckoutClicked:(id)sender
{
    if ([_txtFirstname.text isEqual:@""] ||
        [_txtLastname.text isEqual:@""] ||
        [_txtAddress.text isEqual:@""] ||
        [_txtPostcode.text isEqual:@""] ||
        !_btnCountry.titleLabel.text ||
        !_btnPayment.titleLabel.text) {
        [appDelegate alertBox:@"Oops!" :@"Please fill in all fields"];
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSDictionary *tmpDictCart = [prefs objectForKey:@"cartProduct"];
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject:[prefs objectForKey:@"userId"] forKey:@"user_id"];
    [params setObject:[tmpDictCart objectForKey:@"product_id"] forKey:@"product_id"];
    [params setObject:_txtFirstname.text forKey:@"first_name"];
    [params setObject:_txtLastname.text forKey:@"last_name"];
    [params setObject:_txtAddress.text forKey:@"address"];
    [params setObject:_txtPostcode.text forKey:@"postcode"];
    [params setObject:[tmpDictCountry objectForKey:countryId] forKey:@"country_id"];
    [params setObject:[tmpDictPayment objectForKey:paymentEnum] forKey:@"payment_type"];
    [params setObject:API_KEY forKey:@"x-api-key"];
    
    NSString *url = [NSString stringWithFormat:@"%@/api/purchase/create_order.json", BASE_URL];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         
         id jsonObjects = [appDelegate parseJson:[operation responseString]];
         
         NSString *message = [jsonObjects objectForKey:@"message"];
         
         NSDictionary *userData = [jsonObjects objectForKey:@"data"];
         NSString *orderId = [userData objectForKey:@"order_id"];
         
         [appDelegate setOrderStatus:orderId :@"1"];
         
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
         [alert show];
         
         [prefs setObject:nil forKey:@"cartProduct"];
         [_viewCart setHidden:YES];
         
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

- (IBAction)btnCountryClicked:(id)sender
{
    _actionSheetCountry = [[UIActionSheet alloc] initWithTitle:@"Country" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    
    for (NSDictionary *item in myCountry)
    {
        [_actionSheetCountry addButtonWithTitle:[item objectForKey:countryName]];
    }
    
    [_actionSheetCountry addButtonWithTitle:@"Cancel"];
    _actionSheetCountry.cancelButtonIndex = [myCountry count];
    
    [_actionSheetCountry showInView:self.view];
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
