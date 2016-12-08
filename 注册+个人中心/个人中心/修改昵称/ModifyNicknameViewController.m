//
//  ModifyNicknameViewController.m
//  注册+个人中心
//
//  Created by 张伟伟 on 16/8/16.
//  Copyright © 2016年 张伟伟. All rights reserved.
//

#import "ModifyNicknameViewController.h"
#import "AppDelegate.h"
#import "URLHead.h"

#import "AFNetworking.h"

@interface ModifyNicknameViewController ()

@property (weak, nonatomic) IBOutlet UITextField *name;

@property (nonatomic,strong) AppDelegate *appDelegate;

@end

@implementation ModifyNicknameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
}

- (IBAction)modifyClick:(id)sender {
    if (self.name.text.length > 0) {
        [self modifyNickname];
    }
}

#pragma mark-修改数据
-(void)modifyNickname {
    AFHTTPSessionManager *httpSession = [AFHTTPSessionManager manager];
    httpSession.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    
    parameter[@"userid"] = [NSString stringWithFormat:@"%d",self.appDelegate.user_id];
    parameter[@"nickname"] = self.name.text;
    
    [httpSession POST:modifyNicknameURL parameters:parameter  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        if ([dic[@"code"] intValue] == 0) {
            
            self.appDelegate.nickname = self.name.text;
            [self.navigationController popViewControllerAnimated:YES];
            
        }else if ([dic[@"code"] intValue] == 1){
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"修改失败" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alertView show];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"链接服务器失败" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
