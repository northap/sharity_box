//
//  SecondViewController.m
//  SharityBox
//
//  Created by North on 5/8/2557 BE.
//  Copyright (c) 2557 North. All rights reserved.
//

#import "SearchViewController.h"
#import "AppDelegate.h"
#import "ProductTableViewCell.h"
#import "ProductDetailViewController.h"
#import "MBProgressHUD.h"
#import "AFHTTPRequestOperationManager.h"

@interface SearchViewController ()
{
    AppDelegate *appDelegate;
    
    NSMutableArray *myFoundation;
    
    NSString *foundationId;
    NSString *foundationName;
    
    NSDictionary *dictFound;
    
    NSInteger indexFound;
    
    NSMutableArray *myObject;
    
    NSDictionary *dict;
    
    NSString *image;
    NSString *name;
    NSString *price;
    NSString *time;
    NSString *productId;
    NSString *bidderCount;
    
    bool firstTime;
}

@end

@implementation SearchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.imageDownloadingQueue = [[NSOperationQueue alloc] init];
    self.imageDownloadingQueue.maxConcurrentOperationCount = 4;
    self.imageCache = [[NSCache alloc] init];
    
    appDelegate = [[UIApplication sharedApplication] delegate];
    
    [appDelegate changeFontOfView:self.view :@"Thai Sans Lite"];
    
    foundationId = @"foundation_id";
    foundationName = @"foundation_name";

    myFoundation = [[NSMutableArray alloc] init];
    
    dictFound = [NSDictionary dictionaryWithObjectsAndKeys:
                 @"0", foundationId,
                 @"All Foundation", foundationName,
                 nil];
    [myFoundation addObject:dictFound];
    
    image = @"image_file";
    name = @"product_name";
    price = @"auction_last_price";
    time = @"auction_end_date";
    productId = @"product_id";
    bidderCount = @"bidder_count";
    
    myObject = [[NSMutableArray alloc] init];
    
    _tableViewSearch.separatorColor = [UIColor clearColor];
    
    indexFound = 0;
    [_dropDownFoundation setTitle:[dictFound objectForKey:foundationName] forState:UIControlStateNormal];
    
    firstTime = YES;
    
    [self startTimer];
}

-(void)viewDidAppear:(BOOL)animated {
    if (firstTime) {
        [self loadFoundation];
        firstTime = NO;
    }
}

-(void)startTimer
{
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateCounter:) userInfo:nil repeats:YES];
    }
}

-(void)updateCounter:(NSTimer *)theTimer
{
    [self.tableViewSearch reloadData];
}

-(void)loadFoundation
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
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
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

-(void)viewWillAppear:(BOOL)animated {
    self.tabBarController.navigationItem.titleView = [appDelegate addTitleApp:@"Search Auction"];
    self.tabBarController.navigationItem.hidesBackButton = YES;
    self.tabBarController.navigationItem.rightBarButtonItems = nil;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == actionSheet.cancelButtonIndex) {
        return;
    }
    else  {
        indexFound = buttonIndex;
        NSDictionary *tmpDict = [myFoundation objectAtIndex:buttonIndex];
        [_dropDownFoundation setTitle:[tmpDict objectForKey:foundationName] forState:UIControlStateNormal];
    }
}

- (IBAction)dropDownFoundationClicked:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Foundation" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    
    for (NSDictionary *item in myFoundation)
    {
        [actionSheet addButtonWithTitle:[item objectForKey:foundationName]];
    }
    
    [actionSheet addButtonWithTitle:@"Cancel"];
    actionSheet.cancelButtonIndex = [myFoundation count];
    
    [actionSheet showInView:self.view];
}

- (IBAction)btnSearchClicked:(id)sender
{
    if ([_txtSearchKeyword.text isEqual:@""] ||
        !_dropDownFoundation.titleLabel.text)
    {
        [appDelegate alertBox:@"Oops!" :@"Please fill in all fields"];
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSDictionary *tmpDict = [myFoundation objectAtIndex:indexFound];
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject:_txtSearchKeyword.text forKey:@"query_string"];
    [params setObject:[tmpDict objectForKey:foundationId] forKey:@"foundation_id"];
    //[params setObject: forKey:@"page"];
    //[params setObject: forKey:@"limit"];
    [params setObject:API_KEY forKey:@"x-api-key"];
    
    NSString *url = [NSString stringWithFormat:@"%@/api/product/search.json", BASE_URL];
    
    [myObject removeAllObjects];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         id jsonObjects = [appDelegate parseJson:[operation responseString]];
         
         @try {
             for (NSDictionary *dataDict in jsonObjects)
             {
                 NSString *strImage = [dataDict objectForKey:image];
                 NSString *strName = [dataDict objectForKey:name];
                 NSString *strPrice = [dataDict objectForKey:price];
                 NSString *strTime = [dataDict objectForKey:time];
                 NSString *strProductId = [dataDict objectForKey:productId];
                 NSString *strBidderCount = [dataDict objectForKey:bidderCount];
                 
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
             
             _labelSearchResult.text = [NSString stringWithFormat: @"Result %lu items",(unsigned long)[myObject count]];
             
             [self.view endEditing:YES];
             [self.tableViewSearch reloadData];

         }
         @catch (NSException *exception)
         {
             NSString *error = [jsonObjects objectForKey:@"error"];
             
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:error delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
             [alert show];

             return;
         }
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return myObject.count;
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
    
    NSDictionary *tmpDict = [myObject objectAtIndex:indexPath.row];
    
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
    
    cell.btnBid.tag = indexPath.row;
    [cell.btnBid addTarget:self action:@selector(btnBidClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.btnWatch.tag = indexPath.row;
    [cell.btnWatch addTarget:self action:@selector(btnWatchClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
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
    
    NSDictionary *tmpDict = [myObject objectAtIndex:indexPath.row];
    productDetail.productDetailId = [tmpDict objectForKey:productId];
    
    [self.navigationController pushViewController:productDetail animated:YES];
}

- (IBAction)btnWatchClicked:(UIButton *)sender
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSDictionary *tmpDict = [myObject objectAtIndex:sender.tag];
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject:[prefs objectForKey:@"userId"] forKey:@"user_id"];
    [params setObject:[tmpDict objectForKey:productId] forKey:@"product_id"];
    [params setObject:API_KEY forKey:@"x-api-key"];
    
    NSString *url = [NSString stringWithFormat:@"%@/api/user/add_favorite.json", BASE_URL];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         id jsonObjects = [appDelegate parseJson:[operation responseString]];
         
         NSString *message = [jsonObjects objectForKey:@"message"];
         
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
         [alert show];
     }
    failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         id jsonObjects = [appDelegate parseJson:[operation responseString]];
         
         NSString *message = [jsonObjects objectForKey:@"message"];
         
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
         [alert show];
     }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
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
