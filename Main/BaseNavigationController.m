//
//  BaseNavigationController.m
//  TourismApp
//
//  Created by 管理员 on 2017/11/15.
//  Copyright © 2017年 dragon. All rights reserved.
//

#import "BaseNavigationController.h"
#import "Utils.h"

@interface BaseNavigationController ()

@end

@implementation BaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationBar setBackgroundImage:[Utils saImageWithSingleColor:[UIColor colorWithRed:7.f/255.f green:59.f/255.f blue:86.f/255.f alpha:1.f]] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    [self.navigationBar setTintColor:[UIColor whiteColor]];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    UIViewController *vc = self.topViewController;
    UIStatusBarStyle style = [vc preferredStatusBarStyle];
    return style;
}



@end
