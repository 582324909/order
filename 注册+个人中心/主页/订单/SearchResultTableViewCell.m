//
//  SearchResultTableViewCell.m
//  注册+个人中心
//
//  Created by 张伟伟 on 16/8/4.
//  Copyright © 2016年 张伟伟. All rights reserved.
//

#import "SearchResultTableViewCell.h"

@implementation SearchResultTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

+(instancetype)searchResultcellWithTableView:(UITableView *)tableView {
    static NSString *celldntify = @"searchResult";
    SearchResultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:celldntify];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SearchResultTableViewCell" owner:nil options:nil]lastObject];
    }
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
