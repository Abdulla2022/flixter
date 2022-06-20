//
//  GridViewController.m
//  Flixter1
//
//  Created by Abdullahi Ahmed on 17/06/2022.
//

#import "UIImageView+AFNetworking.h"
# import "DetailsViewController.h"
#import "GridViewController.h"
#import "everyMovieViewCell.h"

@interface GridViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *myArray;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;
@end

@implementation GridViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.dataSource = self;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self getDataFromApi];
    
}

- (void)viewDidLayoutSubviews {
   [super viewDidLayoutSubviews];

    self.flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.flowLayout.minimumLineSpacing = 0;
    self.flowLayout.minimumInteritemSpacing = 0;
    self.flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 10);
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
        if(error != nil) {
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Can not get Movies"
                                       message:@"The internet connection appears to be offline."
                                       preferredStyle:UIAlertControllerStyleAlert];

            
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Try Again" style:UIAlertActionStyleDefault
                                           handler:^(UIAlertAction * action) {
                [self getDataFromApi];
            }];

            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
        } else  {
            NSDictionary *dataDictionary = [
                NSJSONSerialization JSONObjectWithData:data
                options:NSJSONReadingMutableContainers error:nil
            ];

            NSLog(@"%@", dataDictionary);
            self.myArray = dataDictionary[@"results"];
            
            [self.collectionView reloadData];
        }



    }];
    
    // 5.
    [task resume];
}


- (everyMovieViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    everyMovieViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"everyMovieViewCell" forIndexPath:indexPath];
    
    NSDictionary *movie = self.myArray[indexPath.row];
    NSString *urlString = [NSString stringWithFormat:@"%@%@", @"https://image.tmdb.org/t/p/w500", self.myArray[indexPath.item][@"poster_path"]];
    NSURL *url = [NSURL URLWithString:urlString];
    cell.postersViews.image = nil;
    [cell.postersViews setImageWithURL:url];
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.myArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    int totalwidth = self.collectionView.bounds.size.width;
    int numberOfCellsPerRow = 3;
    int width = (CGFloat)(totalwidth / numberOfCellsPerRow);
    return CGSizeMake(width, 200);
    }

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    everyMovieViewCell *cell = sender;
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    NSDictionary *dataToPass = self.myArray[indexPath.row];
    DetailsViewController *detailsVC = [segue destinationViewController];
    detailsVC.movieInfo = dataToPass;
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
