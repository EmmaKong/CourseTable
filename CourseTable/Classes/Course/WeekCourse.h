//
//  WeekCourse.h
//  Calendar
//
//  Created by emma on 15/5/7.
//  Copyright (c) 2015年 Emma. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeekCourse : NSObject
{
    NSString        *_studentId;        //学号
    NSString        *_term;             //年度+学期 如2014-20151是2014-2015年底第一学期
    NSString        *_weeks;            //周期，如果为空默认为第一周，否则为参数那一周
    NSString        *_day;              //周几,1/2/3/4/5/6/7,代表周一、周二、周三.........
    NSString        *_lesson;           //课程从第几节开始
    NSString        *_lessonsNum;       //课程有几节课
    NSString        *_courseCode;       //课程号
    NSString        *_courseName;       //课程名
    NSString        *_classRoom;        //教室
    NSString        *_teacherName;      //老师名字
    NSString        *_seWeek;           //周期，比如3-14周，则数据为3-14
    NSString        *_capter;           //只用于cell显示，不存在数据库, 节数
    BOOL            _haveLesson;        //显示cell用， 该课程是否是已添加课程
    NSString        *_coursetag;     // 每个课程有一个coursetag
}

@property (nonatomic, copy) NSString    *studentId;
@property (nonatomic, copy) NSString    *term;
@property (nonatomic, copy) NSString    *weeks;
@property (nonatomic, copy) NSString    *day;
@property (nonatomic, copy) NSString    *lesson;
@property (nonatomic, copy) NSString    *lessonsNum;
@property (nonatomic, copy) NSString    *courseCode;
@property (nonatomic, copy) NSString    *courseName;
@property (nonatomic, copy) NSString    *classRoom;
@property (nonatomic, copy) NSString    *teacherName;
@property (nonatomic, copy) NSString    *seWeek;
@property (nonatomic, copy) NSString    *capter;
@property (nonatomic, assign) BOOL      haveLesson;
@property (nonatomic, copy) NSString    *coursetag;

- (id)initWithPropertiesDictionary:(NSDictionary *)dic;

@end
