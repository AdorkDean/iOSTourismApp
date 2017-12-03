//
//  LoginViewController.m
//  TourismApp
//
//  Created by 管理员 on 2017/11/19.
//  Copyright © 2017年 dragon. All rights reserved.
//

#import "LoginViewController.h"
#import "GCAPIClient.h"
#import "UIView+Toast.h"
#import "UserModel.h"
#import "YYModel.h"
#import "RegistrViewController.h"
@interface LoginViewController ()
@property (strong, nonatomic) IBOutlet UITextField *phoneInput;
@property (strong, nonatomic) IBOutlet UITextField *passInput;
@property (strong, nonatomic) IBOutlet UIButton *LoginBtn;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    UIImageView *title = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 160, 20)];
//    title.image = [UIImage imageNamed:@"loginTitle"];
//    self.navigationItem.titleView = title;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(backMainController)];
    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"注册" style:UIBarButtonItemStylePlain target:self action:@selector(registViewController)];
}

//点击界面
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}
- (void)backMainController {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (IBAction)Login:(id)sender {
    if (_phoneInput.text.length > 1 && _passInput.text.length > 1) {
        GCAPIClient *manger = [GCAPIClient shareClient];
        NSLog(@"HBLog:%@",_phoneInput.text);
        NSLog(@"HBLog:%@",_passInput.text);
        
        
        [manger requestGetPath:@"/user/login.action" parameters:@{@"phone":_phoneInput.text,
                                                                  @"pass":_passInput.text
                                                                  } success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
                                                                      
                                                                      if ([responseObject[@"status"] integerValue] == 200) {
                                                                          
                                                                          NSDictionary *data = responseObject[@"data"];
                                                                          UserModel *user = [UserModel yy_modelWithDictionary:data];
                                                                          NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                                                                          [defaults setObject:user.uid forKey:@"uid"];
                                                                          [defaults setObject:user.phone forKey:@"account"];
                                                                          [defaults setObject:user.signinTime forKey:@"signinTime"];
                                                                          [defaults setObject:user.pass forKey:@"pass"];
                                                                          [defaults setObject:user.sex forKey:@"sex"];
                                                                          [defaults setObject:user.headImgPath forKey:@"headImgPath"];
                                                                          
                                                                      }else{
                                                                          NSString *msg = responseObject[@"msg"];
                                                                          [self.view makeToast:msg duration:1.0 position:CSToastPositionCenter];
                                                                      }
                                                                      
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error) {
            NSLog(@"HBLog:%@",error);
        }];
    }else{
          [self.view makeToast:@"手机号码或者密码长度不对" duration:1.0 position:CSToastPositionCenter];
    }
}

- (IBAction)Regist:(id)sender {
    RegistrViewController *rvc = [[RegistrViewController alloc] init];
    [self.navigationController pushViewController:rvc animated:YES];
}



@end
