//
//  NicknameViewController.m
//  注册+个人中心
//
//  Created by 张伟伟 on 16/8/1.
//  Copyright © 2016年 张伟伟. All rights reserved.
//

#import "NicknameViewController.h"
#import "AppDelegate.h"
#import "URLHead.h"

#import "AFNetworking.h"
#import "MBProgressHUD.h"


@interface NicknameViewController ()<UITextFieldDelegate>

@property (nonatomic,strong) AppDelegate *appDelegate;

@property (weak, nonatomic) IBOutlet UITextField *nickName;
@property (weak, nonatomic) IBOutlet UIButton *continueBtn;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;

@end

@implementation NicknameViewController

- (void)viewDidLoad {
    
    self.appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    self.nickName.delegate = self;
    self.continueBtn.hidden = YES;
    
    [super viewDidLoad];
}

#pragma mark-textField代理方法
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.tipLabel.hidden = YES;
    self.continueBtn.hidden = NO;
}

#pragma mark-点击继续按钮
- (IBAction)continueClick:(id)sender {
    if (self.nickName.text == nil || [self.nickName.text isEqualToString:@""]) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:@"昵称为空可打不好哦~" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [av show];
    }else {
        [self saveData];
    }
}

#pragma mark-保存数据,生成账号
-(void)saveData {
    AFHTTPSessionManager *httpSession = [AFHTTPSessionManager manager];
    httpSession.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    
    parameter[@"telephone"] = self.appDelegate.telephone;
    parameter[@"password"] = self.appDelegate.password;
    parameter[@"nickname"] = self.nickName.text;
    parameter[@"insterest"] = self.appDelegate.insterest;
    
    NSLog(@"%@",parameter);
    
    [httpSession POST:resgiterURL parameters:parameter  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        if ([dic[@"code"] intValue] == 0) {
            NSLog(@"%@",dic);
            [self createAccount];
            self.appDelegate.user_id = [dic[@"info"] intValue];
            self.appDelegate.nickname = self.nickName.text;
            
        }else if ([dic[@"code"] intValue] == 1){
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"创建失败~" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alertView show];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"链接服务器失败" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
    }];
}

//创建账号
-(void)createAccount {
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.labelText = @"正在为您创建账号...";
    [HUD showAnimated:YES whileExecutingBlock:^{
        sleep(1.5);
    } completionBlock:^{
        [self presentViewController:[self changeController:@"home" WithStoryboard:@"Info"] animated:YES completion:nil];
        [HUD removeFromSuperview];
    }];
    
}

//自定义界面跳转方法
-(UIViewController *)changeController:(NSString *)controllerIdentifier WithStoryboard:(NSString *)storyboardName {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    UIViewController *controller = [storyboard instantiateViewControllerWithIdentifier:controllerIdentifier];
    return controller;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.nickName resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
