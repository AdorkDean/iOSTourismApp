//
//  MineViewController.m
//  TourismApp
//
//  Created by 管理员 on 2017/11/15.
//  Copyright © 2017年 dragon. All rights reserved.
//

#import "MineViewController.h"
#import "BaseNavigationController.h"
#import "LoginViewController.h"
#import "TitleCell.h"
@interface MineViewController ()<UIScrollViewDelegate,UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<NSString *> *titleList;
@property (nonatomic, strong) NSMutableArray<NSString *> *icon_name;


@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _titleList = [NSMutableArray arrayWithObjects:@"我的订单",@"我的信息",@"设置",@"意见反馈", nil];
    _icon_name = [NSMutableArray arrayWithObjects:@"title_order",@"title_mineif",@"title_setting",@"title_feedback", nil];
//    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [UIView new];
    UINib *Nib = [UINib nibWithNibName:@"TitleCell" bundle:nil];
    [_tableView registerNib:Nib forCellReuseIdentifier:@"MYCELL"];
    

}


- (IBAction)test:(id)sender {
    
    LoginViewController *vc = [[LoginViewController alloc] init];
    BaseNavigationController *loginNVC = [[BaseNavigationController alloc] initWithRootViewController:vc];
    
    loginNVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:loginNVC animated:YES completion:^{
        
    }];
}

#pragma mark tableView数据
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _titleList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TitleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MYCELL" forIndexPath:indexPath];
    cell.title.text = _titleList[indexPath.row];
    cell.icon_title.image = [UIImage imageNamed:_icon_name[indexPath.row]];
    return cell;
}




//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//}



@end
