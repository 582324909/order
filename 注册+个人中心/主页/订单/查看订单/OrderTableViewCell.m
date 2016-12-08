//
//  OrderTableViewCell.m
//  注册+个人中心
//
//  Created by 张伟伟 on 16/8/10.
//  Copyright © 2016年 张伟伟. All rights reserved.
//

#import "OrderTableViewCell.h"

@implementation OrderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
}

+(instancetype)orderTableViewCellWithTableView:(UITableView *)tableView {
    static NSString *celldntify = @"orderCell";
    OrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:celldntify];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"OrderTableViewCell" owner:nil options:nil]lastObject];
    }
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
