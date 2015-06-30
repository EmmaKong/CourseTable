//
//  DateUtils.m
//  Calendar
//
//  Created by emma on 15/5/7.
//  Copyright (c) 2015年 Emma. All rights reserved.
//

#import "DateUtils.h"

@implementation DateUtils

//获取本周的日期数组
+ (NSArray *)getDatesOfCurrence
{
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setFirstWeekday:2]; //1代表周日，2代表周一
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday fromDate:now];
    NSInteger weekDay = [components weekday];
    // 得到几号
    NSInteger day = [components day];
    
    // 计算当前日期和这周的星期一和星期天差的天数
    long firstDiff;
    if (weekDay == 1) {
        firstDiff = 1-7;
    }else{
        firstDiff = [calendar firstWeekday] - weekDay;
    }
    
    // 在当前日期(去掉了时分秒)基础上加上差的天数
    NSDateComponents *firstDayComp = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:now];
    [firstDayComp setDay:day + firstDiff];
    
    NSString *month = [NSString stringWithFormat:@"%d月",[firstDayComp month]];
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:8];
    [array addObject:month];
    for (int i = 0; i< 7; i++) {
        [components setDay:[firstDayComp day] + i];
        NSDate *everyDate = [calendar dateFromComponents:components];
        components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday fromDate:everyDate];
        [array addObject:[NSString stringWithFormat:@"%d",[components day]]];
    }
    
    return array;
}

//获取距离当前多少周的日期数组
+ (NSArray *)getDatesSinceCurence:(int)weeks
{
    NSDate *now = [NSDate dateWithTimeIntervalSinceNow:weeks*7*24*60*60];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setFirstWeekday:2]; //1代表周日，2代表周一
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday fromDate:now];
    NSInteger weekDay = [components weekday];
    // 得到几号
    NSInteger day = [components day];
    
    // 计算当前日期和这周的星期一和星期天差的天数
    long firstDiff,lastDiff;
    if (weekDay == 1) {
        firstDiff = 1;
        lastDiff = 7;
    }else{
        firstDiff = [calendar firstWeekday] - weekDay;
        lastDiff = 8 - weekDay;
    }
    
    // 在当前日期(去掉了时分秒)基础上加上差的天数
    NSDateComponents *firstDayComp = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:now];
    [firstDayComp setDay:day + firstDiff];
    
    NSString *month = [NSString stringWithFormat:@"%d月",[firstDayComp month]];
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:8];
    [array addObject:month];
    for (int i = 0; i< 7; i++) {
        [components setDay:[firstDayComp day] + i];
        NSDate *everyDate = [calendar dateFromComponents:components];
        NSDateComponents *everCom = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday fromDate:everyDate];
        [array addObject:[NSString stringWithFormat:@"%d",[everCom day]]];
    }
    
    return array;
}


@end
