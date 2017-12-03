//
//  TicketCellTableViewCell.m
//  TourismApp
//
//  Created by 管理员 on 2017/11/19.
//  Copyright © 2017年 dragon. All rights reserved.
//

#import "TicketCellTableViewCell.h"


@implementation TicketCellTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)cellSetModel:(TicketModel *)model{
    _priceLable.text = model.price;
    _tnameLable.text = model.tname;
    _infoLable.text = model.info;    
}
@end
