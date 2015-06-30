//
//  CourseCell.h
//  Calendar
//
//  Created by emma on 15/5/26.
//  Copyright (c) 2015年 Emma. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CourseCellDelegate <NSObject>


@end


@interface CourseCell : UITableViewCell<UIAlertViewDelegate>

@property (retain, nonatomic) IBOutlet UILabel *titleLabel;
@property (retain, nonatomic) IBOutlet UILabel *teacherLabel;
@property (retain, nonatomic) IBOutlet UILabel *classroomLabel;
@property (retain, nonatomic) IBOutlet UILabel *seweekLabel;
@property (retain, nonatomic) IBOutlet UILabel *dayLabel;  //周几
@property (retain, nonatomic) IBOutlet UILabel *lessonsnumLabel;  // 第几节

@property (retain, nonatomic) IBOutlet UIButton *addCourseBtn;

@property (assign, nonatomic) id<CourseCellDelegate> delegate;

@end
