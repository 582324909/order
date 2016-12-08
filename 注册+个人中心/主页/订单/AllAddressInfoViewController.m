//
//  AllAddressInfoViewController.m
//  注册+个人中心
//
//  Created by 张伟伟 on 16/8/8.
//  Copyright © 2016年 张伟伟. All rights reserved.
//

#import "AllAddressInfoViewController.h"
#import "URLHead.h"
#import "AppDelegate.h"
#import "AddressInfoTableViewCell.h"
#import "ModifyAddressTableViewController.h"

#import "AFNetworking.h"

static NSString *shopName;
static NSString *masterName;
static NSString *masterSex;
static NSString *telephone;
static NSString *address;

@interface AllAddressInfoViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) AppDelegate *appDelegate;
@property (nonatomic ,strong) NSArray *dataArray;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation AllAddressInfoViewController

-(NSArray *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [[NSArray alloc] init];
    }
    return _dataArray;
}

-(void)viewDidAppear:(BOOL)animated {
    [self viewDidLoad];
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    self.appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [self loadData];
    [super viewDidLoad];
}

#pragma mark-加载数据
-(void)loadData {
    AFHTTPSessionManager *httpSession = [AFHTTPSessionManager manager];
    httpSession.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    
    parameter[@"merchant_userid"] = [NSString stringWithFormat:@"%d",self.appDelegate.user_id];
    
    [httpSession POST:allAddressInfoURL parameters:parameter  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        if ([dic[@"code"] intValue] == 0) {
            self.dataArray = dic[@"info"];
            [self.tableView reloadData];
        }else if ([dic[@"code"] intValue] == 1){
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"数据加载失败" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alertView show];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"链接服务器失败" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
    }];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AddressInfoTableViewCell*cell = [AddressInfoTableViewCell infoCellWithTableView:self.tableView];
    cell.name.text = self.dataArray[indexPath.row][@"merchant_master"];
    if ([self.dataArray[indexPath.row][@"merchant_sex"] isEqualToString:@"男"]) {
        cell.sex.text = @"先生";
    }else {
        cell.sex.text = @"女士";
    }
    cell.telephone.text = self.dataArray[indexPath.row][@"merchant_mobile"];
    cell.address.text = self.dataArray[indexPath.row][@"merchant_address"];
    
    return cell;
    
}

- (IBAction)toCreateClick:(id)sender {
    [self.navigationController pushViewController:[self changeController:@"create" WithStoryboard:@"Info"] animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    AddressInfoTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    masterName = cell.name.text;
    masterSex = cell.sex.text;
    shopName = self.dataArray[indexPath.row][@"merchant_shopname"];
    telephone = self.dataArray[indexPath.row][@"merchant_mobile"];
    address = self.dataArray[indexPath.row][@"merchant_address"];
    self.appDelegate.shop_id = self.dataArray[indexPath.row][@"merchant_id"];

    [self performSegueWithIdentifier:@"toModify" sender:nil];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    ModifyAddressTableViewController *vc = segue.destinationViewController;
    vc.nameBlock = ^NSString *{
        return masterName;
    };
    vc.sexBlock = ^NSString *{
        return masterSex;
    };
    vc.shopNameBlock = ^NSString *{
        return shopName;
    };
    vc.telephoneBlock = ^NSString *{
        return telephone;
    };
    vc.addressBlock = ^NSString *{
        return address;
    };
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
