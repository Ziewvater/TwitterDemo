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

@interface ZWVSearchViewController()

@property (strong, nonatomic) NSArray *searchResults; // [ZWVTweet]

@property (strong, nonatomic) ZWVTweetTableViewCell *calculationCell;

@end

@implementation ZWVSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.estimatedRowHeight = 67.0f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    ZWVTwitterHandler *twitter = [ZWVTwitterHandler shared];
    if (!twitter.twitterAPI) {
        self.searchBar.userInteractionEnabled = NO;
        __weak __typeof(self)weakSelf = self;
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Grant access to Twitter accounts"
                                                                                 message:@"This app requires access to your stored Twitter accounts. Please grant access to your Twitter accounts to use the app. Don't worry, we won't tweet from your account or anything like that."
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [twitter performReverseAuthentication:^(STTwitterAPI *twitterAPI) {
                weakSelf.searchBar.userInteractionEnabled = YES;
            } errorHandler:^(NSError *error) {
                //
            }];
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

#pragma mark - UITableView

#pragma mark UITableViewDataSource

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
        return tweetCell;
    }
    return nil;
}


#pragma mark UITableViewDelegate


#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    __weak __typeof(self)weakSelf = self;
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

@end
