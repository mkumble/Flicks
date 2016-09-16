//
//  TrailerViewController.m
//  yahooDemo
//
//  Created by Mithun Kumble on 9/13/16.
//  Copyright © 2016 codepath. All rights reserved.
//

#import "TrailerViewController.h"
#import "FTProgressIndicator.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>

@interface TrailerViewController ()
@property (nonatomic) NSArray * trailers;

@end

@implementation TrailerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   [self fetchTrailers];
    
    
    // Do any additional setup after loading the view.
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


- (void) fetchTrailers {
    
        NSString *apiKey = @"a07e22bc18f5cb106bfe4cc1f83ad8ed";
        NSString *urlString =
        [NSString stringWithFormat:@"https://api.themoviedb.org/3/movie/%@/videos?api_key=%@",self.movie[@"id"], apiKey];
        
        NSURL *url = [NSURL URLWithString:urlString];
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
        
        NSURLSession *session = [NSURLSession sessionWithConfiguration: [NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue: [NSOperationQueue mainQueue]];
        
        [FTProgressIndicator showProgressWithmessage:@"Fetching trailers..."];
        
        NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if(!error) {
                NSError *jsonError = nil;
                NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data  options:kNilOptions error:&jsonError];
                NSLog(@"Response:%@",responseDictionary);
                self.trailers = responseDictionary[@"results"];
                
        
                
                         }
            else
            {
                NSLog(@"An error occured: %@",error.description);
                
            }
   
            [FTProgressIndicator dismiss];
        }];
        [task resume];

}

@end
