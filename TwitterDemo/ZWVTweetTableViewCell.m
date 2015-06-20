//
//  ZWVTweetTableViewCell.m
//  TwitterDemo
//
//  Created by Jeremy Lawrence on 6/19/15.
//  Copyright (c) 2015 Ziewvater. All rights reserved.
//

#import "ZWVTweetTableViewCell.h"

@implementation ZWVTweetTableViewCell

- (void)setUpWithTweet:(ZWVTweet *)tweet {
    if (tweet.user) {
        self.usernameLabel.text = tweet.user.username;
    }
    if (tweet.text) {
        self.tweetTextLabel.text = tweet.text;
    }
}

@end
