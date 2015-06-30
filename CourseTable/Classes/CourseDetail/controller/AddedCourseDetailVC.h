//
//  AddedCourseDetailVC.h
//  Calendar
//
//  Created by emma on 15/6/3.
//  Copyright (c) 2015年 Emma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CourseDetailTableViewController.h"
#import "WeekCourse.h"

//@protocol AddedCourseDetailVCDelegate <NSObject>
//
///**
// 方法为必须实现的协议方法，用来传值, 删除课程
// */
//- (void)deletecourse:(WeekCourse *)weekcourse;
//
//@end

@interface AddedCourseDetailVC : CourseDetailTableViewController<UIAlertViewDelegate>

@property (nonatomic,retain) WeekCourse *weekcourse;

//@property (nonatomic, unsafe_unretained) id<AddedCourseDetailVCDelegate> delegate;

@end
