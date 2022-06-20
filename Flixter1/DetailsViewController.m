//
//  DetailsViewController.m
//  Flixter1
//
//  Created by Abdullahi Ahmed on 17/06/2022.
//

#import "DetailsViewController.h"
#import "UIImageView+AFNetworking.h"
@interface DetailsViewController ()

@property (weak, nonatomic) IBOutlet UILabel *detailsTitleLable;
@property (weak, nonatomic) IBOutlet UIImageView *smallerPosterView;

@property (weak, nonatomic) IBOutlet UIImageView *bigerPosterView;
@property (weak, nonatomic) IBOutlet UILabel *detalisSysnopsisLabel;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.detailsTitleLable.text = self.movieInfo[@"title"];
    self.detalisSysnopsisLabel.text = self.movieInfo[@"overview"];
    
    NSString *baseURLString = @"https://image.tmdb.org/t/p/w500/";
    NSString *posterURLString = self.movieInfo[@"poster_path"];
    NSString *fullPosterURLString = [baseURLString
                                     stringByAppendingString:posterURLString];
    
    NSURL * posterURL = [NSURL URLWithString:fullPosterURLString];
    [self.smallerPosterView setImageWithURL:posterURL];
    [self.bigerPosterView setImageWithURL:posterURL];

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

@end
