//
//  CourseInfoCell.m
//  CourseDetail
//
//  Created by emma on 15/5/22.
//  Copyright (c) 2015年 Emma. All rights reserved.
//

#import "CourseInfoCell.h"
#import "StringCleaner.h"

@implementation CourseInfoCell{
    WeekCourse *_weekCourse;
}


- (instancetype)init:(WeekCourse *)weekCourse{
    self = [super init];
    
    if (!self) {
        return nil;
    }
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _weekCourse = weekCourse;
    
    [self generateInfoCell];
    
    return self;
}

- (void)generateInfoCell{

    CGFloat padding = 20;
    
    UILabel *coursetitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(padding, padding/2, 50, 20)];
    coursetitleLabel.text = @"课程";
    coursetitleLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:coursetitleLabel];
    
    UILabel *courseLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, padding/2, 150, 20)];
    NSString *courseName = _weekCourse.courseName;
    courseLabel.text = courseName;
    courseLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:courseLabel];
    
    UILabel *teachertitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(padding, CGRectGetMaxY(courseLabel.frame) + 6, 50, 20)];
    teachertitleLabel.text = @"教师";
    teachertitleLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:teachertitleLabel];

    UILabel *teacherLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, CGRectGetMaxY(courseLabel.frame) + 6, 150, 20)];
    NSString *teacherName = _weekCourse.teacherName;
    teacherLabel.text = teacherName;
    teacherLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:teacherLabel];
    
    
    UILabel *classtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(padding, CGRectGetMaxY(teacherLabel.frame) + 6, 50, 20)];
    classtitleLabel.text = @"教室";
    classtitleLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:classtitleLabel];

    UILabel *classLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, CGRectGetMaxY(teacherLabel.frame) + 6, 150, 20)];
    NSString *classRoom = _weekCourse.classRoom;
    classLabel.text = classRoom;
    classLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:classLabel];
    
    UILabel *lessonsNumtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(padding, CGRectGetMaxY(classLabel.frame) + 6, 50, 20)];
    lessonsNumtitleLabel.text = @"节数";
    lessonsNumtitleLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:lessonsNumtitleLabel];

    UILabel *lessonsNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, CGRectGetMaxY(classLabel.frame) + 6, 150, 20)];
    
    NSString *weekday;
    if ([@"1" isEqualToString:_weekCourse.day]) {
        weekday = @"周一";
    }else if ([@"2" isEqualToString:_weekCourse.day]){
        weekday = @"周二";
    }else if ([@"3" isEqualToString:_weekCourse.day]){
        weekday = @"周三";
    }else if ([@"4" isEqualToString:_weekCourse.day]){
        weekday = @"周四";
    }else if ([@"5" isEqualToString:_weekCourse.day]){
        weekday = @"周五";
    }else if ([@"6" isEqualToString:_weekCourse.day]){
        weekday = @"周六";
    }else if([@"7" isEqualToString:_weekCourse.day]){
        weekday = @"周日";
    }else {
        weekday = _weekCourse.day;
    }
    
    lessonsNumLabel.text = [NSString stringWithFormat:@"%@  %@－%d节",weekday,_weekCourse.lesson,_weekCourse.lesson.intValue +_weekCourse.lessonsNum.intValue-1];
    lessonsNumLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:lessonsNumLabel];
    
    UILabel *seWeektitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(padding, CGRectGetMaxY(lessonsNumLabel.frame) + 6, 50, 20)];
    seWeektitleLabel.text = @"周数";
    seWeektitleLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:seWeektitleLabel];
    
    UILabel *seWeekLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, CGRectGetMaxY(lessonsNumLabel.frame) + 6, 150, 20)];
    NSString *seWeek = _weekCourse.seWeek;
    seWeekLabel.text = seWeek;
    seWeekLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:seWeekLabel];
    
    self.height = CGRectGetMaxY(seWeekLabel.frame) + padding/2;
    
    
    
    
}



@end
