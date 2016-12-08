//
//  OrderViewController.m
//  注册+个人中心
//
//  Created by 张伟伟 on 16/8/4.
//  Copyright © 2016年 张伟伟. All rights reserved.
//

#import "OrderViewController.h"
#import "AppDelegate.h"
#import "URLHead.h"

#import "AFNetworking.h"
#import "MBProgressHUD.h"

static NSString *jobName;
static NSString *masterName;
static NSString *masterSex;

@interface OrderViewController ()<UIPickerViewDelegate,UIPickerViewDataSource,UIAlertViewDelegate>

@property (nonatomic,strong) AppDelegate *appDelegate;

@property (weak, nonatomic) IBOutlet UIView *coverView;
@property (weak, nonatomic) IBOutlet UIPickerView *jobPickerView;
@property (weak, nonatomic) IBOutlet UILabel *jobLabel;
@property (weak, nonatomic) IBOutlet UILabel *peopleNumLabel;

@property (strong, nonatomic) NSArray *jobArray;

@end

@implementation OrderViewController

-(void)viewWillAppear:(BOOL)animated {
}

- (void)viewDidLoad {
    
    self.appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    self.jobArray = [[NSArray alloc] initWithObjects:@" ",@"服务员",@"传菜员",@"家教",@"代驾",@"检票员", nil];
    
    self.coverView.hidden = YES;
    self.coverView.layer.cornerRadius = 10;
    self.coverView.layer.masksToBounds = YES;
    
    [super viewDidLoad];
}

#pragma mark-pickView
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.jobArray.count;
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString *job = self.jobArray[row];
    return job;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    jobName = self.jobArray[row];
    NSLog(@"%@",self.jobArray[row]);
}

#pragma mark-button
- (IBAction)chooseNumClick:(id)sender {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"可以支付的薪资" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [alertView setTag:301];
    [alertView show];
}

- (IBAction)chooseJobClick:(id)sender {
    self.coverView.hidden = NO;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex  {
    if (alertView.tag == 301) {
        if (buttonIndex == 1) {
            UITextField *evaluate = [alertView textFieldAtIndex:0];
            evaluate.placeholder = @"输入您可以支付的最高时薪";
            self.appDelegate.price = evaluate.text;
            self.peopleNumLabel.text = [NSString stringWithFormat:@"我能提供%@元的薪资",evaluate.text];
        }
    }else if (alertView.tag == 302) {
        if (buttonIndex == 1) {
            UITextField *evaluate = [alertView textFieldAtIndex:0];
            if (evaluate.text.length > 0) {
                [self searchWithNumber:evaluate.text];
            }
        }
    }
}

- (IBAction)cancelClick:(id)sender {
    self.coverView.hidden = YES;
}

- (IBAction)doneClick:(id)sender {
    if (!jobName) {
        self.jobLabel.text = @"请选择要招聘的职位";
    }
    self.jobLabel.text = [NSString stringWithFormat:@"我要招%@",jobName];
    self.coverView.hidden = YES;
}

- (IBAction)searchClick:(id)sender {
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.labelText = @"正在为您查询...";
    [HUD showAnimated:YES whileExecutingBlock:^{
        sleep(1.5);
    } completionBlock:^{
        [self searchEmployee];
        [HUD removeFromSuperview];
    }];
}

- (IBAction)help:(id)sender {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"请输入您想招聘的人数" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [alertView setTag:302];
    [alertView show];
}

//自定义界面跳转方法
-(UIViewController *)changeController:(NSString *)controllerIdentifier WithStoryboard:(NSString *)storyboardName {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    UIViewController *controller = [storyboard instantiateViewControllerWithIdentifier:controllerIdentifier];
    return controller;
}

#pragma mark-查询雇员信息
-(void)searchEmployee {
    AFHTTPSessionManager *httpSession = [AFHTTPSessionManager manager];
    httpSession.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    
    parameter[@"job"] = jobName;
    parameter[@"price"] = self.appDelegate.price;

    [httpSession POST:searchEmployeeURL parameters:parameter  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        if ([dic[@"code"] intValue] == 0) {
           [self.navigationController pushViewController:[self changeController:@"order_search" WithStoryboard:@"Info"] animated:YES];
            self.appDelegate.orderResultArray = dic[@"info"];
            
        }else if ([dic[@"code"] intValue] == 1){
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"没有符合条件的雇员..." delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alertView show];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"链接服务器失败" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
        self.appDelegate.orderResultArray = @[@"未查询到结果"];
    }];
}

-(void)searchWithNumber:(NSString *)num {
    AFHTTPSessionManager *httpSession = [AFHTTPSessionManager manager];
    httpSession.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    
    parameter[@"job"] = jobName;
    parameter[@"price"] = self.appDelegate.price;
    parameter[@"number"] = num;
    
    [httpSession POST:searchWithNumURL parameters:parameter  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        if ([dic[@"code"] intValue] == 0) {
            [self.navigationController pushViewController:[self changeController:@"order_search" WithStoryboard:@"Info"] animated:YES];
            self.appDelegate.orderResultArray = dic[@"info"];
            
        }else if ([dic[@"code"] intValue] == 1){
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"没有符合条件的雇员..." delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alertView show];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"链接服务器失败" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
        self.appDelegate.orderResultArray = @[@"未查询到结果"];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
