//
//  MovieViewCell.h
//  Flixter1
//
//  Created by Abdullahi Ahmed on 17/06/2022.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MovieViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *synopsisLabel;
@property (weak, nonatomic) IBOutlet UIImageView *posterView;

@end

NS_ASSUME_NONNULL_END
