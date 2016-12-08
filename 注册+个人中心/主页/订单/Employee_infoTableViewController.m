//
//  Employee_infoTableViewController.m
//  注册+个人中心
//
//  Created by 张伟伟 on 16/8/5.
//  Copyright © 2016年 张伟伟. All rights reserved.
//

#import "Employee_infoTableViewController.h"
#import "AppDelegate.h"
#import "SearchResultViewController.h"
#import "URLHead.h"

#import "AFNetworking.h"

static NSIndexPath *temp;

@interface Employee_infoTableViewController ()

@property (nonatomic,strong) AppDelegate *appDelegate;

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *sex;
@property (weak, nonatomic) IBOutlet UILabel *salary;
@property (weak, nonatomic) IBOutlet UILabel *job;
@property (weak, nonatomic) IBOutlet UILabel *telephone;
@property (weak, nonatomic) IBOutlet UILabel *workNum;
@property (weak, nonatomic) IBOutlet UILabel *area;
@property (weak, nonatomic) IBOutlet UIButton *doneBtn;

@end

@implementation Employee_infoTableViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];

    self.appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (self.appDelegate.classVc != 1) {
        self.doneBtn.hidden = YES;
    }
    int index = self.appDelegate.indexOfCell;
//    temp = self.appDelegate.isChoose;
//    self.appDelegate.isChoose = nil;
    
    self.name.text = self.appDelegate.orderResultArray[index][@"employee_name"];
    self.sex.text = self.appDelegate.orderResultArray[index][@"employee_sex"];
    self.salary.text = self.appDelegate.orderResultArray[index][@"employee_minsalary"];
    self.job.text = [NSString stringWithFormat:@"%@ / %@",self.appDelegate.orderResultArray[index][@"employee_industry"],self.appDelegate.orderResultArray[index][@"employee_post"]];
    self.telephone.text = self.appDelegate.orderResultArray[index][@"employee_mobile"];
    self.workNum.text = self.appDelegate.orderResultArray[index][@"employee_userid"];
    self.area.text = [NSString stringWithFormat:@"%@ / %@",self.appDelegate.orderResultArray[index][@"employee_city"],self.appDelegate.orderResultArray[index][@"employee_area"]];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (IBAction)doneClick:(id)sender {
//    self.appDelegate.isChoose = temp;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
