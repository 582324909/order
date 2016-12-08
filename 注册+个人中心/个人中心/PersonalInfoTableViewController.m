//
//  PersonalInfoTableViewController.m
//  注册+个人中心
//
//  Created by 张伟伟 on 16/8/8.
//  Copyright © 2016年 张伟伟. All rights reserved.
//

#import "PersonalInfoTableViewController.h"
#include "AppDelegate.h"
#import "URLHead.h"

#import "AFNetworking.h"

static BOOL isNew;
static NSString *masterSex;

@interface PersonalInfoTableViewController ()<UIAlertViewDelegate>

@property (nonatomic,strong) AppDelegate *appDelegate;

@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *telephone;
@property (weak, nonatomic) IBOutlet UITextField *shopName;
@property (weak, nonatomic) IBOutlet UIButton *woman;
@property (weak, nonatomic) IBOutlet UIButton *man;
@property (weak, nonatomic) IBOutlet UIButton *modifyBtn;

@property (strong, nonatomic) UIView *coverView;

@end

@implementation PersonalInfoTableViewController

-(void)viewWillAppear:(BOOL)animated {
    self.appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [self loadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.modifyBtn setTitle:@"完成" forState:UIControlStateSelected];
    
    self.coverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height *0.4)];
    self.coverView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.coverView];
    
    if ([masterSex isEqualToString:@"男"]) {
        self.man.selected = YES;
    }else {
        self.woman.selected = YES;
    }
    
    [self.woman setImage:[UIImage imageNamed:@"nv_hl"] forState:UIControlStateSelected];
    [self.man setImage:[UIImage imageNamed:@"nan_hl"] forState:UIControlStateSelected];
}

#pragma mark-加载商铺信息
-(void)loadData {
    AFHTTPSessionManager *httpSession = [AFHTTPSessionManager manager];
    httpSession.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    
    parameter[@"merchant_userid"] = [NSString stringWithFormat:@"%d",self.appDelegate.user_id];
    
    [httpSession POST:shopInfoURL parameters:parameter success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        if ([dic[@"code"] intValue] == 0) {
            NSLog(@"%@",dic);
            NSString *sex;
            if ([dic[@"info"][@"merchant_sex"] isEqualToString:@"男"]) {
                sex = @"先生";
            }else {
                sex = @"女士";
            }
            masterSex = sex;
            self.name.text =dic[@"info"][@"merchant_master"];
            self.telephone.text = dic[@"info"][@"merchant_mobile"];
            self.shopName.text = dic[@"info"][@"merchant_shopname"];
            self.appDelegate.shop_id = dic[@"info"][@"merchant_id"];
            
        }else if ([dic[@"code"] intValue] == 1){
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"还未填写商户信息" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"填写", nil];
            [alertView setTag:301];
            [alertView show];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"链接服务器失败" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
        self.appDelegate.orderResultArray = @[@"未查询到结果"];
    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 301) {
        if (buttonIndex == 1) {
            isNew = YES;
            self.coverView.hidden = YES;
            self.modifyBtn.selected = YES;
        }
    }
}

- (IBAction)womanClick:(id)sender {
    if (self.woman.selected == NO) {
        self.woman.selected = YES;
        self.man.selected = NO;
    }else if (self.woman.selected == YES) {
        self.woman.selected = NO;
    }
}

- (IBAction)manClick:(id)sender {
    if (self.man.selected == NO) {
        self.man.selected = YES;
        self.woman.selected = NO;
    }else if (self.man.selected == YES) {
        self.man.selected = NO;
    }
}

- (IBAction)modifyClick:(id)sender {
    self.coverView.hidden = YES;
    [self.modifyBtn setTitle:@"完成" forState:UIControlStateSelected];
    if (self.modifyBtn.selected == YES) {
        self.modifyBtn.selected = NO;
        if (isNew == YES) {
            [self newInfoWithURL:newShopInfoURL];
        }else {
            [self modifyDataWithURL:modifyShopInfoURL];
        }
    }else {
        self.modifyBtn.selected = YES;
    }
}

#pragma mark-修改数据
-(void)modifyDataWithURL:(NSString *)url {
    AFHTTPSessionManager *httpSession = [AFHTTPSessionManager manager];
    httpSession.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    
    parameter[@"shop_id"] = self.appDelegate.shop_id;
    parameter[@"shopName"] = self.shopName.text;
    parameter[@"telephone"] = self.telephone.text;
    parameter[@"name"] = self.name.text;
    if (self.man.selected == YES) {
        parameter[@"sex"] = @"男";
    }else {
        parameter[@"sex"] = @"女";
    }
    
    [httpSession POST:url parameters:parameter  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        if ([dic[@"code"] intValue] == 0) {
            
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

-(void)newInfoWithURL:(NSString *)url {
    AFHTTPSessionManager *httpSession = [AFHTTPSessionManager manager];
    httpSession.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    
    parameter[@"userid"] = [NSString stringWithFormat:@"%d",self.appDelegate.user_id];
    parameter[@"shop_id"] = self.appDelegate.shop_id;
    parameter[@"shopName"] = self.shopName.text;
    parameter[@"telephone"] = self.telephone.text;
    parameter[@"name"] = self.name.text;
    if (self.man.selected == YES) {
        parameter[@"sex"] = @"男";
    }else {
        parameter[@"sex"] = @"女";
    }
    
    [httpSession POST:url parameters:parameter  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        if ([dic[@"code"] intValue] == 0) {
            
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


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
