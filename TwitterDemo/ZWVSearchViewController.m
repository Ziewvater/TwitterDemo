//
//  ZWVSearchViewController.m
//  TwitterDemo
//
//  Created by Jeremy Lawrence on 6/19/15.
//  Copyright (c) 2015 Ziewvater. All rights reserved.
//

#import "ZWVSearchViewController.h"
#import "AppDelegate.h"
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
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    __weak __typeof(self)weakSelf = self;
//    [appDelegate.twitterAPI getSearchTweetsWithQuery:searchBar.text
//                                        successBlock:^(NSDictionary *searchMetadata, NSArray *statuses) {
//                                            NSMutableArray *tweets = [NSMutableArray new];
//                                            for (NSDictionary *dict in statuses) {
//                                                [tweets addObject:[[ZWVTweet alloc] initWithDict:dict]];
//                                            }
//                                            weakSelf.searchResults = [tweets copy];
//                                            [weakSelf.tableView reloadData];
//                                        }
//                                          errorBlock:^(NSError *error) {
//                                              NSLog(@"Error searching tweets: %@", error);
//                                          }];
    [appDelegate.twitterAPI getSearchTweetsWithQuery:searchBar.text
                                             geocode:@"37.781157,-122.398720,1mi"
                                                lang:nil
                                              locale:nil
                                          resultType:nil
                                               count:nil
                                               until:nil
                                             sinceID:nil
                                               maxID:nil
                                     includeEntities:@NO
                                            callback:nil
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
