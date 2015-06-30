//
//  AddCourseViewController.h
//  Calendar
//
//  Created by emma on 15/5/22.
//  Copyright (c) 2015年 Emma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "WeekCourse.h"
#import "CourseCell.h"
#import "NewCourseDetailVC.h"


@interface AddCourseViewController : UIViewController<CourseCellDelegate, UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,MBProgressHUDDelegate,UISearchBarDelegate>
{
    
    MBProgressHUD   *_HUD;
    NSMutableArray *searchResults;
    UISearchBar *courseSearchBar;
    UISearchDisplayController *searchDisplayController;
    
}

@property (nonatomic, retain) NSMutableArray   *coursesArray;


@property (weak, nonatomic) IBOutlet UITableView *tableView;



@end
