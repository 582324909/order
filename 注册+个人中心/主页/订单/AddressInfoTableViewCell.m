//
//  AddressInfoTableViewCell.m
//  注册+个人中心
//
//  Created by 张伟伟 on 16/8/8.
//  Copyright © 2016年 张伟伟. All rights reserved.
//

#import "AddressInfoTableViewCell.h"

@implementation AddressInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

+(instancetype)infoCellWithTableView:(UITableView *)tableView {
    static NSString *testCell = @"addressCell";
    AddressInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:testCell];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"AddressInfoTableViewCell" owner:nil options:nil]lastObject];
    }
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
