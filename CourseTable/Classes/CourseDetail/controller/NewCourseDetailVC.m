//
//  CourseDetailViewController.m
//  CourseDetail
//
//  Created by emma on 15/5/22.
//  Copyright (c) 2015年 Emma. All rights reserved.
//

#import "NewCourseDetailVC.h"
#import "CourseInfoCell.h"
#import "CoursePeerCell.h"
#import "ClassPeerViewController.h"

@interface NewCourseDetailVC ()

@end

@implementation NewCourseDetailVC


- (instancetype)init
{
    self = [super initWithStyle:UITableViewStyleGrouped];  // grouped tableview
    if(!self){
        return nil;
    }
    
    return self;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"%@",self.weekcourse.coursetag);

    CGFloat padding = 20;
    
    CourseInfoCell *infoCell = [[CourseInfoCell alloc] init: self.weekcourse];
    // 编辑 按钮
    UIButton *editBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    editBtn.frame = CGRectMake(infoCell.frame.size.width - padding - 50, (infoCell.frame.size.height - 20)/2, 50 , 20);
    editBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    editBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [editBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [editBtn addTarget:self action:@selector(clickeditBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [infoCell.contentView addSubview:editBtn];
    
    CourseDetailSection *detailSection = [CourseDetailSection sectionWithHeaderTitle:nil cells:@[infoCell]];


    CoursePeerCell *peerCell = [[CoursePeerCell alloc] init];
     //同伴查看按钮
    UIButton *peerBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    peerBtn.frame = CGRectMake(peerCell.frame.size.width - padding - 50, padding, 50 , 20);
    
    peerBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    peerBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [peerBtn setTitle:@"查看" forState:UIControlStateNormal];
    [peerBtn addTarget:self action:@selector(clickPeerBtn:) forControlEvents:UIControlEventTouchUpInside];
    [peerCell.contentView addSubview:peerBtn];
    
    CourseDetailSection *peerSection = [CourseDetailSection sectionWithHeaderTitle:nil cells:@[peerCell]];
    
    
    CourseDetailCell *addCell = [CourseDetailCell cellWithStyle:UITableViewCellStyleDefault height:44 actionBlock:^{
        
        // 添加课程
        [[NSNotificationCenter defaultCenter]postNotificationName:@"addcourseNotification" object:self.weekcourse];
    }];
   
    addCell.textLabel.text = @"加入本节课";
   // addCell.textLabel.textColor = [UIColor redColor];
    addCell.textLabel.textAlignment = NSTextAlignmentCenter;
    CourseDetailSection  *addSection = [CourseDetailSection  sectionWithHeaderTitle:nil cells:@[addCell]];
    
    self.sections = @[detailSection, peerSection, addSection];
    

}


-(void)clickeditBtn:(id)sender{
    NSLog(@"编辑课程");
    
}
    

-(void)clickPeerBtn:(id)sender{
    
    ClassPeerViewController* classpeerVC = [[ClassPeerViewController alloc]init];
    [self.navigationController pushViewController:classpeerVC animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
