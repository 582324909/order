//
//  EmployeeTableViewCell.h
//  注册+个人中心
//
//  Created by 张伟伟 on 16/8/11.
//  Copyright © 2016年 张伟伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EmployeeTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *telephone;
@property (weak, nonatomic) IBOutlet UILabel *price;

+(instancetype)employeeCellWithTableView:(UITableView *)tableview;

@end
