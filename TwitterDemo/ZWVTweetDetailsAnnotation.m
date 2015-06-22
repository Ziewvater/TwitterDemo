//
//  ZWVTweetDisplayAnnotation.m
//  TwitterDemo
//
//  Created by Jeremy Lawrence on 6/20/15.
//  Copyright (c) 2015 Ziewvater. All rights reserved.
//

#import "ZWVTweetDetailsAnnotation.h"

@implementation ZWVTweetDetailsAnnotation

- (instancetype)initWithTweet:(ZWVTweet *)tweet {
    if (!(self = [super init])) return nil;
    if (!tweet) return nil;
    
    self.tweet = tweet;
    self.coordinate = tweet.location;
    
    return self;
}

@end

CGFloat MKPinAnnotationViewHeight = 39.0f;
CGFloat ZWVTweetDetailsMaxWidth = 300.f;
CGFloat ZWVTweetDetailsLabelEstimatedheight = 20.0f;
CGFloat ZWVTweetDetailsInterLabelSpacing = 4.0f;
CGFloat ZWVTweetDetailsBorderBuffer = 8.0f;

@implementation ZWVTweetDetailsAnnotationView

- (instancetype)initWithTweetAnnotation:(ZWVTweetDetailsAnnotation *)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    if (!(self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier])) return nil;
    
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 4.0f;
    self.layer.borderColor = [UIColor darkGrayColor].CGColor;
    self.layer.borderWidth = 1.0f;
    
    // Set up information display views
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(ZWVTweetDetailsBorderBuffer, ZWVTweetDetailsBorderBuffer, ZWVTweetDetailsMaxWidth, ZWVTweetDetailsLabelEstimatedheight)];
    UILabel *tweetLabel = [[UILabel alloc] initWithFrame:CGRectMake(ZWVTweetDetailsBorderBuffer, CGRectGetMaxY(nameLabel.frame) + ZWVTweetDetailsInterLabelSpacing, ZWVTweetDetailsMaxWidth, ZWVTweetDetailsLabelEstimatedheight)];
    tweetLabel.numberOfLines = 0;
    tweetLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    [self addSubview:nameLabel];
    [self addSubview:tweetLabel];
    
    self.nameLabel = nameLabel;
    self.tweetTextLabel = tweetLabel;
    
    [self setAppearanceForTweetAnnotation:annotation];
    return self;
}

- (void)setAppearanceForTweetAnnotation:(ZWVTweetDetailsAnnotation *)annotation {
    // Show display name in bold, screen name in normal weight
    NSDictionary *displayNameAttributes =   @{NSFontAttributeName : [UIFont boldSystemFontOfSize:[UIFont systemFontSize]]};
    NSDictionary *screenNameAttributes =    @{NSFontAttributeName : [UIFont systemFontOfSize:[UIFont systemFontSize]]};
    NSMutableAttributedString *nameString = [[NSMutableAttributedString alloc] initWithString:annotation.tweet.user.username
                                                                                   attributes:displayNameAttributes];
    [nameString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" @%@", annotation.tweet.user.screenName]
                                                                       attributes:screenNameAttributes]];
    self.nameLabel.attributedText = nameString;
    
    if (annotation.highlightPhrase) {
        // Find all the locations of the highlighted phrase
        NSMutableArray *locations = [NSMutableArray new];
        NSRange searchRange = NSMakeRange(0, [annotation.tweet.text length]);
        NSRange foundRange = [annotation.tweet.text rangeOfString:annotation.highlightPhrase options:NSCaseInsensitiveSearch range:searchRange];
        while (foundRange.location != NSNotFound) {
            [locations addObject:[NSValue valueWithRange:foundRange]];
            searchRange.location = foundRange.location + foundRange.length;
            searchRange.length = annotation.tweet.text.length - searchRange.location;
            foundRange = [annotation.tweet.text rangeOfString:annotation.highlightPhrase options:NSCaseInsensitiveSearch range:searchRange];
        }
        
        NSDictionary *highlightedAttributes = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:self.tweetTextLabel.font.pointSize]};
        NSDictionary *normalTextAttributes = @{NSFontAttributeName : [UIFont systemFontOfSize:self.tweetTextLabel.font.pointSize]};
        NSMutableAttributedString *tweetText = [[NSMutableAttributedString alloc] initWithString:annotation.tweet.text
                                                                                      attributes:normalTextAttributes];
        
        // Set bold font for all ranges of highlighted phrase
        for (NSValue *rangeValue in locations) {
            [tweetText setAttributes:highlightedAttributes range:[rangeValue rangeValue]];
        }
        self.tweetTextLabel.attributedText = tweetText;
    } else {
        self.tweetTextLabel.text = annotation.tweet.text;
    }
    
    CGSize sizeToFitTo = CGSizeMake(ZWVTweetDetailsMaxWidth, CGFLOAT_MAX);
    CGSize nameFittingRect = [self.nameLabel sizeThatFits:sizeToFitTo];
    CGSize textFittingRect = [self.tweetTextLabel sizeThatFits:sizeToFitTo];
    
    CGRect newNameFrame = CGRectMake(ZWVTweetDetailsBorderBuffer, ZWVTweetDetailsBorderBuffer, nameFittingRect.width, nameFittingRect.height);
    CGRect newTextFrame = CGRectMake(ZWVTweetDetailsBorderBuffer, CGRectGetMaxY(newNameFrame) + ZWVTweetDetailsInterLabelSpacing, textFittingRect.width, textFittingRect.height);
    
    self.nameLabel.frame = newNameFrame;
    self.tweetTextLabel.frame = newTextFrame;
    
    CGRect selfFittingFrame = CGRectUnion(newNameFrame, newTextFrame);
    selfFittingFrame.origin = CGPointZero;
    [self setFrame:CGRectInset(selfFittingFrame, -ZWVTweetDetailsBorderBuffer, -ZWVTweetDetailsBorderBuffer)];
    
    self.centerOffset = CGPointMake(0, -(CGRectGetMidY(self.bounds) + MKPinAnnotationViewHeight));
}

- (void)setAnnotation:(id<MKAnnotation>)annotation {
    [super setAnnotation:annotation];
    if ([annotation isKindOfClass:[ZWVTweetDetailsAnnotation class]]) {
        [self setAppearanceForTweetAnnotation:(ZWVTweetDetailsAnnotation *)annotation];
    }
}

@end