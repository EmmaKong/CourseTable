//
//  CourseDetailViewController.h
//  CourseDetail
//
//  Created by emma on 15/5/22.
//  Copyright (c) 2015年 Emma. All rights reserved.
//

#import "CourseDetailTableViewController.h"
#import "WeekCourse.h"

///**
// 定义协议，用来实现传值代理
// */
//@protocol NewCourseDetailVCDelegate <NSObject>
//
///**
// 方法为必须实现的协议方法，用来传值
// */
//- (void)addnewcourse:(WeekCourse *)weekcourse;  // 第二种方式添加课程，在课程详情页进行添加
//
//@end
//

@interface NewCourseDetailVC : CourseDetailTableViewController<UIAlertViewDelegate>


@property (nonatomic,retain) WeekCourse *weekcourse;

//@property (nonatomic, unsafe_unretained) id<NewCourseDetailVCDelegate> delegate;
//
@end
