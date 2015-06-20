//
//  ZWVTweetTableViewCell.h
//  TwitterDemo
//
//  Created by Jeremy Lawrence on 6/19/15.
//  Copyright (c) 2015 Ziewvater. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZWVTweet.h"

@interface ZWVTweetTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetTextLabel;

- (void)setUpWithTweet:(ZWVTweet *)tweet;

@end
