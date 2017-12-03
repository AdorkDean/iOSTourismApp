//
//  HomeViewController.m
//  TourismApp
//
//  Created by 管理员 on 2017/11/15.
//  Copyright © 2017年 dragon. All rights reserved.
//
#import "SDCycleScrollView.h"
#import "YYModel.h"


#import "HomeViewController.h"
#import "MerchantViewController.h"
#import "HomeMerchantCell.h"
#import "GCAPIClient.h"
#import "MerchantModel.h"
#import "CycleImgModel.h"


@interface HomeViewController ()<UITableViewDataSource, UITableViewDelegate>

@property(strong, nonatomic) SDCycleScrollView *loopView;
@property(strong, nonatomic)  NSMutableArray <MerchantModel *>  *MerchantModeList;
@property(strong, nonatomic)  NSMutableArray <CycleImgModel *> *CycleImgModelList;
@property(strong, nonatomic)  NSMutableArray <NSString *> *CycleImgUrlList;

@property(strong, nonatomic) UITableView *tableView;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
//    HomeViewController *__weak weakSelf = self;
    GCAPIClient *manager = [GCAPIClient manager];
    
    _loopView = [[SDCycleScrollView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width * 9.f / 16.f)];
    _loopView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    _loopView.currentPageDotColor = [UIColor grayColor];
    _loopView.pageDotColor = [UIColor whiteColor];
    
    
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [UIView new];
    _tableView.tableHeaderView = _loopView;
    _tableView.estimatedRowHeight = 80;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _tableView.showsVerticalScrollIndicator = NO;
    
    UINib *Nib = [UINib nibWithNibName:@"HomeMerchantCell" bundle:nil];
    [_tableView registerNib:Nib forCellReuseIdentifier:@"MYCELL"];
    [self.view addSubview:_tableView];
    
    _MerchantModeList = [[NSMutableArray alloc] init];
    _CycleImgModelList= [[NSMutableArray alloc] init];
    _CycleImgUrlList= [[NSMutableArray alloc] init];

    
    [manager requestGetPath:@"business/findAll.action" success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *data =  responseObject[@"data"];
        NSMutableArray *list =  data[@"list"];
        for (NSDictionary *Merchant in list) {
            MerchantModel *model = [MerchantModel yy_modelWithDictionary:Merchant];
            [_MerchantModeList addObject:model];
        }
        [_tableView reloadData];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"HBLog:%@",error);
        
    }];
    
    
    [manager requestGetPath:@"businessCarousel/findAll.action" success:^(NSURLSessionDataTask *task, id responseObject) {
        NSMutableArray *data =  responseObject[@"data"];
        for (NSDictionary * CycleImg in data) {
            CycleImgModel * cycleModel = [CycleImgModel yy_modelWithDictionary:CycleImg];
            NSString *url = [[NSString alloc] initWithFormat:@"http://172.16.120.129:8080/%@",cycleModel.imgpath];
            [_CycleImgUrlList addObject:url];
            [_CycleImgModelList addObject:cycleModel];
        }
        _loopView.imageURLStringsGroup = _CycleImgUrlList;
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"HBLog:%@",error);
    }];
    
    
}


#pragma mark tableView数据
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _MerchantModeList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeMerchantCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MYCELL" forIndexPath:indexPath];
    if (_MerchantModeList.count > 0) {
        MerchantModel *merchantMode = _MerchantModeList[indexPath.row];
        [cell cellSetModel:merchantMode];
    }
    return cell;
}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MerchantViewController *vc = [[MerchantViewController alloc] init];
    vc.model = _MerchantModeList[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}


@end
