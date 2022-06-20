//
//  MovieViewController.m
//  Flixter1
//
//  Created by Abdullahi Ahmed on 17/06/2022.
//

#import "MovieViewController.h"
# import "MovieViewCell.h"
#import "UIImageView+AFNetworking.h"
# import "DetailsViewController.h"
#import "GridViewController.h"
@interface MovieViewController() < UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSArray *myArray;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property(nonatomic, strong) IBOutlet UITableView *tableView;
@end


@implementation MovieViewController



- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.activityIndicator startAnimating];
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(beginRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:refreshControl atIndex:0];
    [self getDataFromApi];
}




- (void) getDataFromApi {
    // 1. Create URL
    NSURL *url = [NSURL URLWithString:@"https://api.themoviedb.org/3/movie/now_playing?api_key=6bdae4f353ec86716263b2dfb710730d"];
    
    // 2. Create Request
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    // 3. Create Session
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    
    // 4. Create our session task
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if(error != nil){
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Can not get Movies"
                                       message:@"The internet connection appears to be offline."
                                       preferredStyle:UIAlertControllerStyleAlert];

            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                           handler:^(UIAlertAction * action) {
                [self getDataFromApi];
            }];

            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
        } else {
            NSDictionary *dataDictionary = [
                NSJSONSerialization JSONObjectWithData:data
                options:NSJSONReadingMutableContainers error:nil
            ];

            NSLog(@"%@", dataDictionary);
            self.myArray = dataDictionary[@"results"];
            
            [self.tableView reloadData];
        }

        [self.activityIndicator stopAnimating];

    }];
    
    // 5.
    [task resume];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.myArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    MovieViewCell *cell =[tableView
                             dequeueReusableCellWithIdentifier:@"MovieCell"];


    NSDictionary *movie = self.myArray[indexPath.row];
    
    cell.titleLabel.text = movie[@"title"];
    
    cell.synopsisLabel.text = movie[@"overview"];
//    cell.textLabel.text = movie[@"title"];
    
    NSString *baseURLString = @"https://image.tmdb.org/t/p/w500/";
    NSString *posterURLString = movie[@"poster_path"];
    NSString *fullPosterURLString = [baseURLString
                                     stringByAppendingString:posterURLString];
    
    NSURL * posterURL = [NSURL URLWithString:fullPosterURLString];
    cell.posterView.image = nil;
    [cell.posterView setImageWithURL:posterURL];
    return cell;
    
    
}


- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    MovieViewCell *cell = sender;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSDictionary *dataToPass = self.myArray[indexPath.row];
    DetailsViewController *detailsVC = [segue destinationViewController];
    detailsVC.movieInfo = dataToPass;
}


- (void)beginRefresh:(UIRefreshControl *)refreshControl {
    [self getDataFromApi];
    [self.tableView reloadData];
   // Tell the refreshControl to stop spinning
    [refreshControl endRefreshing];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end
