//
//  ViewController.m
//  yahooDemo
//
//  Created by Mithun Kumble on 9/12/16.
//  Copyright © 2016 codepath. All rights reserved.
//

#import "MoviesViewController.h"
#import "MovieCell.h"
#import "MovieDetailViewController.h"
#import "FTProgressIndicator.h"
#import "UIImageView+AFNetworking.h"

@interface MoviesViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray* movies;
@property (weak, nonatomic) IBOutlet UITableView *tableView;



@end

@implementation MoviesViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    NSString *apiKey = @"a07e22bc18f5cb106bfe4cc1f83ad8ed";
    NSString *urlString =
    [NSString stringWithFormat:@"https://api.themoviedb.org/3/movie/%@?api_key=%@",self.endpoint, apiKey];
    
 
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration: [NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue: [NSOperationQueue mainQueue]];
    
    [FTProgressIndicator showProgressWithmessage:@"Here is a progress message."];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(!error) {
            NSError *jsonError = nil;
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data  options:kNilOptions error:&jsonError];
            NSLog(@"Response:%@",responseDictionary);
            self.movies = responseDictionary[@"results"];
            [self.tableView reloadData];
            
        }
        else
        {
            NSLog(@"An error occured: %@",error.description);
            
        }
        [FTProgressIndicator dismiss];
        
        
    }];
    [task resume];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



    - (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.movies.count;
    }

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MovieCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell"];
    
    NSLog(@"indexpath: row: %ld",(long)indexPath.row);
        NSDictionary *movie = self.movies[indexPath.row];
    if(movie[@"poster_path"])
    {
    NSString * baseURL = @"https://image.tmdb.org/t/p/w92/";
    NSString *imageURL = [NSString stringWithFormat:@"%@%@",baseURL, movie[@"poster_path"]];
    [cell.posterView setImageWithURL:[NSURL URLWithString:imageURL]];

    }
    cell.titleLabel.text = movie[@"title"];
    cell.synopsysLabel.text = movie[@"overview"];

   
    return cell;
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if([segue.identifier isEqualToString:@"detailSegue"])
    {    UITableView *cell = sender;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    MovieDetailViewController *vc = segue.destinationViewController;
    vc.movie = self.movies[indexPath.row];
    NSLog(@"hello");
    }
    else{
        
    }
}

@end
