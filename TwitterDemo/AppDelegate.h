//
//  AppDelegate.h
//  TwitterDemo
//
//  Created by Jeremy Lawrence on 6/18/15.
//  Copyright (c) 2015 Ziewvater. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <STTwitter/STTwitter.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) STTwitterAPI *twitterAPI;

@end

