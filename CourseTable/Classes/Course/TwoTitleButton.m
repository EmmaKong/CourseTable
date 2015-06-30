//
//  TwoTitleButton.m
//  Calendar
//
//  Created by emma on 15/5/7.
//  Copyright (c) 2015年 Emma. All rights reserved.
//

// 周 标头， 两层button
#import "TwoTitleButton.h"
#import <QuartzCore/QuartzCore.h>
#import "Public.h"

@implementation TwoTitleButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self _initViews];
    }
    return self;
}

- (void)_initViews
{
    self.layer.borderColor = WEEKDAY_SELECT_COLOR.CGColor;
    self.layer.borderWidth = 0.3f;
    self.layer.masksToBounds = YES;
    self.backgroundColor = [UIColor clearColor];
    
    _rectTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _rectTitleLabel.textAlignment = NSTextAlignmentCenter;
    _rectTitleLabel.font = [UIFont systemFontOfSize:10.0f];
    _rectTitleLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:_rectTitleLabel];
    
    _subTitileLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _subTitileLabel.textAlignment = NSTextAlignmentCenter;
    _subTitileLabel.font = [UIFont systemFontOfSize:10.0f];
    _subTitileLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:_subTitileLabel];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _rectTitleLabel.frame = CGRectMake(0, 3, self.bounds.size.width,self.bounds.size.height/2);
    _rectTitleLabel.text = self.title;
    _rectTitleLabel.textColor = _textColor;
    
    _subTitileLabel.frame = CGRectMake(0, self.bounds.size.height/2, self.bounds.size.width, self.bounds.size.height/2);
    _subTitileLabel.text = self.subtitle;
    _subTitileLabel.textColor = _textColor;
    
}


@end
