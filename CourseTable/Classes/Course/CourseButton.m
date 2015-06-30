//
//  CourseButton.m
//  Calendar
//
//  Created by emma on 15/5/7.
//  Copyright (c) 2015年 Emma. All rights reserved.
//

#import "CourseButton.h"
#import <QuartzCore/QuartzCore.h>

@implementation CourseButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self _initSetting];
    }
    return self;
}

- (void)_initSetting
{
    self.layer.cornerRadius = 5.0f;
    self.layer.masksToBounds = YES;
    self.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
    self.titleLabel.numberOfLines = 0;
    
}

- (void)setWeekCourse:(WeekCourse *)weekCourse
{
    if (_weekCourse != weekCourse) {
        _weekCourse = weekCourse;
    }
    
    NSString *courseName = self.weekCourse.courseName;
    NSString *claRoom = self.weekCourse.classRoom;
    [self setTitle:[NSString stringWithFormat:@"%@ @%@",courseName,claRoom] forState:UIControlStateNormal];
}

@end
