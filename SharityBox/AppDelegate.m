//
//  AppDelegate.m
//  SharityBox
//
//  Created by North on 5/8/2557 BE.
//  Copyright (c) 2557 North. All rights reserved.
//

#import "AppDelegate.h"
#import "AFHTTPRequestOperationManager.h"

@implementation AppDelegate

- (UIView *)addTitleIconApp
{
    UIImage *image = [UIImage imageNamed:@"logo_new.png"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage: image];
    imageView.frame = CGRectMake(0, 0, 95, 35);
    
    //UILabel *tmpTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(115, 7, 110, 25)];
    //tmpTitleLabel.text = @"Sharity Box";
    //tmpTitleLabel.font = [UIFont fontWithName:@"CenturyGothic-Bold" size:18];
    //tmpTitleLabel.backgroundColor = [UIColor clearColor];
    //tmpTitleLabel.textColor = [UIColor whiteColor];
    
    CGRect applicationFrame = CGRectMake(112.5, 4.5, 95, 35);
    UIView *newView = [[UIView alloc] initWithFrame:applicationFrame];
    [newView addSubview:imageView];
    //[newView addSubview:tmpTitleLabel];
    return newView;
}

- (NSData*)encodeDictionary:(NSDictionary*)dictionary {
    NSMutableArray *parts = [[NSMutableArray alloc] init];
    for (NSString *key in dictionary) {
        NSString *encodedValue = [[dictionary objectForKey:key] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *encodedKey = [key stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *part = [NSString stringWithFormat: @"%@=%@", encodedKey, encodedValue];
        [parts addObject:part];
    }
    NSString *encodedDictionary = [parts componentsJoinedByString:@"&"];
    return [encodedDictionary dataUsingEncoding:NSUTF8StringEncoding];
}

-(id)parseJson:(NSString*)result
{
    NSData *jsonData = [result dataUsingEncoding:NSUTF8StringEncoding];
    
    id jsonObjects = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    
    return jsonObjects;
}

-(NSString*)postMethod:(NSMutableDictionary*)params :(NSURL*)url
{
    
    NSMutableData *postData = [NSMutableData data];
    
    NSString *boundary = @"unique-consistent-string";
    
    for (NSString *param in params) {
        [postData appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [postData appendData:[[NSString stringWithFormat:@"Content-Type: text/plain\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [postData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", param] dataUsingEncoding:NSUTF8StringEncoding]];
        [postData appendData:[[NSString stringWithFormat:@"%@\r\n", [params objectForKey:param]] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
 
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    [request setHTTPBody:postData];
    
    NSHTTPURLResponse *urlResponse = nil;
    NSError *error = [[NSError alloc] init];
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    NSString *result = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    
    return result;
}

-(NSString*)postMethodwithImage:(NSMutableDictionary*)params :(NSURL*)url :(NSMutableArray*)images
{
    
    NSMutableData *postData = [NSMutableData data];
    
    NSString *boundary = @"unique-consistent-string";
    int i = 1;
    
    for (UIImage *image in images)
    {
        NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
    
        [postData appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        NSString *paramName = [NSString stringWithFormat:@"product_image_%d", i];
        i++;
        [postData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=%@; filename=imageName.jpg\r\n", paramName] dataUsingEncoding:NSUTF8StringEncoding]];
        [postData appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [postData appendData:imageData];
        [postData appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    
    }
    
    for (NSString *param in params) {
        [postData appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [postData appendData:[[NSString stringWithFormat:@"Content-Type: text/plain\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [postData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", param] dataUsingEncoding:NSUTF8StringEncoding]];
        [postData appendData:[[NSString stringWithFormat:@"%@\r\n", [params objectForKey:param]] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [postData appendData:[[NSString stringWithFormat:@"\r\n\r\n--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    [request setHTTPBody:postData];
    
    NSHTTPURLResponse *urlResponse = nil;
    NSError *error = [[NSError alloc] init];
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    NSString *result = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
   
    return result;
}

- (NSInteger)daysBetweenDate:(NSDate*)fromDateTime andDate:(NSDate*)toDateTime
{
    NSDate *fromDate;
    NSDate *toDate;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar rangeOfUnit:NSDayCalendarUnit startDate:&fromDate
                 interval:NULL forDate:fromDateTime];
    [calendar rangeOfUnit:NSDayCalendarUnit startDate:&toDate
                 interval:NULL forDate:toDateTime];
    
    NSDateComponents *difference = [calendar components:NSDayCalendarUnit
                                               fromDate:fromDate toDate:toDate options:0];
    
    return ([difference day] < 0) ? 0 : [difference day];
}

-(NSString*)getCountTime:(NSDate*)futureDate
{
    NSDate *nowDate = [NSDate date];
    long elapsedSeconds = [futureDate timeIntervalSinceDate:nowDate];
    NSString *result;
    
    if (elapsedSeconds >= 86400) {
        NSInteger dif = [self daysBetweenDate:nowDate andDate:futureDate];
        result = [NSString stringWithFormat:@"%d Days", (int)dif];
    }
    else if (elapsedSeconds < 86400 && elapsedSeconds >= 3600){
        int minutes = (elapsedSeconds / 60) % 60;
        int hours = elapsedSeconds / (60 * 60);
        result = [NSString stringWithFormat:@"%02d Hours %02d Min", hours, minutes];
    }
    else if (elapsedSeconds < 3600 && elapsedSeconds >= 60){
        int seconds = elapsedSeconds % 60;
        int minutes = (elapsedSeconds / 60) % 60;
        result = [NSString stringWithFormat:@"%02d Min %02d Sec", minutes, seconds];
    }
    else if (elapsedSeconds < 60 && elapsedSeconds > 0) {
        int seconds = elapsedSeconds % 60;
        result = [NSString stringWithFormat:@"%02d Sec", seconds];
    }
    else {
        result = @"-";
    }
    
    return result;
}

-(UIColor*)getColorTime:(NSDate*)futureDate
{
    NSDate *nowDate = [NSDate date];
    long elapsedSeconds = [futureDate timeIntervalSinceDate:nowDate];
    UIColor *result;
    
    if (elapsedSeconds < 3600){
        result = [UIColor redColor];
    }
    else {
        result = [UIColor colorWithRed:0.0f/255.0f green:165.0f/255.0f blue:197.0f/255.0f alpha:1.0f];;
    }
    
    return result;
}

-(void)alertBox:(NSString*)title :(NSString*)msg
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Thai Sans Lite" size:14.5], UITextAttributeFont, nil] forState:UIControlStateNormal];

    return YES;
}

-(void)setOrderStatus:(NSString*)orderId :(NSString*)statusId
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];

    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject:orderId forKey:@"order_id"];
    [params setObject:statusId forKey:@"status_id"];
    [params setObject:[prefs objectForKey:@"userId"] forKey:@"user_id"];
    [params setObject:API_KEY forKey:@"x-api-key"];
    
    NSString *url = [NSString stringWithFormat:@"%@/api/purchase/set_status.json", BASE_URL];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         id jsonObjects = [self parseJson:[operation responseString]];
         
         NSString *message = [jsonObjects objectForKey:@"message"];
         
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
         [alert show];
         
     }
          failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         id jsonObjects = [self parseJson:[operation responseString]];
         
         NSString *message = [jsonObjects objectForKey:@"message"];
         
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
         [alert show];
     }];

}

-(void)changeFontOfView:(UIView*)view :(NSString*)fontName
{
    for (UIView *v in view.subviews) {
        if ([v isKindOfClass:[UIButton class]])
        {
            UIButton *btn = (UIButton *)v;
            CGFloat fontSize = btn.titleLabel.font.pointSize;
            btn.titleLabel.font = [UIFont fontWithName:fontName size:fontSize];
        }
        else if ([v isKindOfClass:[UILabel class]])
        {
            UILabel *lbl = (UILabel *)v;
            CGFloat fontSize = lbl.font.pointSize;
            [lbl setFont:[UIFont fontWithName:fontName size:fontSize]];
        }
        else if ([v isKindOfClass:[UITextView class]])
        {
            UITextView *txt = (UITextView *)v;
            CGFloat fontSize = txt.font.pointSize;
            [txt setFont:[UIFont fontWithName:fontName size:fontSize]];
        }
        else if ([v isKindOfClass:[UITextField class]])
        {
            UITextField *txt = (UITextField *)v;
            CGFloat fontSize = txt.font.pointSize;
            [txt setFont:[UIFont fontWithName:fontName size:fontSize]];
        }
        else if ([v isKindOfClass:[UIView class]]||[v isKindOfClass:[UIScrollView class]])
        {
            if (view.subviews.count == 0)return;
            [self changeFontOfView:v :fontName];
        }
    }
}

- (UIView *)addTitleApp:(NSString*)title
{
    UIFont* titleFont = [UIFont fontWithName:@"CenturyGothic-Bold" size:18];
    CGSize requestedTitleSize = [title sizeWithFont:titleFont];
    CGFloat titleWidth = MIN([self widthOfString:title withFont:titleFont], requestedTitleSize.width);
    
    UILabel *navLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, titleWidth, 21)];
    navLabel.backgroundColor = [UIColor clearColor];
    navLabel.textColor = [UIColor colorWithRed:0.0f/255.0f green:165.0f/255.0f blue:197.0f/255.0f alpha:1.0f];
    navLabel.font = [UIFont fontWithName:@"CenturyGothic-Bold" size:18];
    //navLabel.textAlignment = UITextAlignmentCenter;
    navLabel.text = title;
    
    return navLabel;
}

- (CGFloat)widthOfString:(NSString *)string withFont:(UIFont *)font {
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
    return [[[NSAttributedString alloc] initWithString:string attributes:attributes] size].width;
}

-(NSString*)getRankImage :(NSString*)rank
{
    if ([rank isEqual:[NSNull null]]) {
        return @"";
    }
    
    int rankNum = [rank intValue];
    
    if (rankNum >= 100) {
        return @"Heart100.png";
    }
    else if (rankNum >= 50) {
        return @"Heart50.png";
    }
    else if (rankNum >= 20) {
        return @"Heart20.png";
    }
    else if (rankNum >= 10) {
        return @"Heart10.png";
    }
    else if (rankNum == 0) {
        return @"Heart0.png";
    }
    else if (rankNum < 0 && rankNum >= -5) {
        return @"Heart-1.png";
    }
    else {
        return @"Heart-5-2.png";
    }
}

-(NSMutableAttributedString*)getUnderline :(NSString*)text
{
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:text];
    [attributeString addAttribute:NSUnderlineStyleAttributeName
                            value:[NSNumber numberWithInt:1]
                            range:(NSRange){0,[attributeString length]}];
    return [attributeString copy];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
