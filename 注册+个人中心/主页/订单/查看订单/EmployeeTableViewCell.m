//
//  EmployeeTableViewCell.m
//  注册+个人中心
//
//  Created by 张伟伟 on 16/8/11.
//  Copyright © 2016年 张伟伟. All rights reserved.
//

#import "EmployeeTableViewCell.h"

@implementation EmployeeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

+(instancetype)employeeCellWithTableView:(UITableView *)tableview {
    static NSString *celldntify = @"employeeCell";
    EmployeeTableViewCell *cell = [tableview dequeueReusableCellWithIdentifier:celldntify];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"EmployeeTableViewCell" owner:nil options:nil]lastObject];
    }
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
