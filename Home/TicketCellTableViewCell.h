//
//  TicketCellTableViewCell.h
//  TourismApp
//
//  Created by 管理员 on 2017/11/19.
//  Copyright © 2017年 dragon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TicketModel.h"
@interface TicketCellTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *tnameLable;
@property (strong, nonatomic) IBOutlet UILabel *infoLable;
@property (strong, nonatomic) IBOutlet UILabel *priceLable;
- (void)cellSetModel:(TicketModel *)model;
@end
