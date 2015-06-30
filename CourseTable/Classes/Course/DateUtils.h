//
//  DateUtils.h
//  Calendar
//
//  Created by emma on 15/5/7.
//  Copyright (c) 2015年 Emma. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateUtils : NSObject

//获取本周的日期数组
+ (NSArray *)getDatesOfCurrence;

//获取距本周多少个周的日期数组,参数为1就代表下周，参数为2就是下下周，参数为-1就是上周
+ (NSArray *)getDatesSinceCurence:(int)weeks;



@end
