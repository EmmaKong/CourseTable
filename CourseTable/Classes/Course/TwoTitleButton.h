//
//  TwoTitleButton.h
//  Calendar
//
//  Created by emma on 15/5/7.
//  Copyright (c) 2015年 Emma. All rights reserved.

//  周 title

#import <UIKit/UIKit.h>

@interface TwoTitleButton : UIButton
{
    UILabel *_rectTitleLabel;
    UILabel *_subTitileLabel;
}

@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *subtitle;

@property (nonatomic,retain) UIColor *textColor;

@end
