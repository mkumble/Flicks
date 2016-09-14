//
//  MovieCell.h
//  yahooDemo
//
//  Created by Mithun Kumble on 9/12/16.
//  Copyright © 2016 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *synopsysLabel;
@property (weak, nonatomic) IBOutlet UIImageView *posterView;

@end
