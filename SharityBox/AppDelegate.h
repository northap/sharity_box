//
//  AppDelegate.h
//  ;
//
//  Created by North on 5/8/2557 BE.
//  Copyright (c) 2557 North. All rights reserved.
//

#import <UIKit/UIKit.h>

#define IS_OS_7_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
#define TIMER_REFRESH 60

static const NSString *BASE_URL = @"http://demo.mojistudio.com/sharity_box";
static const NSString *API_KEY = @"d34a90080469b364f40e378f60ed12d7";

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
-(UIView *) addTitleIconApp;
-(NSData*)encodeDictionary:(NSDictionary*)dictionary;
//-(NSString*)postMethod:(NSMutableDictionary*)params :(NSURL*)url;
-(NSInteger)daysBetweenDate:(NSDate*)fromDateTime andDate:(NSDate*)toDateTime;
//-(NSString*)postMethodwithImage:(NSMutableDictionary*)params :(NSURL*)url :(NSMutableArray*)images;
-(void)alertBox:(NSString*)title :(NSString*)msg;
-(void)setOrderStatus:(NSString*)orderId :(NSString*)statusId;
-(void)changeFontOfView:(UIView*)view :(NSString*)fontName;
- (UIView *)addTitleApp:(NSString*)title;
-(id)parseJson:(NSString*)result;
-(NSString*)getCountTime:(NSDate*)futureDate;
-(UIColor*)getColorTime:(NSDate*)futureDate;
-(NSString*)getRankImage :(NSString*)rank;
-(NSMutableAttributedString*)getUnderline :(NSString*)text;
- (CGFloat)widthOfString:(NSString *)string withFont:(UIFont *)font;
@end
