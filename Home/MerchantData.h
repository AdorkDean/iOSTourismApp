//
//  MerchantData.h
//  TourismApp
//
//  Created by 管理员 on 2017/11/19.
//  Copyright © 2017年 dragon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KeepSakeModel.h"
#import "TicketModel.h"
#import "CycleImgModel.h"
#import "MerchantModel.h"

@interface MerchantData : NSObject
@property(nonatomic, strong) NSMutableArray <KeepSakeModel*>    *businessKeepsake;
@property(nonatomic, strong) NSMutableArray <TicketModel*>      *ticket;
@property(nonatomic, strong) NSMutableArray <CycleImgModel*>    *businessImgs;
@property(nonatomic, strong) MerchantModel  *business;

@end
