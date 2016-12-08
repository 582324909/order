//
//  OrderTableViewCell.h
//  注册+个人中心
//
//  Created by 张伟伟 on 16/8/10.
//  Copyright © 2016年 张伟伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *number;
@property (weak, nonatomic) IBOutlet UILabel *job;
@property (weak, nonatomic) IBOutlet UILabel *count;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *status;
@property (weak, nonatomic) IBOutlet UIButton *btn;

+(instancetype)orderTableViewCellWithTableView:(UITableView *)tableView;

@end
