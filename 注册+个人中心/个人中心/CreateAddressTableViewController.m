//
//  CreateAddressTableViewController.m
//  注册+个人中心
//
//  Created by 张伟伟 on 16/8/8.
//  Copyright © 2016年 张伟伟. All rights reserved.
//

#import "CreateAddressTableViewController.h"
#import "AppDelegate.h"
#import "URLHead.h"

#import "AFNetworking.h"

@interface CreateAddressTableViewController ()

@property (nonatomic,strong) AppDelegate *appDelegate;

@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *telephone;
@property (weak, nonatomic) IBOutlet UITextField *shopName;
@property (weak, nonatomic) IBOutlet UITextField *address;
@property (weak, nonatomic) IBOutlet UIButton *woman;
@property (weak, nonatomic) IBOutlet UIButton *man;

@end

@implementation CreateAddressTableViewController

- (void)viewDidLoad {
    
    self.appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    [self.woman setImage:[UIImage imageNamed:@"nv_hl"] forState:UIControlStateSelected];
    [self.man setImage:[UIImage imageNamed:@"nan_hl"] forState:UIControlStateSelected];
    
    [super viewDidLoad];
}

#pragma mark-选择性别
- (IBAction)chooseManClick:(id)sender {
    if (self.man.selected == NO) {
        self.man.selected = YES;
        self.woman.selected = NO;
    }else if (self.man.selected == YES) {
        self.man.selected = NO;
    }
}

- (IBAction)chooseWomanClick:(id)sender {
    if (self.woman.selected == NO) {
        self.woman.selected = YES;
        self.man.selected = NO;
    }else if (self.woman.selected == YES) {
        self.woman.selected = NO;
    }
}

#pragma mark-确定修改
- (IBAction)doneClick:(id)sender {
    if (self.shopName.text.length > 0 & self.address.text.length > 0 & self.name.text.length > 0 & self.telephone.text.length > 0) {
        [self saveShopInfo];
    }else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"修改信息有误" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
    }
}

#pragma mark-修改数据
-(void)saveShopInfo {
    AFHTTPSessionManager *httpSession = [AFHTTPSessionManager manager];
    httpSession.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    
    parameter[@"merchant_id"] = [NSString stringWithFormat:@"%d",self.appDelegate.user_id];
    parameter[@"shopName"] = self.shopName.text;
    parameter[@"address"] = self.address.text;
    parameter[@"telephone"] = self.telephone.text;
    parameter[@"name"] = self.name.text;
    if (self.man.selected == YES) {
        parameter[@"sex"] = @"男";
    }else {
        parameter[@"sex"] = @"女";
    }
    [httpSession POST:addAddressInfoURL parameters:parameter success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
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
//    [httpSession POST:addAddressInfoURL parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
//        if ([dic[@"code"] intValue] == 0) {
//            
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
