//
//  SearchResultViewController.m
//  注册+个人中心
//
//  Created by 张伟伟 on 16/8/4.
//  Copyright © 2016年 张伟伟. All rights reserved.
//

#import "SearchResultViewController.h"
#import "AppDelegate.h"
#import "SearchResultTableViewCell.h"
#import "URLHead.h"

#import "AFNetworking.h"

static NSString *employee_id;
static int status;

@interface SearchResultViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) AppDelegate *appDelegate;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSMutableArray *employeeArray;

@end

@implementation SearchResultViewController

//懒加载
-(NSMutableArray *)employeeArray {
    if (_employeeArray == nil) {
        _employeeArray = [[NSMutableArray alloc] init];
    }
    return _employeeArray;
}

- (void)viewDidLoad {
    self.appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    self.dataArray = self.appDelegate.orderResultArray;
    [super viewDidLoad];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    return  @"提示：左滑可选择(取消选择)雇员";
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 15;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SearchResultTableViewCell *cell = [SearchResultTableViewCell searchResultcellWithTableView:self.tableView];

    cell.name.text = self.dataArray[indexPath.row][@"employee_name"];
    cell.sex.text = self.dataArray[indexPath.row][@"employee_sex"];
    cell.salary.text = [NSString stringWithFormat:@"期望时薪为：%@",self.dataArray[indexPath.row][@"employee_minsalary"]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    SearchResultTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    employee_id = self.dataArray[indexPath.row][@"employee_userid"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UITableViewRowAction *done = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"我要了" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        cell.backgroundColor = [UIColor redColor];
        [self.employeeArray addObject:employee_id];
        cell.status = 1;
        status = cell.status;
    }];
    
    UITableViewRowAction *cancel = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"不要了" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        [self.employeeArray removeObject:employee_id];
        cell.backgroundColor = [UIColor clearColor];
        cell.status = 0;
        status = cell.status;
    }];
    cancel.backgroundColor = [UIColor blueColor];
    
    if (cell.status == 0) {
        return @[done];
    }else if (cell.status == 1) {
        return @[cancel];
    }
    return nil;
}

-(void)submitOrder {
    AFHTTPSessionManager *httpSession = [AFHTTPSessionManager manager];
    httpSession.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    
    parameter[@"employee_id"] = self.employeeArray;
    parameter[@"userid"] = [NSString stringWithFormat:@"%d",self.appDelegate.user_id];
    parameter[@"job"] = self.dataArray[0][@"employee_post"];
    parameter[@"number"] = [NSString stringWithFormat:@"%lu",(unsigned long)[self.employeeArray count]];
    float totalPrice = [self.appDelegate.price floatValue] * (float)[self.employeeArray count];
    parameter[@"price"] = [NSString stringWithFormat:@"%.2f",totalPrice];

    [httpSession POST:submitOrderURL parameters:parameter  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        NSLog(@"%@",dic);
        
        if ([dic[@"code"] intValue] == 0) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"下单失败" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alertView show];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"链接服务器失败" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.appDelegate.indexOfCell = (int)indexPath.row;
    self.appDelegate.isChoose = indexPath;
    self.appDelegate.classVc = 1;
    [self.navigationController pushViewController:[self changeController:@"employee_info" WithStoryboard:@"Info"] animated:YES];
}

- (IBAction)orderClick:(id)sender {
    if ([self.employeeArray count] != 0) {
        [self submitOrder];
    }
}

//自定义界面跳转方法
-(UIViewController *)changeController:(NSString *)controllerIdentifier WithStoryboard:(NSString *)storyboardName {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    UIViewController *controller = [storyboard instantiateViewControllerWithIdentifier:controllerIdentifier];
    return controller;
}

@end
