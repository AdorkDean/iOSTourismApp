//
//  HomeMerchantCell.m
//  TourismApp
//
//  Created by 管理员 on 2017/11/16.
//  Copyright © 2017年 dragon. All rights reserved.
//

#import "HomeMerchantCell.h"
#import "UIImageView+WebCache.h"
@implementation HomeMerchantCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)cellSetModel:(MerchantModel *)model{
    _bnameLable.text =  model.bname;
    _blevelLable.text = model.level;
    _baddressLable.text =model.address;
    
    NSString *str = BaseUrl;
    NSString *urlStr = [str stringByAppendingFormat:@"%@", model.image];
    [_bImageView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"xx"] options:SDWebImageRefreshCached];
}
@end
