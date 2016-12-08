//
//  QueryOrderViewController.m
//  注册+个人中心
//
//  Created by 张伟伟 on 16/8/10.
//  Copyright © 2016年 张伟伟. All rights reserved.
//

#import "QueryOrderViewController.h"
#import "AppDelegate.h"
#import "URLHead.h"
#import "OrderTableViewCell.h"

#import "AFNetworking.h"
#import "MBProgressHUD.h"

static NSInteger section;

@interface QueryOrderViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (nonatomic, strong) AppDelegate *appDelegate;
@property (nonatomic ,strong) NSArray *dataArray;

@end

@implementation QueryOrderViewController

-(NSArray *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [[NSArray alloc] init];
    }
    return _dataArray;
}

-(void)viewWillAppear:(BOOL)animated {
    [self queryOrder];
}

- (void)viewDidLoad {
    
    self.appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    [super viewDidLoad];
}

-(void)queryOrder {
    AFHTTPSessionManager *httpSession = [AFHTTPSessionManager manager];
    httpSession.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    parameter[@"userid"] = [NSString stringWithFormat:@"%d",self.appDelegate.user_id];
    
    [httpSession POST:queryOrderURL parameters:parameter success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        if ([dic[@"code"] intValue] == 0) {
            self.dataArray = dic[@"info"];
            [self.tableview reloadData];
        }else if ([dic[@"code"] intValue] == 1){
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"无有效的订单" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alertView show];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"链接服务器失败" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
    }];
}

-(void)changeStatusWithOrderID:(NSString *)order_id andStatus:(NSString *)status{
    AFHTTPSessionManager *httpSession = [AFHTTPSessionManager manager];
    httpSession.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    parameter[@"status"] = status;
    parameter[@"order_id"] = order_id;
    
    [httpSession POST:changeStatusURL parameters:parameter success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        if ([dic[@"code"] intValue] == 0) {
            
        }else if ([dic[@"code"] intValue] == 1){
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"操作失败" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alertView show];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"链接服务器失败" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
    }];
}

-(void)changeStatusWithOrderID:(NSString *)order_id andStatus:(NSString *)status andevaluate:(NSString *)evaluate{
    AFHTTPSessionManager *httpSession = [AFHTTPSessionManager manager];
    httpSession.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    parameter[@"status"] = status;
    parameter[@"order_id"] = order_id;
    parameter[@"evaluate"] = evaluate;
    
    [httpSession POST:finshOrderURL parameters:parameter success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        if ([dic[@"code"] intValue] == 0) {
            [self messageShow];
        }else if ([dic[@"code"] intValue] == 1){
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"操作失败" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alertView show];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"链接服务器失败" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
    }];
}

-(void)messageShow {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.square = YES;
    hud.labelText = @"操作成功";
    [hud hide:YES afterDelay:1.0f];
}

#pragma mark-tableview
#pragma mark-cell点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.appDelegate.order_id = self.dataArray[indexPath.section][@"order_id"];
    [self.navigationController pushViewController:[self changeController:@"test01" WithStoryboard:@"Info"] animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OrderTableViewCell *cell = [OrderTableViewCell orderTableViewCellWithTableView:tableView];
    for (int i = 0; i < self.dataArray.count; i++) {
        if (indexPath.section == i) {
            NSInteger order_id = [self.dataArray[i][@"order_id"] integerValue];
            [cell setTag:order_id];
            cell.number.text = self.dataArray[i][@"order_id"];
            cell.time.text = self.dataArray[i][@"timestamp"];
            cell.job.text = self.dataArray[i][@"work_type"];
            cell.price.text = [NSString stringWithFormat:@"%@元",self.dataArray[i][@"price"]];
            cell.count.text = self.dataArray[i][@"required_number"];
            [cell.btn setTag:[self.dataArray[i][@"order_status"] intValue] + 100];
            [cell.btn addTarget:self action:@selector(status:) forControlEvents:UIControlEventTouchUpInside];
            if ([self.dataArray[i][@"order_status"] intValue] == 1) {
                [cell.btn setTitle:@"点击付款" forState:UIControlStateNormal];
                cell.status.text = @"未付款";
            }else if ([self.dataArray[i][@"order_status"] intValue] == 2) {
                [cell.btn setTitle:@"确认完工" forState:UIControlStateNormal];
                cell.status.text = @"已付款";
            }else if ([self.dataArray[i][@"order_status"] intValue] == 3) {
                [cell.btn setTitle:@"去评价" forState:UIControlStateNormal];
                cell.status.text = @"已完成，待评价";
            }else if ([self.dataArray[i][@"order_status"] intValue] == 4) {
                cell.btn.hidden = YES;
                cell.status.text = @"已评价";
            }
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 110;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}

#pragma mark-状态button
-(void)status:(UIButton *)sender {
    UITableViewCell * cell = (UITableViewCell *)[[sender superview] superview];
    section = cell.tag;
    if (sender.tag == 101) {
        [self pay];
    }else if (sender.tag == 102) {
        [self after];
    }else if (sender.tag == 103) {
        [self finish];
    }
}

-(void)pay {
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.labelText = @"准备付款";
    [HUD showAnimated:YES whileExecutingBlock:^{
        sleep(1.5);
    } completionBlock:^{
        [HUD removeFromSuperview];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否进行付款" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView setTag:202];
        [alertView show];
    }];
}

-(void)after {
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.labelText = @"正在查看订单";
    [HUD showAnimated:YES whileExecutingBlock:^{
        sleep(1.5);
    } completionBlock:^{
        [HUD removeFromSuperview];
        OrderTableViewCell * cell = (OrderTableViewCell *)[self.view viewWithTag:section];
        [cell.btn setTitle:@"去评价" forState:UIControlStateNormal];
        cell.status.text = @"已完成，待评价";
        [self changeStatusWithOrderID:[NSString stringWithFormat:@"%ld",cell.tag] andStatus:@"3"];
        cell.btn.selected = NO;
        [cell.btn setTag:103];
    }];
}

-(void)finish {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请您评价" delegate:self cancelButtonTitle:@"不评价" otherButtonTitles:@"评价",nil];
    [alertView setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [alertView show];
    [alertView setTag:201];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex  {
    if (alertView.tag == 201) {
        if (buttonIndex == 1) {
            OrderTableViewCell * cell = (OrderTableViewCell *)[self.view viewWithTag:section];
            cell.btn.hidden = YES;
            cell.status.text = @"已评价";
            UITextField *evaluate = [alertView textFieldAtIndex:0];
            NSLog(@"%@",evaluate.text);
            [self changeStatusWithOrderID:[NSString stringWithFormat:@"%ld",cell.tag] andStatus:@"4" andevaluate:evaluate.text];
            cell.btn.selected = NO;
            [cell.btn setTag:104];
        }
    }else if(alertView.tag == 202){
        if (buttonIndex == 1) {
            OrderTableViewCell * cell = (OrderTableViewCell *)[self.view viewWithTag:section];
            [self changeStatusWithOrderID:[NSString stringWithFormat:@"%ld",cell.tag] andStatus:@"2"];
            [cell.btn setTitle:@"确认完工" forState:UIControlStateNormal];
            cell.status.text = @"已付款";
            cell.btn.selected = NO;
            [cell.btn setTag:102];
        }
    }
}

//自定义界面跳转方法
-(UIViewController *)changeController:(NSString *)controllerIdentifier WithStoryboard:(NSString *)storyboardName {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    UIViewController *controller = [storyboard instantiateViewControllerWithIdentifier:controllerIdentifier];
    return controller;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
