//
//  AttendanceTableViewCell.h
//  AttendanceCentre
//
//  Created by admin on 16/3/14.
//  Copyright © 2016年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AttendanceTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *processLabel;

+(instancetype)timeCellWithTableView:(UITableView *)tableview;

@end
