//
//  DetailsViewController.m
//  twitter
//
//  Created by Carmen Gutierrez on 7/1/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import "DetailsViewController.h"
#import "UIImageView+AFNetworking.h"
#import "Tweet.h"
#import "APIManager.h"
#import "ComposeViewController.h"

@interface DetailsViewController () <ComposeViewControllerDelegate>
@property (strong, nonatomic) IBOutlet UIView *totalView;
@property (weak, nonatomic) IBOutlet UIImageView *profilePicView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userScreenNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *createdDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (weak, nonatomic) IBOutlet UILabel *favoriteCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *retweetCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (weak, nonatomic) IBOutlet UIButton *replyButton;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.userNameLabel.text = self.tweet.user.name;
    self.userScreenNameLabel.text = [NSString stringWithFormat:@"@%@",self.tweet.user.screenName];
    self.createdDateLabel.text = self.tweet.createdAtString;
    self.textLabel.text = self.tweet.text;
    self.favoriteCountLabel.text = [NSString stringWithFormat:@"%d", self.tweet.favoriteCount];
    self.retweetCountLabel.text = [NSString stringWithFormat:@"%d", self.tweet.retweetCount];
    if (self.tweet.favorited) {
        [self.favoriteButton setSelected:YES];
    }
    if(self.tweet.retweeted) {
        [self.retweetButton setSelected:YES];
    }
    NSURL *profilePicURL = [NSURL URLWithString:self.tweet.user.profilePic];
    self.profilePicView.image= nil;
    [self.profilePicView setImageWithURL: profilePicURL];
    self.profilePicView.layer.cornerRadius = self.profilePicView.frame.size.width/2;
    self.profilePicView.clipsToBounds = YES;
}
- (IBAction)didTapRetweet:(id)sender {
    if (!self.tweet.retweeted) {
        
        [[APIManager shared] retweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                 NSLog(@"Error retweeting tweet: %@", error.localizedDescription);
            }
            else{
                NSLog(@"Successfully retweeted the following Tweet: %@", tweet.text);
                self.tweet.retweeted = YES;
                self.tweet.retweetCount += 1;
                [self.retweetButton setSelected:YES];
            }
        }];
        [self.totalView reloadInputViews];
    }
}
- (IBAction)didTapLike:(id)sender {
     if (!self.tweet.favorited) {
         [[APIManager shared] favorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
             if(error){
                  NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
             }
             else{
                 NSLog(@"Successfully favorited the following Tweet: %@", tweet.text);
                 self.tweet.favorited = YES;
                 self.tweet.favoriteCount += 1;
                 [self.favoriteButton setSelected:YES];
             }
         }];
         [self.totalView reloadInputViews];
     }
}
- (void)didTweet:(Tweet *)tweet {
    [self.replyButton setSelected:YES];
    [self reloadInputViews];
}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    UINavigationController *navigationController = [segue destinationViewController];
    ComposeViewController *composeController = (ComposeViewController*)navigationController.topViewController;
    composeController.delegate = self;
    composeController.replyTweet = self.tweet;
    
}


@end
