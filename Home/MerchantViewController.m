//
//  MerchantViewController.m
//  TourismApp
//
//  Created by 管理员 on 2017/11/19.
//  Copyright © 2017年 dragon. All rights reserved.
//

#import "SDCycleScrollView.h"
#import "YYModel.h"


#import "TicketModel.h"
#import "MCycleImgModel.h"
#import "MerchantViewController.h"
#import "GCAPIClient.h"
#import "CycleImgModel.h"
#import "KeepSakeModel.h"
#import "MerchantData.h"
#import "TicketCellTableViewCell.h"

#define _LEN [UIScreen mainScreen].bounds.size.width * 9.f / 16.f

@interface MerchantViewController ()<UIScrollViewDelegate ,UITableViewDelegate,UITableViewDataSource>
@property(strong, nonatomic) SDCycleScrollView *loopView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) WZBSegmentedControl *sectionView;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) NSMutableArray <UITableView *>* tableViewList;

@property (nonatomic, strong) NSMutableArray <TicketModel *>* ticketList;
@property (nonatomic, strong) NSMutableArray <MCycleImgModel *>* CycleImgList;
@property (nonatomic, strong) NSMutableArray <KeepSakeModel *>* KeepSakeList;
@property(strong, nonatomic)  NSMutableArray <NSString *> *CycleImgUrlList;

@end

@implementation MerchantViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    
   
    
    GCAPIClient *manager = [GCAPIClient shareClient];
    [manager requestGetPath:@"/business/findById.action" parameters:@{@"bid":@"2511150102"} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        
        if ([responseObject[@"status"] integerValue] == 200) {
//            NSDictionary *data = responseObject[@"data"];
//            MerchantData *datas = [MerchantData yy_modelWithDictionary:data];
//            _ticketList =  datas.ticket;
//            _CycleImgList = datas.businessImgs;
//            _KeepSakeList = datas.businessKeepsake;
            
            
            NSDictionary *data =  responseObject[@"data"];
//            NSDictionary *business = data[@"business"];
            NSDictionary * businessKeepsake  = data[@"businessKeepsake"];
            NSArray  * ticket = data[@"ticket"];
            NSArray * businessImgs = data[@"businessImgs"];
            //businessInfo 没有获取

            _CycleImgList=  [[NSMutableArray alloc] init];
            _ticketList = [[NSMutableArray alloc] init];
            _KeepSakeList = [[NSMutableArray alloc] init];
            _CycleImgUrlList = [[NSMutableArray alloc] init];

            for (NSDictionary *imgDic in businessImgs) {
                MCycleImgModel *imgModel  = [MCycleImgModel yy_modelWithDictionary:imgDic];
                NSString *url = [[NSString alloc] initWithFormat:@"http://172.16.120.129:8080/%@",imgModel.imgPath];
                [_CycleImgUrlList addObject:url];
                [_CycleImgList addObject:imgModel];
            }

            for (NSDictionary *tkDic in ticket) {
                TicketModel *tkModel  = [TicketModel yy_modelWithDictionary:tkDic];
                [_ticketList addObject:tkModel];
            }
            for (NSDictionary *ksDic in businessKeepsake) {
                KeepSakeModel *kpModel = [KeepSakeModel yy_modelWithDictionary:ksDic];
                [_KeepSakeList addObject:kpModel];
            }

            _loopView.imageURLStringsGroup = _CycleImgUrlList;
            [_tableViewList[0] reloadData];
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error) {
        

    }];
    
    
    
    
    
    
}

-(void)setupView{
    self.edgesForExtendedLayout = UIRectEdgeNone;
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:scrollView];
    scrollView.delegate = self;
    scrollView.contentSize = CGSizeMake(3 * kScreenWidth, 0);
    scrollView.pagingEnabled = YES;
    self.scrollView = scrollView;

    
    _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, _LEN + 44)];
    _loopView = [[SDCycleScrollView alloc] initWithFrame:CGRectMake(0, 0,kScreenWidth,_LEN)];
    _loopView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    _loopView.currentPageDotColor = [UIColor grayColor];
    _loopView.pageDotColor = [UIColor whiteColor];
    _sectionView = [WZBSegmentedControl segmentWithFrame:(CGRect){0, _LEN, kScreenWidth, 44} titles:@[@"门票", @"详情须知", @"纪念品"] tClick:^(NSInteger index) {
        self.scrollView.contentOffset = CGPointMake(index * kScreenWidth, 0);
        [self reloadMaxOffsetY];
    }];
    
    [_sectionView setNormalColor:[UIColor blackColor] selectColor:[UIColor redColor] sliderColor:[UIColor redColor] edgingColor:[UIColor clearColor] edgingWidth:0];
    [_sectionView setBackgroundColor:[UIColor whiteColor]];
    _sectionView.layer.cornerRadius = _sectionView.backgroundView.layer.cornerRadius = .0f;
    
    for (NSInteger i = 0; i < 2; i++) {
        UIView *line = [UIView new];
        line.backgroundColor = kRGBA(228, 227, 230,1);
        line.frame = CGRectMake(0, 43.5 * i, kScreenWidth, 0.5);
        [_sectionView addSubview:line];
    }
    
    CGRect frame = _sectionView.backgroundView.frame;
    frame.origin.y = frame.size.height - 1.5;
    frame.size.height = 1;
    _sectionView.backgroundView.frame = frame;
    
    [_topView addSubview:_loopView];
    [_topView addSubview:_sectionView];
    
    [self.view addSubview:_topView];
    _tableViewList = [[NSMutableArray alloc] init];
    [self setupTableViewWithIndex :0];
    [self setupTableViewWithIndex :1];
    [self setupTableViewWithIndex :2];
    
}

- (void)setupTableViewWithIndex:(NSUInteger)x{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(x * kScreenWidth, 0, kScreenWidth, kScreenHeight)];
    UINib *Nib;
    if (x==0) {
        Nib = [UINib nibWithNibName:@"TicketCellTableViewCell" bundle:nil];
        [tableView registerNib:Nib forCellReuseIdentifier:@"MYCELL"];
    }
    
//    tableView.backgroundColor = WZBColor((arc4random() % 255) + 1,(arc4random() % 255) + 1, (arc4random() % 255) + 1);
    UIView *headerView = [[UIView alloc] initWithFrame:(CGRect){0, 0, kScreenWidth, _LEN + 44}];
    tableView.tableHeaderView = headerView;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    tableView.showsVerticalScrollIndicator = NO;
    [_tableViewList addObject:tableView];
    [self.scrollView addSubview:tableView];
    [tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionInitial context:nil];
}

// 刷新最大OffsetY，让三个tableView同步
- (void)reloadMaxOffsetY {
    // 计算出最大偏移量
    CGFloat maxOffsetY = 0;
    for (UITableView *tb in self.tableViewList) {
        if (tb.contentOffset.y > maxOffsetY) {
            maxOffsetY = tb.contentOffset.y;
        }
    }
    
    // 如果最大偏移量大于_LEN，处理下每个tableView的偏移量
    if (maxOffsetY > _LEN) {
        for (UITableView *tb in _tableViewList) {
            if (tb.contentOffset.y < _LEN) {
                tb.contentOffset = CGPointMake(0, _LEN);
            }
        }
    }
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self reloadMaxOffsetY];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.scrollView) {
        // 改变segmentdControl
        [_sectionView setContentOffset:(CGPoint){scrollView.contentOffset.x / 3, 0}];
    }
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"contentOffset"]) {
        UITableView *tableView = object;
        CGFloat contentOffsetY = tableView.contentOffset.y;
        
        // 如果滑动没有超过_LEN
        if (contentOffsetY < _LEN) {
            // 让这三个tableView的偏移量相等
            for (UITableView *tb in _tableViewList) {
                if (tb.contentOffset.y != tableView.contentOffset.y) {
                    tb.contentOffset = tableView.contentOffset;
                }
            }
            
            CGFloat headerY = - tableView.contentOffset.y;
            CGRect frame = _topView.frame;
            frame.origin.y = headerY;
            _topView.frame = frame;
        } else if (contentOffsetY >= _LEN) {
            CGRect frame = _topView.frame;
            frame.origin.y =-1 * [UIScreen mainScreen].bounds.size.width * 9.f / 16.f;
            _topView.frame = frame;
        }
        
    }
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView==_tableViewList[0]) {
        return _ticketList.count;
    }
    
    return 30;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == _tableViewList[0]) {
        TicketCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MYCELL" forIndexPath:indexPath];
        [cell cellSetModel:_ticketList[indexPath.row]];
        return cell;
        
    }

    
    NSString *cellId = [NSString stringWithFormat:@"%@cellId", NSStringFromClass(self.class)];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.backgroundColor = [UIColor colorWithWhite:0.998 alpha:1];
    cell.textLabel.text = [NSString stringWithFormat:@"%ld ",(long)indexPath.row];
    return cell;
}
@end
