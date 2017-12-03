//
//  UserModel.h
//  TourismApp
//
//  Created by 管理员 on 2017/11/20.
//  Copyright © 2017年 dragon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject
@property (nonatomic,strong)NSString *uid;
@property (nonatomic,strong)NSString *phone;
@property (nonatomic,strong)NSString *account;
@property (nonatomic,strong)NSString *signinTime;
@property (nonatomic,strong)NSString *pass;
@property (nonatomic,strong)NSString *headImgPath;
@property (nonatomic,strong)NSString *sex;
@end
