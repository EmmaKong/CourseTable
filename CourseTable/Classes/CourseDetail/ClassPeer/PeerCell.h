//
//  ClaasPeerCell.h
//  Calendar
//
//  Created by emma on 15/6/2.
//  Copyright (c) 2015年 Emma. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PeerCellDelegate <NSObject>


@end


@interface PeerCell : UITableViewCell

@property (retain, nonatomic) IBOutlet UILabel *nameLabel;
@property (retain, nonatomic) IBOutlet UILabel *somethingLabel;
@property (retain, nonatomic) IBOutlet UIImage *headimage;

@property (assign, nonatomic) id<PeerCellDelegate> delegate;

@end
