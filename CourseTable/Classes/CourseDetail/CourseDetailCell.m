//
//  CourseDetailCell.m
//  CourseDetail
//
//  Created by emma on 15/5/22.
//  Copyright (c) 2015年 Emma. All rights reserved.
//

#import "CourseDetailCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation CourseDetailCell

+ (instancetype)cellWithStyle:(UITableViewCellStyle)style height:(CGFloat)height actionBlock:(dispatch_block_t)actionBlock {
    CourseDetailCell *cell = [[[self class] alloc] initWithStyle:style reuseIdentifier:nil];
    cell.height = height;
    cell.actionBlock = actionBlock ?: ^{};
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (!self) {
        return nil;
    }
    
    self.height = UITableViewAutomaticDimension;
    self.actionBlock = ^{};
    
    return self;
}



@end
