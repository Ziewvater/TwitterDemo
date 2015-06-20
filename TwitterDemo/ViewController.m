//
//  ViewController.m
//  TwitterDemo
//
//  Created by Jeremy Lawrence on 6/18/15.
//  Copyright (c) 2015 Ziewvater. All rights reserved.
//

#import "ViewController.h"
#import <STTwitter/STTwitter.h>
#import "AppDelegate.h"

NSString * const ZWVTwitterConsumerKey = @"hANqfzJFoKWLLrmEJPXyDysVe";
NSString * const ZWVTwitterConsumerSecret = @"jLoCcwulOCLD2IY11Vs5U1KudJ77QFkqoJzecsH27MzS3yKw3g";

@interface ViewController ()
<UIAlertViewDelegate>

@property (strong, nonatomic) STTwitterAPI *twitterAPI;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)logInButtonTapped:(UIButton *)sender {
    NSLog(@"Authenticating");
    __weak __typeof(self)weakSelf = self;
    STTwitterAPI *twitterAPI = [STTwitterAPI twitterAPIWithOAuthConsumerKey:ZWVTwitterConsumerKey consumerSecret:ZWVTwitterConsumerSecret];
    [twitterAPI postReverseOAuthTokenRequest:^(NSString *authenticationHeader) {
        STTwitterAPI *api = [STTwitterAPI twitterAPIOSWithFirstAccount];
        [api verifyCredentialsWithUserSuccessBlock:^(NSString *username, NSString *userID) {
            [api postReverseAuthAccessTokenWithAuthenticationHeader:authenticationHeader
                                                       successBlock:^(NSString *oAuthToken, NSString *oAuthTokenSecret, NSString *userID, NSString *screenName) {
                                                           AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                                                           delegate.twitterAPI = api;
                                                           NSLog(@"Cool you logged in");
                                                           [weakSelf loggedIn];
                                                       }
                                                         errorBlock:^(NSError *error) {
                                                             [weakSelf loggedIn];
                                                             NSLog(@"Failed to post reverse auth: %@", error);
                                                         }];
        }
                                        errorBlock:^(NSError *error) {
                                            NSLog(@"Failed to verify; %@", error);
                                        }];
    } errorBlock:^(NSError *error) {
        NSLog(@"Failed to post OAuth: %@", error);
    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == alertView.cancelButtonIndex) {
        return;
    }
    
}

- (void)loggedIn {
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"Search"];
//    [self.navigationController pushViewController:vc animated:YES];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"MapSearch"];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
