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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetTableCell"];
    if ([cell isKindOfClass:[ZWVTweetTableViewCell class]]) {
        ZWVTweetTableViewCell *tweetCell = (ZWVTweetTableViewCell *)cell;
        [tweetCell setUpWithTweet:[self.searchResults objectAtIndex:indexPath.row]];
        return tweetCell;
    }
    return nil;
}


#pragma mark UITableViewDelegate

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    ZWVTweetTableViewCell *calculationCell = self.calculationCell;
//    if (calculationCell) {
//        calculationCell = [tableView dequeueReusableCellWithIdentifier:@"TweetTableCell"];
//        self.calculationCell = calculationCell;
//    }
//    [calculationCell setUpWithTweet:[self.searchResults objectAtIndex:indexPath.row]];
//    
//    calculationCell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight(calculationCell.bounds));
//    [calculationCell setNeedsLayout];
//    [calculationCell layoutIfNeeded];
//    
//    CGFloat height = [calculationCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
//    return height+1; // Add one point for the row separator
//}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    __weak __typeof(self)weakSelf = self;
    [appDelegate.twitterAPI getSearchTweetsWithQuery:searchBar.text
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
