//
//  AttitudeTableViewController.m
//  SharityBox
//
//  Created by North on 6/22/2557 BE.
//  Copyright (c) 2557 North. All rights reserved.
//

#import "AttitudeTableViewController.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import "AFHTTPRequestOperationManager.h"
#import "ProductDetailViewController.h"
#import "ProductTableViewCell.h"

@interface AttitudeTableViewController ()
{
    AppDelegate *appDelegate;
    
    NSMutableArray *myPositive;
    NSMutableArray *myNatural;
    NSMutableArray *myNegative;
    
    NSString *image;
    NSString *name;
    NSString *price;
    NSString *time;
    NSString *productId;
    NSString *auctionRate;
    
    NSDictionary *dict;
}
@end

@implementation AttitudeTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    appDelegate = [[UIApplication sharedApplication] delegate];
    
    self.imageDownloadingQueue = [[NSOperationQueue alloc] init];
    self.imageDownloadingQueue.maxConcurrentOperationCount = 4;
    self.imageCache = [[NSCache alloc] init];
    
    myNatural = [[NSMutableArray alloc] init];
    myNegative = [[NSMutableArray alloc] init];
    myPositive = [[NSMutableArray alloc] init];
    
    image = @"image_file";
    name = @"product_name";
    price = @"auction_last_price";
    time = @"auction_end_date";
    productId = @"product_id";
    auctionRate = @"auction_rate";
    
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.backgroundColor = [UIColor colorWithRed:243.0f/255.0f green:243.0f/255.0f blue:243.0f/255.0f alpha:1.0f];
    
    self.navigationItem.titleView = [appDelegate addTitleApp :self.userName];
    if (IS_OS_7_OR_LATER) {
        self.navigationController.navigationBar.topItem.title = @"";
    }
}

-(void)viewDidAppear:(BOOL)animated {
    [self loadAttitude];
}

-(void)loadAttitude
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    NSString *userId = [prefs objectForKey:@"userId"];
    
    NSURL *jsonURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/user/feedback/id/%@.json?x-api-key=%@", BASE_URL, userId, API_KEY]];
    NSData *jsonData = [NSData dataWithContentsOfURL:jsonURL];
    
    id jsonObjects = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    
    [myPositive removeAllObjects];
    [myNegative removeAllObjects];
    [myNatural removeAllObjects];
    
    @try {
        for (NSDictionary *dataDict in jsonObjects)
        {
            NSString *strImage = [NSString stringWithFormat:@"%@", [dataDict objectForKey:image]];
            NSString *strName = [NSString stringWithFormat:@"%@", [dataDict objectForKey:name]];
            NSString *strPrice = [NSString stringWithFormat:@"%@", [dataDict objectForKey:price]];
            NSString *strTime = [NSString stringWithFormat:@"%@", [dataDict objectForKey:time]];
            NSString *strProductId = ([dataDict objectForKey:productId]) ? [dataDict objectForKey:productId] : [NSNull null];
            NSString *strAuctionRate = ([dataDict objectForKey:auctionRate]) ? [dataDict objectForKey:auctionRate] : [NSNull null];
            
            dict = [NSDictionary dictionaryWithObjectsAndKeys:
                    strImage, image,
                    strName, name,
                    strPrice, price,
                    strTime, time,
                    strProductId, productId,
                    strAuctionRate, auctionRate,
                    nil];
            
            if ([strAuctionRate isEqualToString:@"1"]) {
                [myPositive addObject:dict];
            }
            else if ([strAuctionRate isEqualToString:@"0"]) {
                [myNatural addObject:dict];
            }
            else if ([strAuctionRate isEqualToString:@"-1"]) {
                [myNegative addObject:dict];
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
    return 27;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 18)];
    /* Create custom view to display section header... */
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, tableView.frame.size.width, 18)];
    [label setFont:[UIFont fontWithName:@"Thai Sans Lite" size:14]];
    
    NSString *string;
    
            switch (section) {
                case 0:
                    if ([myPositive count] > 0) {
                        string = [NSString stringWithFormat:@"%lu Positive",(unsigned long)[myPositive count]];
                    }
                    else {
                        return nil;
                    }
                    break;
                case 1:
                    if ([myNatural count] > 0) {
                        string = [NSString stringWithFormat:@"%lu Natural", (unsigned long)[myNatural count]];
                    }
                    else {
                        return nil;
                    }
                    break;
                case 2:
                    if ([myNegative count] > 0) {
                        string = [NSString stringWithFormat:@"%lu Negative", (unsigned long)[myNegative count]];
                    }
                    else {
                        return nil;
                    }
                    break;
            }
    
    [label setText:string];
    [view addSubview:label];
    
    [view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"header_list_bg.png"]]];
    
    return view;
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    int i = 0;
    if ([myPositive count] > 0) {
        i = i +1;
    }
    if ([myNatural count] > 0) {
        i = i +1;
    }
    if ([myNegative count] > 0) {
        i = i +1;
    }
    return i;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return [myPositive count];
        case 1:
            return [myNatural count];
        case 2:
            return [myNegative  count];
        default:
            return 0;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *storyboard = self.navigationController.storyboard;
    ProductDetailViewController *productDetail = [storyboard instantiateViewControllerWithIdentifier:@"ProductDetailView"];
    
    NSDictionary *tmpDict;
    
    switch (indexPath.section) {
        case 0:
            tmpDict = [myPositive objectAtIndex:indexPath.row];
            break;
        case 1:
            tmpDict = [myNatural objectAtIndex:indexPath.row];
            break;
        case 2:
            tmpDict = [myNegative objectAtIndex:indexPath.row];
            break;
        default:
            break;
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
    

            switch (indexPath.section) {
                case 0:
                    tmpDict = [myPositive objectAtIndex:indexPath.row];
                    break;
                case 1:
                    tmpDict = [myNatural objectAtIndex:indexPath.row];
                    break;
                case 2:
                    tmpDict = [myNegative objectAtIndex:indexPath.row];
                    break;
                default:
                    break;
            }
        
        [cell.btnBid setHidden:YES];
        [cell.btnWatch setHidden:YES];

    
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

@end
