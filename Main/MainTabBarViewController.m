//
//  MainTabBarViewController.m
//  TourismApp
//
//  Created by 管理员 on 2017/11/15.
//  Copyright © 2017年 dragon. All rights reserved.
//

#import "MainTabBarViewController.h"

#import "BaseNavigationController.h"
#import "MineViewController.h"
#import "HomeViewController.h"

@interface MainTabBarViewController ()<UITabBarControllerDelegate, UITabBarDelegate>

@end

@implementation MainTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSArray *titles = @[@"首页", @"我的"];
    NSArray *images = @[@"icon_home", @"icon_mine"];
    NSArray *imagesSelect = @[@"icon_home_s", @"icon_mine_s"];
    self.tabBar.tintColor =  [UIColor colorWithRed:7.f/255.f green:59.f/255.f blue:86.f/255.f alpha:1.f];
    
    
    //首页
    UITabBarItem *homeTabItem = [[UITabBarItem alloc] initWithTitle:titles[0]
                                                              image:[[UIImage imageNamed:images[0]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                      selectedImage:[[UIImage imageNamed:imagesSelect[0]]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    HomeViewController  *homeVC = [[HomeViewController alloc] init];
    homeVC.tabBarItem = homeTabItem;
    BaseNavigationController *homeNVC = [[BaseNavigationController alloc] initWithRootViewController:homeVC];

    //我的
    UITabBarItem *mineTabItem = [[UITabBarItem alloc] initWithTitle:titles[1]
                                                              image:[[UIImage imageNamed:images[1]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                      selectedImage:[[UIImage imageNamed:imagesSelect[1]]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    MineViewController  *mineVC = [[MineViewController alloc] init];
    mineVC.tabBarItem = mineTabItem;
    BaseNavigationController *mineNVC = [[BaseNavigationController alloc] initWithRootViewController:mineVC];
    

    self.viewControllers = @[homeNVC,mineNVC];
    self.delegate = self;
}

@end
