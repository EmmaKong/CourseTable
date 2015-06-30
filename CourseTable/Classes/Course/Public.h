//
//  Public.h
//  CourseTable
//
//  Created by emma on 15/6/29.
//  Copyright (c) 2015年 Emma. All rights reserved.
//

#ifndef CourseTable_Public_h
#define CourseTable_Public_h

// 课程表中
#define WEEKDAY_BGCOLOR  ([UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.5])
#define WEEKDAY_SELECT_COLOR ([UIColor colorWithRed:32/255.0 green:81/255.0 blue:148/255.0 alpha:0.23])
#define WEEKDAY_FONT_COLOR ([UIColor colorWithRed:32/255.0 green:81/255.0 blue:148/255.0 alpha:1])
#define kWidthGrid  (ScreenWidth/7.5)   //周课表中一个格子的宽度

//NSUserDefaults 中的Key常量
#define CURRENTYEAR   @"CURRENTYEAR"
#define CURRENTTERM   @"CURRENTTERM"
#define USERNAME      @"USERNAME"
#define CURRENTWEEK   @"CURRENTWEEK"

#define CURRENTTIME   @"CURRENTTIME"
#define ScreenHeight ([UIScreen mainScreen].bounds.size.height)
#define ScreenWidth ([UIScreen mainScreen].bounds.size.width)
#define kWidthGrid  (ScreenWidth/7.5)   //周课表中一个格子的宽度

#endif
