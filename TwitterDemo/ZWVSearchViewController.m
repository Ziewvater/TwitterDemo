//
//  ZWVSearchViewController.m
//  TwitterDemo
//
//  Created by Jeremy Lawrence on 6/19/15.
//  Copyright (c) 2015 Ziewvater. All rights reserved.
//

#import "ZWVSearchViewController.h"
#import "ZWVTwitterHandler.h"
#import "ZWVTweet.h"
#import "ZWVTweetTableViewCell.h"
@import Accounts;
#import <STTwitter/STTwitterOS.h>

@interface ZWVSearchViewController()

@property (strong, nonatomic) NSString *searchTerm; // Hold on to search term in case user changes string in search bar without starting new search
@property (strong, nonatomic) NSArray *searchResults; // [ZWVTweet]

@property (strong, nonatomic) ZWVTweetTableViewCell *calculationCell;

@end

@implementation ZWVSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.searchBar.placeholder = @"Search tweets by keyword";
    
    self.tableView.estimatedRowHeight = 67.0f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    ZWVTwitterHandler *twitter = [ZWVTwitterHandler shared];
    if (!twitter.twitterAPI) {
        self.searchBar.userInteractionEnabled = NO; // Disable to prevent searching without authorization
        if ([[[[ACAccountStore alloc] init] accountTypeWithAccountTypeIdentifier: ACAccountTypeIdentifierTwitter] accessGranted]) {
            // The user has already granted access to Twitter accounts, authorize
            __weak __typeof(self)weakSelf = self;
            [twitter performReverseAuthentication:^(STTwitterAPI *twitterAPI) {
                weakSelf.searchBar.userInteractionEnabled = YES;
            } errorHandler:^(NSError *error) {
                //
            }];
        } else {
            // Not yet given access to accounts, prepare user for giving access before authorizing
            __weak __typeof(self)weakSelf = self;
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Grant access to Twitter accounts"
                                                                                     message:@"This app requires access to your stored Twitter accounts. Please grant access to your Twitter accounts to use the app. Don't worry, we won't tweet from your account or anything like that."
                                                                              preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [twitter performReverseAuthentication:^(STTwitterAPI *twitterAPI) {
                    weakSelf.searchBar.userInteractionEnabled = YES;
                } errorHandler:^(NSError *error) {
                    if ([error.domain isEqualToString:@"STTwitterOS"]) {
                        if (error.code == STTwitterOSSystemCannotAccessTwitter
                            || error.code == STTwitterOSNoTwitterAccountIsAvailable) {
                            // Sometimes "CannotAccessTwitter" error is thrown when user hasn't yet stored a twitter account in iOS
                            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Couldn't Access Twitter"
                                                                                                     message:@"We couln't reach Twitter. Please make sure you have a Twitter account stored on this device and try again." preferredStyle:UIAlertControllerStyleAlert];
                            [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
                            [weakSelf presentViewController:alertController animated:YES completion:nil];
                        } else if (error.code == STTwitterOSUserDeniedAccessToTheirAccounts) {
                            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Please Grant Access"
                                                                                                     message:@"TwitterDemo can't work without Twitter access. Please grant TwitterDemo access to your Twitter accounts." preferredStyle:UIAlertControllerStyleAlert];
                            [alertController addAction:[UIAlertAction actionWithTitle:@"Not Now" style:UIAlertActionStyleCancel handler:nil]];
                            [alertController addAction:[UIAlertAction actionWithTitle:@"Settings" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                            }]];
                            [weakSelf presentViewController:alertController animated:YES completion:nil];
                        } else {
                            UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"Error Logging In" message:@"We couldn't log in to Twitter." preferredStyle:UIAlertControllerStyleAlert];
                                                                   [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
                            [weakSelf presentViewController:alertController animated:YES completion:nil];
                        }
                    }
                }];
            }]];
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.searchResults.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZWVTweet *tweet = [self.searchResults objectAtIndex:indexPath.row];
    NSString *identifier;
    if ([tweet hasLocation]) {
        identifier = @"LocationTweetTableCell";
    } else {
        identifier = @"TweetTableCell";
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if ([cell isKindOfClass:[ZWVTweetTableViewCell class]]) {
        ZWVTweetTableViewCell *tweetCell = (ZWVTweetTableViewCell *)cell;
        [tweetCell setUpWithTweet:tweet];
        tweetCell.highlightPhrase = self.searchTerm;
        return tweetCell;
    }
    return nil;
}

#pragma mark - UISearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:NO animated:YES];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    __weak __typeof(self)weakSelf = self;
    self.searchTerm = searchBar.text;
    [[ZWVTwitterHandler shared].twitterAPI getSearchTweetsWithQuery:searchBar.text
                                        successBlock:^(NSDictionary *searchMetadata, NSArray *statuses) {
                                            NSMutableArray *tweets = [NSMutableArray new];
                                            for (NSDictionary *dict in statuses) {
                                                [tweets addObject:[[ZWVTweet alloc] initWithDict:dict]];
                                            }
                                            weakSelf.searchResults = [tweets copy];
                                            [weakSelf.tableView reloadData];
                                        }
                                          errorBlock:^(NSError *error) {
                                              NSLog(@"Error searching tweets: %@", error);
                                          }];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchBar.text = nil;
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
}

@end
