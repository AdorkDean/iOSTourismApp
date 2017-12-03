//
//  RegistrViewController.m
//  TourismApp
//
//  Created by 管理员 on 2017/11/20.
//  Copyright © 2017年 dragon. All rights reserved.
//


#import "RegistrViewController.h"
#import "GCAPIClient.h"
#import "UIView+Toast.h"
#import "TourismApp-Bridging-Header.h"
@interface RegistrViewController ()<UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *phoneInput;
@property (strong, nonatomic) IBOutlet UITextField *verificationCodeInput;
@property (strong, nonatomic) IBOutlet UITextField *passwordInput;
@property (strong, nonatomic) IBOutlet UITextField *confirmpasswordInput;
@property (strong, nonatomic) IBOutlet UIButton *sendVerCode;
@property (strong, nonatomic) IBOutlet UIButton *registBtu;


@property(nonatomic, strong) NSTimer *timer; // timer
@property(nonatomic, assign) int countDown; // 倒数计时用
@property(nonatomic, strong) NSDate *beforeDate; // 上次进入后台时间
@property(nonatomic, strong) NSString *respondCode;

@end

@implementation RegistrViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.phoneInput.delegate = self;
    self.verificationCodeInput.delegate = self;
    self.passwordInput.delegate = self;
    
    //    [self.phoneInput addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    //    [self.passwordInput addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    //    [self.verificationCodeInput addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    
    
}
#pragma mark 发送验证码
- (IBAction)SendVerification:(id)sender {
        if ((_phoneInput.text.length  != 11)) {
            [self.view makeToast:@"手机号码长度不正确" duration:1.0 position:CSToastPositionCenter];
            return ;
        }
        GCAPIClient *manger  = [GCAPIClient shareClient];
        [manger requestGetPath:@"SendMessage/registCode.action" parameters:@{@"to":_phoneInput.text} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
            if ([responseObject[@"status"] integerValue]==200) {
                _respondCode = responseObject[@"data"];
                NSLog(@"HBLog:%@",_respondCode);
                [self.view makeToast:responseObject[@"mag"] duration:1.0 position:CSToastPositionCenter];
                [self startCountDown];
    
            }else{
                [self.view makeToast:responseObject[@"mag"] duration:1.0 position:CSToastPositionCenter];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error) {
            [self.view makeToast:@"网络错误" duration:1.0 position:CSToastPositionCenter];
        }];
}


#pragma mark 发起注册
- (IBAction)Regist:(id)sender {
    if (_verificationCodeInput.text.length !=6 ){
        [self.view makeToast:@"验证码长度不正确" duration:1.0 position:CSToastPositionCenter];
        return ;
    }
    if (![_verificationCodeInput.text isEqualToString:_respondCode] ) {
        [self.view makeToast:@"验证码不正确" duration:1.0 position:CSToastPositionCenter];
        return ;
    }

    if (![_passwordInput.text isEqualToString:_confirmpasswordInput.text]) {
        [self.view makeToast:@"两次密码不一致" duration:1.0 position:CSToastPositionCenter];
        return;
    }

    if (_passwordInput.text.length < 6) {
        [self.view makeToast:@"密码长度应大于6位" duration:1.0 position:CSToastPositionCenter];
        return;
    }
    
    
    GCAPIClient *manger  = [GCAPIClient shareClient];
    [manger requestPostPath:@"user/regist.action" parameters:@{@"phone":_phoneInput.text,
                                                               @"pass":_passwordInput.text}
                                                               success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        if ([responseObject[@"status"] integerValue]==200) {
            _respondCode = responseObject[@"data"];
            [self.view makeToast:responseObject[@"mag"] duration:1.0 position:CSToastPositionCenter];
            [self startCountDown];
        }else{
            [self.view makeToast:responseObject[@"mag"] duration:1.0 position:CSToastPositionCenter];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error) {
        [self.view makeToast:@"网络错误" duration:1.0 position:CSToastPositionCenter];
        NSLog(@"HBLog:%@",error);
    }];
}


#pragma mark 计时相关
- (void)startCountDown {
    _countDown = 60;
    _sendVerCode.enabled = NO;
    _timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES]; // 需要加入手动RunLoop，需要注意的是在NSTimer工作期间self是被强引用的
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes]; // 使用NSRunLoopCommonModes才能保证RunLoop切换模式时，NSTimer能正常工作。
}

- (void)stopTimer {
    if (_timer) {
        [_timer invalidate];
    }
}
- (void)timerFired:(NSTimer *)timer {
    switch (_countDown) {
        case 1:
            [_sendVerCode setTitle:@"发送验证码" forState:UIControlStateNormal];
            _sendVerCode.enabled = YES;
            [self stopTimer];
            break;
        default:
            _countDown -= 1;
            [_sendVerCode setTitle:[NSString stringWithFormat:@"重发(%d)", _countDown] forState:UIControlStateNormal];
            break;
    }
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
    [self stopTimer]; // 如果没有在合适的地方销毁定时器就会内存泄漏啦，delloc也不可能执行。正确的销毁定时器这里可以不用写这个方法了，这里只是提个醒
}
//避免重新回到前台错误
- (void)setupNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterBG) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterFG) name:UIApplicationWillEnterForegroundNotification object:nil];
}
- (void)enterBG {
    _beforeDate = [NSDate date];
}
- (void)enterFG {
    NSDate *now = [NSDate date];
    int interval = (int) ceil([now timeIntervalSinceDate:_beforeDate]);
    //减掉后台那段时间
    int val = _countDown - interval;
    if (val > 1) {
        _countDown -= interval;
    } else {
        _countDown = 1;
    }
}
//点击界面
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}
- (void)hiddenKeyboardForTap {
    [_phoneInput resignFirstResponder];
    [_passwordInput resignFirstResponder];
    [_verificationCodeInput resignFirstResponder];
}
@end
