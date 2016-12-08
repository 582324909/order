//
//  TelViewController.m
//  注册+个人中心
//
//  Created by 张伟伟 on 16/8/1.
//  Copyright © 2016年 张伟伟. All rights reserved.
//

#import "TelViewController.h"
#import "AppDelegate.h"
#import "URLHead.h"

#import <SMS_SDK/SMSSDK.h>
#import "AFNetworking.h"
#import "MBProgressHUD.h"

@interface TelViewController ()

@property (weak, nonatomic) IBOutlet UITextField *telephoneField;

@property (nonatomic,strong) AppDelegate *appDelegate;

@end

@implementation TelViewController

- (void)viewDidLoad {
    
    self.appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    [super viewDidLoad];
}

#pragma mark-点击继续按钮的事件
- (IBAction)continueClick:(id)sender {
    
    if (self.telephoneField.text.length > 1) {
        [self checkTelephone];
        MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        HUD.labelText = @"正在发送短信验证...";
        [HUD showAnimated:YES whileExecutingBlock:^{
            sleep(1.5);
        } completionBlock:^{
            [HUD removeFromSuperview];
        }];
    }
}

- (IBAction)backClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark-请求短信验证
-(void)sendMessage {
    
    self.appDelegate.telephone = self.telephoneField.text;
    
    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:self.telephoneField.text zone:@"86" customIdentifier:nil result:^(NSError *error) {
        if (!error) {
            [self presentViewController:[self changeController:@"checking" WithStoryboard:@"Main"] animated:YES completion:nil];
        } else {
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:@"发送失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [av show];
        }
    }];
}

#pragma mark-保存数据,生成账号
-(void)checkTelephone {
    AFHTTPSessionManager *httpSession = [AFHTTPSessionManager manager];
    httpSession.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    
    parameter[@"telephone"] = self.telephoneField.text;
    
    [httpSession POST:checkTel parameters:parameter  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        if ([dic[@"code"] intValue] == 0) {
            
            [self sendMessage];
            
        }else if ([dic[@"code"] intValue] == 1){
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"手机号已被注册" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alertView show];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"链接服务器失败" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
    }];
}


#pragma mark-跳转到登录界面
- (IBAction)toLoginClick:(id)sender {
    [self presentViewController:[self changeController:@"loginViewController" WithStoryboard:@"Main"] animated:YES completion:nil];
}

//自定义界面跳转方法
-(UIViewController *)changeController:(NSString *)controllerIdentifier WithStoryboard:(NSString *)storyboardName {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    UIViewController *controller = [storyboard instantiateViewControllerWithIdentifier:controllerIdentifier];
    return controller;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.telephoneField resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
