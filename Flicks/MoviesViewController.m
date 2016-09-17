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
#import "TrailerViewController.h"
#import "MovieCollectionViewCell.h"
#import <SystemConfiguration/CaptiveNetwork.h>
#import "Reachability.h"

@interface MoviesViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UICollectionViewDelegate, UICollectionViewDataSource>


@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray* movies;
@property (nonatomic, strong) NSArray* filteredMovies;


@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic, strong) Reachability * reachability;
@property (weak, nonatomic) IBOutlet UILabel *networkConnectionMessageLabel;


@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControlOutlet;
@end

@implementation MoviesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ((UIView *)self.segmentedControlOutlet.subviews[0]).tintColor = [UIColor grayColor];
    
    ((UIView *)self.segmentedControlOutlet.subviews[1]).tintColor = [UIColor blackColor];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    [self setUpRechability];
    
    [self.collectionView setHidden:YES];
    
    self.searchBar.delegate = self;
    self.searchBar.placeholder = @"Search Movies";

                                                         [self.segmentedControlOutlet setImage:[UIImage imageNamed:@"list-1"] forSegmentAtIndex:0];
    
         [self.segmentedControlOutlet setImage:[UIImage imageNamed:@"grid"] forSegmentAtIndex:1];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    self.refreshControl = [[UIRefreshControl  alloc]init];
    [self.refreshControl  addTarget: self action:@selector(fetchData) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex: 0];
    
    [self fetchData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

    - (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.filteredMovies.count;
    }

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MovieCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell"];
    
        NSDictionary *movie = self.filteredMovies[indexPath.row];
    if(movie[@"poster_path"])
    {
    NSString * baseURL = @"https://image.tmdb.org/t/p/w500/";
    NSString *imageURL = [NSString stringWithFormat:@"%@%@",baseURL, movie[@"poster_path"]];
    [cell.posterView setImageWithURL:[NSURL URLWithString:imageURL]];

    }
    cell.titleLabel.text = movie[@"title"];
    cell.synopsysLabel.text = movie[@"overview"];

   
    return cell;
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
        [self.view endEditing:YES];
    
    
    if([segue.identifier isEqualToString:@"movieDetailSegueViaTableView"])
    {    UITableView *cell = sender;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    MovieDetailViewController *vc = segue.destinationViewController;
    vc.movie = self.filteredMovies[indexPath.row];
           NSLog(@"%@",vc.movie);
    }
    
    else if([segue.identifier isEqualToString:@"movieDetailSegueViaCollectionView"])
        {    UICollectionView *cell = sender;
            NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
            MovieDetailViewController *vc = segue.destinationViewController;
            vc.movie = self.filteredMovies[indexPath.row];
        }
    else if([segue.identifier isEqualToString:@"trailerSegue"]){
        UITableView *cell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        TrailerViewController * tc = segue.destinationViewController;
        tc.movie = self.filteredMovies[indexPath.row];
        NSLog(@"TRAILLLLLLLLLL%@",tc.movie);
    }

}

-(void) fetchData {
    NSString *apiKey = @"a07e22bc18f5cb106bfe4cc1f83ad8ed";
    NSString *urlString =
    [NSString stringWithFormat:@"https://api.themoviedb.org/3/movie/%@?api_key=%@",self.endpoint, apiKey];
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration: [NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue: [NSOperationQueue mainQueue]];
    
    [FTProgressIndicator showProgressWithmessage:@"Fetching movies..."];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(!error) {
            NSError *jsonError = nil;
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data  options:kNilOptions error:&jsonError];
            NSLog(@"Response:%@",responseDictionary);
            self.movies = responseDictionary[@"results"];
                self.filteredMovies = self.movies;
            [self.tableView reloadData];
            [self.collectionView reloadData];
            
        }
        else
        {
            NSLog(@"An error occured: %@",error.description);
            
        }
           [self.refreshControl endRefreshing];
        [FTProgressIndicator dismiss];
    }];
    [task resume];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if([searchText length] == 0)
    {
        self.filteredMovies = self.movies;
    }
    else
    {
        NSLog(@"%@", searchText);
        self.filteredMovies = [self.movies filteredArrayUsingPredicate:
                               
                               
                               [NSPredicate predicateWithFormat:@"%K CONTAINS %@", @"title",searchText]];
    }
    [self.tableView reloadData];
    [self.collectionView reloadData];
    
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:YES animated:YES];
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar endEditing:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar {
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar endEditing:YES];
}


- (IBAction)onSegmentedControlChange:(id)sender {
    if(self.segmentedControlOutlet.selectedSegmentIndex == 0)
    {
        [self.tableView setHidden:NO];
        [self.collectionView setHidden:YES];
        
        ((UIView *)self.segmentedControlOutlet.subviews[0]).tintColor = [UIColor grayColor];
        
            ((UIView *)self.segmentedControlOutlet.subviews[1]).tintColor = [UIColor blackColor];
    }
    else if(self.segmentedControlOutlet.selectedSegmentIndex == 1)
    {[self.tableView setHidden:YES];
            [self.collectionView setHidden:NO];
        
        ((UIView *)self.segmentedControlOutlet.subviews[0]).tintColor = [UIColor blackColor];
        
        ((UIView *)self.segmentedControlOutlet.subviews[1]).tintColor = [UIColor grayColor];

    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.filteredMovies.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

   
    
    MovieCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionMovieCell" forIndexPath:indexPath];
    

    NSDictionary *movie = self.filteredMovies[indexPath.row];
    
    if(movie[@"poster_path"])
    {
        NSString * baseURL = @"https://image.tmdb.org/t/p/w500/";
        NSString *imageURL = [NSString stringWithFormat:@"%@%@",baseURL, movie[@"poster_path"]];

        
        [cell.movieImageView setImageWithURL:[NSURL URLWithString:imageURL]];
        
    }
    
    return cell;
}







-(void)setUpRechability
{

    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNetworkChange:) name:kReachabilityChangedNotification object:nil];
    
self.reachability = [Reachability reachabilityForInternetConnection];
    [self.reachability startNotifier];
    
    NetworkStatus remoteHostStatus = [self.reachability currentReachabilityStatus];
    
    if          (remoteHostStatus == NotReachable)      {        [self.networkConnectionMessageLabel setHidden:NO];   }
    else  {           [self.networkConnectionMessageLabel setHidden:YES]; }
}
  



- (void) handleNetworkChange:(NSNotification *)notice
{
    NetworkStatus remoteHostStatus = [self.reachability currentReachabilityStatus];
    
    
    if          (remoteHostStatus == NotReachable)      {        [self.networkConnectionMessageLabel setHidden:NO];   }
    else  {           [self.networkConnectionMessageLabel setHidden:YES]; }}

@end
