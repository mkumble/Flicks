//
//  MovieDetailViewController.m
//  yahooDemo
//
//  Created by Mithun Kumble on 9/12/16.
//  Copyright © 2016 codepath. All rights reserved.
//

#import "MovieDetailViewController.h"
#import "UIImageView+AFNetworking.h"
#import "TrailerViewController.h"

@interface MovieDetailViewController ()


@property (weak, nonatomic) IBOutlet UIImageView *posterImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *overviewLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIView *infoView;

@end

@implementation MovieDetailViewController

- (void)viewDidLoad {
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, self.infoView.frame.origin.y + self.infoView.frame.size.height);
    
    
    
    

    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(self.movie[@"title"]);
    self.titleLabel.text = self.movie[@"title"];
    self.overviewLabel.text = self.movie[@"overview"];
    [self.overviewLabel sizeToFit];
    
        
    
    if(self.movie[@"poster_path"])
    {
        NSString * baseURL = @"https://image.tmdb.org/t/p/w500/";
        NSString *imageURL = [NSString stringWithFormat:@"%@%@",baseURL, self.movie[@"poster_path"]];
        [self.posterImageView setImageWithURL:[NSURL URLWithString:imageURL]];
        
    }

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)onClickTrailerButton:(id)sender {
    NSLog(@"%@",self.movie);
    TrailerViewController* tc = [self.storyboard instantiateViewControllerWithIdentifier:@"TrailerViewController"];
    [tc setMovie:self.movie];
    [self.navigationController pushViewController:tc animated:YES];
}


@end
