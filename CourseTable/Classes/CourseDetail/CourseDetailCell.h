//
//  CourseDetailCell.h
//  CourseDetail
//
//  Created by emma on 15/5/22.
//  Copyright (c) 2015年 Emma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CourseDetailCell : UITableViewCell

@property (nonatomic) CGFloat height;
@property (nonatomic, copy) dispatch_block_t actionBlock;

+ (instancetype)cellWithStyle:(UITableViewCellStyle)style height:(CGFloat)height actionBlock:(dispatch_block_t)actionBlock;


@end
