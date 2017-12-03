//
//  HomeMerchantCell.h
//  TourismApp
//
//  Created by 管理员 on 2017/11/16.
//  Copyright © 2017年 dragon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MerchantModel.h"
@interface HomeMerchantCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *bnameLable;
@property (strong, nonatomic) IBOutlet UIImageView *bImageView;
@property (strong, nonatomic) IBOutlet UILabel *baddressLable;
@property (strong, nonatomic) IBOutlet UILabel *blevelLable;


- (void)cellSetModel:(MerchantModel *)model;
@end
