//
//  ZWVTweetTableViewCell.h
//  TwitterDemo
//
//  Created by Jeremy Lawrence on 6/19/15.
//  Copyright (c) 2015 Ziewvater. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZWVTweet.h"

/**
 A table view cell that displays a tweet. 
 
 Can be easily set up with a ZWVTweet object with the setup method 
 `-setUpWithTweet:`.
 */
@interface ZWVTweetTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetTextLabel;
@property (strong, nonatomic) NSString *highlightPhrase;

- (void)setUpWithTweet:(ZWVTweet *)tweet;

@end
