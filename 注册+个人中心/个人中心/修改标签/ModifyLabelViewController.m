//
//  ModifyLabelViewController.m
//  注册+个人中心
//
//  Created by 张伟伟 on 16/8/16.
//  Copyright © 2016年 张伟伟. All rights reserved.
//

#import "ModifyLabelViewController.h"
#import "AppDelegate.h"
#import "URLHead.h"

#import "AFNetworking.h"

static int count = 0;

@interface ModifyLabelViewController ()

@property (nonatomic,strong) AppDelegate *appDelegate;

@property (weak, nonatomic) IBOutlet UILabel *myLabel;

@end

@implementation ModifyLabelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    self.myLabel.text = self.appDelegate.insterest;
}

- (IBAction)sportClick:(UIButton *)sender {
    count ++;
    self.myLabel.text = sender.titleLabel.text;
}

- (IBAction)eatClick:(UIButton *)sender {
    count ++;
    self.myLabel.text = sender.titleLabel.text;
}

- (IBAction)tourClick:(UIButton *)sender {
    count ++;
    self.myLabel.text = sender.titleLabel.text;
}

- (IBAction)doneClick:(id)sender {
    if (count == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    [self modifyWithLabel:self.myLabel.text];
}

-(void)modifyWithLabel:(NSString *)label {
    AFHTTPSessionManager *httpSession = [AFHTTPSessionManager manager];
    httpSession.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    
    parameter[@"userid"] = [NSString stringWithFormat:@"%d",self.appDelegate.user_id];
    parameter[@"label"] = label;
    
    [httpSession POST:modifyLabelURL parameters:parameter success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        if ([dic[@"code"] intValue] == 0) {
            self.appDelegate.insterest = label;
            [self.navigationController popViewControllerAnimated:YES];
            
        }else if ([dic[@"code"] intValue] == 1){
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"修改失败" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alertView show];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"链接服务器失败" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
    }];
    
//    [httpSession POST:modifyLabelURL parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
//        if ([dic[@"code"] intValue] == 0) {
//            self.appDelegate.insterest = label;
//            [self.navigationController popViewControllerAnimated:YES];
//            
//        }else if ([dic[@"code"] intValue] == 1){
//            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"修改失败" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//            [alertView show];
//        }
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"链接服务器失败" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//        [alertView show];
//    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
