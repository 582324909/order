//
//  ProcessViewController.m
//  注册+个人中心
//
//  Created by 张伟伟 on 16/8/13.
//  Copyright © 2016年 张伟伟. All rights reserved.
//

#import "ProcessViewController.h"
#import "EmployeeTableViewCell.h"
#import "AppDelegate.h"
#import "URLHead.h"
#import "AttendanceTableViewCell.h"
#import "TimeLineView.h"

#import "MBProgressHUD.h"
#import "AFNetworking.h"

static int cellCount = 0;

#define kCellHeight             90
#define kDelayFactor            0.3
#define kAnimationDuration      0.6

@interface ProcessViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *employeeTableview;
@property (weak, nonatomic) IBOutlet UITableView *timeTableview;

@property (nonatomic, strong) AppDelegate *appDelegate;
@property (nonatomic, weak) TimeLineView *timeLineView;
@property (nonatomic, strong) TimeLineView *tableLine;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSArray *timeArray;
@property (nonatomic, strong) NSArray *statusArray;

@end

@implementation ProcessViewController

-(NSArray *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [[NSArray alloc] init];
    }
    return _dataArray;
}

-(void)viewWillAppear:(BOOL)animated {
    [self.employeeTableview setTag:101];
    [self.timeTableview setTag:201];
    self.appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [self loadData];
    [self loadTimeData];
    [self viewDidLoad];
}

- (void)viewDidLoad {
    
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.labelText = @"正在加载...";
    [HUD showAnimated:YES whileExecutingBlock:^{
        sleep(1.0);
    } completionBlock:^{
        [HUD removeFromSuperview];
    }];
    
    self.employeeTableview.tableHeaderView = nil;
    [super viewDidLoad];
}

-(void)loadTimeData {
    AFHTTPSessionManager *httpSession = [AFHTTPSessionManager manager];
    httpSession.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    parameter[@"userid"] = [NSString stringWithFormat:@"%d",self.appDelegate.user_id];
    parameter[@"order_id"] = self.appDelegate.order_id;
    
    [httpSession POST:appointOrderURL parameters:parameter success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        cellCount = [dic[@"info"][0][@"order_status"] intValue];
        NSArray *array = [[NSArray alloc] init];
        NSMutableArray *temp = [[NSMutableArray alloc] init];
        array = @[dic[@"info"][0][@"timestamp"],dic[@"info"][0][@"start_time"],dic[@"info"][0][@"receive_time"],dic[@"info"][0][@"finish_time"]];
        for (int i = cellCount - 1; i >= 0 ; i--) {
            [temp addObject:array[i]];
        }
        self.timeArray = [NSArray arrayWithArray:temp];
        [self.timeTableview reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"链接服务器失败" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
    }];
}

-(void)loadData {
    
    AFHTTPSessionManager *httpSession = [AFHTTPSessionManager manager];
    httpSession.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    
    parameter[@"order_id"] = self.appDelegate.order_id;
    
    [httpSession POST:employeeURL parameters:parameter success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        self.dataArray = dic[@"info"];
        self.appDelegate.orderResultArray = self.dataArray;
        [self.employeeTableview reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"链接服务器失败" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
    }];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView.tag == 101) {
        return self.dataArray.count;
    }else {
        return 1;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView.tag == 101) {
        return 1;
    }else {
        return cellCount;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == 101) {
        EmployeeTableViewCell *cell = [EmployeeTableViewCell employeeCellWithTableView:self.employeeTableview];
        for (int i = 0; i < self.dataArray.count; i++) {
            if (indexPath.section == i) {
                NSString *sex;
                if ([self.dataArray[i][@"employee_sex"] isEqualToString:@"男"]) {
                    sex = @"先生";
                }else {
                    sex = @"女士";
                }
                cell.name.text = [NSString stringWithFormat:@"%@  %@",self.dataArray[i][@"employee_name"],sex];
                cell.price.text = self.dataArray[i][@"employee_minsalary"];
                cell.telephone.text = self.dataArray[i][@"employee_mobile"];
            }
        }
        return cell;
    }else {
        AttendanceTableViewCell *cell = [AttendanceTableViewCell timeCellWithTableView:self.timeTableview];
        [self status];
        cell.dateLabel.text = self.timeArray[indexPath.row];
        cell.processLabel.text = self.statusArray[indexPath.row];
        return cell;
    }
    return nil;
}

-(void)status {
    NSArray *array = [[NSArray alloc] initWithObjects:@"开始下单",@"已付款",@"订单进行中...",@"订单已完成", nil];
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    for (int i = cellCount - 1;i >= 0 ; i--) {
        [temp addObject:array[i]];
    }
    self.statusArray = [NSArray arrayWithArray:temp];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == 101) {
        return 60;
    }else {
        return kCellHeight;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (tableView.tag == 101) {
        return 10;
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == 101) {
        UITableViewCell *cell = [self.employeeTableview cellForRowAtIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        self.appDelegate.indexOfCell = (int)indexPath.section;
        [self.navigationController pushViewController:[self changeController:@"employee_info" WithStoryboard:@"Info"] animated:YES];
    }
}

//自定义界面跳转方法
-(UIViewController *)changeController:(NSString *)controllerIdentifier WithStoryboard:(NSString *)storyboardName {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    UIViewController *controller = [storyboard instantiateViewControllerWithIdentifier:controllerIdentifier];
    return controller;
}

#pragma mark -TableView timeLine

- (TimeLineView *)tableLine
{
    if (!_tableLine) {
        _tableLine = [[TimeLineView alloc] init];
        _tableLine.backgroundColor = self.timeTableview.backgroundColor;
        [self.timeTableview addSubview:_tableLine];
    }
    return _tableLine;
}

#pragma  mark -UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y < 0) {
        self.tableLine.frame = CGRectMake(1, scrollView.contentOffset.y, 40, -scrollView.contentOffset.y);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
