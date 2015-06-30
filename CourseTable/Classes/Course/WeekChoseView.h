//
//  WeekChooseView.h
//  Calendar
//
//  Created by emma on 15/5/7.
//  Copyright (c) 2015年 Emma. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WeekChoseViewDelegate <NSObject>
@required
- (void)tapAction:(int)tag;
- (void)setCurrentWeek:(NSString *)number;

@end


@interface WeekChoseView : UIView
{
    UILabel         *numLabel;   //数字
    UIButton        *setButton;  //设置为本周的按钮
    UITapGestureRecognizer  *tapGesture;  //点击手势
}

@property (nonatomic,copy)  NSString    *number;  //显示的数字

@property (nonatomic, assign) id<WeekChoseViewDelegate> delegate;
@property (nonatomic, assign) BOOL      isCurrentWeek; //为当前周
@property (nonatomic, assign) BOOL      isChosen;  //被选中

//重置控件，取消选中时调用
- (void)reset;

@end
