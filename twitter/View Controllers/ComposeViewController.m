//
//  ComposeViewController.m
//  twitter
//
//  Created by Carmen Gutierrez on 6/30/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import "ComposeViewController.h"
#import "APIManager.h"
@interface ComposeViewController ()
@property (weak, nonatomic) IBOutlet UITextView *tweetCompositionView;


@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)sendTweet:(id)sender {
    [[APIManager shared] postStatusWithText:self.tweetCompositionView.text completion:^(Tweet *tweet, NSError *error) {
        if(tweet){
            [self dismissViewControllerAnimated:true completion:nil];
            NSLog(@"😎😎😎 Successfully loaded home timeline");
            [self.delegate didTweet:tweet];
        } else {
            NSLog(@"😫😫😫 Error posting tweet: %@", error.localizedDescription);
        }
    }];
}
- (IBAction)closeComposition:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
    
}

@end
