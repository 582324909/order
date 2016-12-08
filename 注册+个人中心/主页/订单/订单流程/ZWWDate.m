//
//  ZWWDate.m
//  判断时间
//
//  Created by 张伟伟 on 16/6/21.
//  Copyright © 2016年 张伟伟. All rights reserved.
//

#import "ZWWDate.h"

static NSInteger number;

@implementation ZWWDate

-(NSString *)typeOfDay:(NSString *)dateFormat and:(NSString *)dateString {
    
    number = [self numberOfDay];
    
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [gregorian setFirstWeekday:2];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:dateFormat];
    NSDate *fromDate;
    NSDate *toDate;
    [gregorian rangeOfUnit:NSCalendarUnitDay startDate:&fromDate interval:NULL forDate:[dateFormatter dateFromString:dateString]];
    [gregorian rangeOfUnit:NSCalendarUnitDay startDate:&toDate interval:NULL forDate:[NSDate date]];
    NSDateComponents *dayComponents = [gregorian components:NSCalendarUnitDay fromDate:fromDate toDate:toDate options:0];
    
    NSArray *weekArray = @[@"周一", @"周二", @"周三", @"周四", @"周五", @"周六",@"周日"];
    
    if (dayComponents.day == 0) {
        return dateString;
    }
    
    if (dayComponents.day < number + 1) {
        if (dayComponents.day == 1) {
            return @"昨天";
        }else if (dayComponents.day == 2) {
            return @"前天";
        } else if (dayComponents.day > 2 && dayComponents.day <= number) {
            return weekArray[number - dayComponents.day];
        }
    }else if (dayComponents.day >= number + 1 && dayComponents.day <= number + 7) {
        NSString *str = [NSString stringWithFormat:@"上%@",weekArray[7 - (dayComponents.day - number)]];
        return str;
    }else if (dayComponents.day > number + 7) {
        return dateString;
    }
    return dateString;
}

-(NSString *)date {
    NSDate * date=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"HH:mm"];
    NSString *  dateStr=[dateformatter stringFromDate:date];
    NSString *dateNow = [NSString stringWithFormat:@"今天 %@",dateStr];
    return dateNow;
}

//返回日期在数组中的位置
-(int)numberOfDay {
    
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    
    NSTimeInterval a =[dat timeIntervalSince1970];
    
    NSString *day = [self getWeekDayFordate:a];
    
    NSArray *weekArray = @[@"周一", @"周二", @"周三", @"周四", @"周五", @"周六",@"周日"];
    
    if ([day isEqualToString:weekArray[0]]) {
        return 0;
    }else if ([day isEqualToString:weekArray[1]]){
        return 1;
    }else if ([day isEqualToString:weekArray[2]]){
        return 2;
    }else if ([day isEqualToString:weekArray[3]]){
        return 3;
    }else if ([day isEqualToString:weekArray[4]]){
        return 4;
    }else if ([day isEqualToString:weekArray[5]]){
        return 5;
    }else if ([day isEqualToString:weekArray[6]]){
        return 6;
    }
    return 0;
}

//返回周几
- (NSString *)getWeekDayFordate:(long long)data {
    
    NSArray *weekday = [NSArray arrayWithObjects: [NSNull null], @"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六", nil];
    
    NSDate *newDate = [NSDate dateWithTimeIntervalSince1970:data];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [calendar components:NSCalendarUnitWeekday fromDate:newDate];
    
    NSString *weekStr = [weekday objectAtIndex:components.weekday];
    return weekStr;
}

@end
