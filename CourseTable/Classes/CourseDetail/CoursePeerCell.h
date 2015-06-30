//
//  CoursePeerCell.h
//  CourseDetail
//
//  Created by emma on 15/5/22.
//  Copyright (c) 2015年 Emma. All rights reserved.
//

#import "CourseDetailCell.h"

// 添加消息机制
@protocol CoursePeerCellDelegate <NSObject>


@end


@interface CoursePeerCell : CourseDetailCell

@property (assign, nonatomic) id<CoursePeerCellDelegate> delegate;

@end
