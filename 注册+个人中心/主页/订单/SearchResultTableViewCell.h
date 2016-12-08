//
//  SearchResultTableViewCell.h
//  注册+个人中心
//
//  Created by 张伟伟 on 16/8/4.
//  Copyright © 2016年 张伟伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchResultTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *sex;
@property (weak, nonatomic) IBOutlet UILabel *salary;

@property (assign, nonatomic) int status;

+(instancetype)searchResultcellWithTableView:(UITableView *)tableView;

@end
