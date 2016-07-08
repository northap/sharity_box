//
//  ProductTableViewController.m
//  SharityBox
//
//  Created by North on 5/8/2557 BE.
//  Copyright (c) 2557 North. All rights reserved.
//

#import "ProductTableViewController.h"
#import "ProductTableViewCell.h"
#import "ProductDetailViewController.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import "AFHTTPRequestOperationManager.h"

@interface ProductTableViewController ()
{
    AppDelegate *appDelegate;
    
    NSMutableArray *myObject;
    
    NSDictionary *dict;
    
    NSString *image;
    NSString *name;
    NSString *price;
    NSString *time;
    NSString *productId;
    NSString *bidderCount;
    
    int countRefresh;
    
    bool firstTime;
}
@end

@implementation ProductTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.imageDownloadingQueue = [[NSOperationQueue alloc] init];
    self.imageDownloadingQueue.maxConcurrentOperationCount = 4;
    self.imageCache = [[NSCache alloc] init];
    
    appDelegate = [[UIApplication sharedApplication] delegate];
    
    image = @"image_file";
    name = @"product_name";
    price = @"auction_last_price";
    time = @"auction_end_date";
    productId = @"product_id";
    bidderCount = @"bidder_count";
    
    myObject = [[NSMutableArray alloc] init];
    
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.backgroundColor = [UIColor colorWithRed:243.0f/255.0f green:243.0f/255.0f blue:243.0f/255.0f alpha:1.0f];
    
    if (IS_OS_7_OR_LATER) {
        self.edgesForExtendedLayout = UIRectEdgeAll;
        self.tableView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, CGRectGetHeight(self.tabBarController.tabBar.frame), 0.0f);
    }
    
    [[UITabBar appearance] setBackgroundColor:[UIColor whiteColor]];
    [[UITabBar appearance] setSelectedImageTintColor:[UIColor colorWithRed:0.0f/255.0f green:165.0f/255.0f blue:197.0f/255.0f alpha:1.0f]];
    
    firstTime = YES;
    
    [self startTimer];

}

-(void)viewDidAppear:(BOOL)animated {
    if (firstTime) {
        [self loadProducts];
        firstTime = NO;
    }
}

-(void)viewWillDisappear:(BOOL)animated {
    self.tabBarController.delegate = nil;
}

-(void)loadProducts
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSURL *jsonURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/product/all/limit/50/page/1.json?x-api-key=%@", BASE_URL, API_KEY]];
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
    
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:time ascending:YES];
    NSArray *sortObject = [myObject sortedArrayUsingDescriptors:[NSArray arrayWithObjects:descriptor, nil]];
    myObject = [NSMutableArray arrayWithArray:sortObject];
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

-(void)startTimer
{
    if (!_timer) {
        countRefresh = 0;
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateCounter:) userInfo:nil repeats:YES];
    }
}

-(void)stopTimer
{
    if ([_timer isValid]) {
        [_timer invalidate];
    }
    _timer = nil;
}

-(void)viewWillAppear:(BOOL)animated {
    self.tabBarController.navigationItem.hidesBackButton = YES;
    self.tabBarController.navigationItem.rightBarButtonItems = nil;
    self.tabBarController.navigationItem.titleView = [appDelegate addTitleIconApp];
    
    self.tabBarController.delegate = self;
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

-(void)parserDidEndDocument:(NSXMLParser *)parser
{
     [MBProgressHUD hideHUDForView:self.view animated:YES];
}

-(void)updateCounter:(NSTimer *)theTimer
{
    countRefresh += 1;
    if (countRefresh >= TIMER_REFRESH)
    {
        countRefresh = 0;
        [self loadProducts];
    }
    
    [self.tableView reloadData];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
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
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
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
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
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

-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    if ([viewController class] == [self class]) {
        [self loadProducts];
        [self.tableView reloadData];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end