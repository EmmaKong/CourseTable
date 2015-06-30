//
//  CoursePeerCell.m
//  CourseDetail
//
//  Created by emma on 15/5/22.
//  Copyright (c) 2015年 Emma. All rights reserved.
//

#import "CoursePeerCell.h"


@implementation CoursePeerCell


- (instancetype)init{
    self = [super init];
    
    if (!self) {
        return nil;
    }
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //_weekCourse = weekCourse;
    
    [self generatePeerCell];
    
    return self;
}

- (void)generatePeerCell{
    
    CGFloat padding = 20;

    UILabel *peertitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(padding, padding, 50, 20)];
    peertitleLabel.text = @"同伴";
    peertitleLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:peertitleLabel];

    UILabel *peerLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, padding, 150, 20)];
    //peerLabel.text = [NSString stringWithFormat:@"%@位课堂同学？",number];
    peerLabel.text = @"200位课堂同学";
    
    peerLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:peerLabel];
    
    self.height = CGRectGetMaxY(peerLabel.frame) + padding;

//    // 同伴查看按钮
//    UIButton *peerBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    //todayBtn.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//    
//    peerBtn.frame = CGRectMake(self.frame.size.width - padding - 50, padding, 50 , 20);
//    
//    peerBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
//    peerBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
//    [peerBtn setTitle:@"查看" forState:UIControlStateNormal];
//    
//    [peerBtn addTarget:self action:@selector(clickPeerBtn:) forControlEvents:UIControlEventTouchUpInside];
//    
//    [self.contentView addSubview:peerBtn];
    
}




@end





