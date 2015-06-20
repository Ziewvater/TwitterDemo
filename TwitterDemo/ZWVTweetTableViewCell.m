//
//  ZWVTweetTableViewCell.m
//  TwitterDemo
//
//  Created by Jeremy Lawrence on 6/19/15.
//  Copyright (c) 2015 Ziewvater. All rights reserved.
//

#import "ZWVTweetTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation ZWVTweetTableViewCell

- (void)setUpWithTweet:(ZWVTweet *)tweet {
    if (tweet.user) {
        self.usernameLabel.text = tweet.user.username;
    }
    if (tweet.text) {
        self.tweetTextLabel.text = tweet.text;
    }
    if (tweet.user.profileImageUrl) {
        self.avatarImageView.alpha = 0;
        __weak __typeof(self)weakSelf = self;
        [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:tweet.user.profileImageUrl]
                                       completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                           if (cacheType == SDImageCacheTypeMemory) {
                                               weakSelf.avatarImageView.alpha = 1;
                                           } else {
                                               [UIView animateWithDuration:0.2
                                                                animations:^{
                                                                    weakSelf.avatarImageView.alpha = 1;
                                                                }];
                                           }
                                       }];
    }
}

@end
