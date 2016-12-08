//
//  CheckViewController.m
//  注册+个人中心
//
//  Created by 张伟伟 on 16/8/1.
//  Copyright © 2016年 张伟伟. All rights reserved.
//

#import "CheckViewController.h"
#import "AppDelegate.h"

#import <SMS_SDK/SMSSDK.h>

@interface CheckViewController ()

@property (weak, nonatomic) IBOutlet UITextField *messageField;

@property (nonatomic,strong) AppDelegate *appDelegate;

@end

@implementation CheckViewController

- (void)viewDidLoad {
    
    self.appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;

    [super viewDidLoad];
}

#pragma mark-点击继续按钮的事件
- (IBAction)continueClick:(id)sender {
    [SMSSDK commitVerificationCode:self.messageField.text phoneNumber:self.appDelegate.telephone zone:@"86" result:^(NSError *error) {
        if (!error) {
            [self presentViewController:[self changeController:@"password" WithStoryboard:@"Main"] animated:YES completion:nil];
        } else {
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:@"验证失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [av show];
            NSLog(@"失败");
        }
    }];
}

#pragma mark-返回事件
- (IBAction)backClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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
    [self.messageField resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
