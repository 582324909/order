//
//  ZWWDate.h
//  判断时间
//
//  Created by 张伟伟 on 16/6/21.
//  Copyright © 2016年 张伟伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZWWDate : NSObject

//返回自定义日期
-(NSString *)typeOfDay:(NSString *)dateFormat and:(NSString *)dateString;
/*
 dateFormat :类似于@"yyyy-MM-dd",
                  @"YYYY-MM-dd HH:mm:ss"
                  @"YYYY/MM/dd HH:mm"
             可自行定义
 dateString :是dateFormat类型的日期string ，如：@"2016-06-12"
 */

//返回周几
- (NSString *)getWeekDayFordate:(long long)data;

@end
