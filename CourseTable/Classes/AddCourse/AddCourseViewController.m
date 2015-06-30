//
//  AddCourseViewController.m
//  Calendar
//
//  Created by emma on 15/5/22.
//  Copyright (c) 2015年 Emma. All rights reserved.
//

#import "AddCourseViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "PullingRefreshTableView.h"
#import "ChineseInclude.h"
#import "PinYinForObjc.h"
#import "NewCourseDetailVC.h"
#import "Public.h"
#import "WeekCourse.h"
#import "CourseButton.h"
#import "ViewController.h"

@interface AddCourseViewController ()<PullingRefreshTableViewDelegate>

@property (retain,nonatomic) PullingRefreshTableView *mytableView;

@property (nonatomic) BOOL refreshing;

@end

@implementation AddCourseViewController

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"添加课程";

    //CGRect bounds = self.view.bounds;
    _mytableView = [[PullingRefreshTableView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height-64) pullingDelegate:self];
    self.tableView = _mytableView;
    
    [self showHUD:@"正在加载..." isDim:NO]; // 拉动加载
    //加载本地数据
    [self performSelector:@selector(loadnewCourseDatas) withObject:nil afterDelay:0.5];
    
    courseSearchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, 40)];
    courseSearchBar.delegate = self;
    [courseSearchBar setPlaceholder:@"输入课程名，搜索您想参加的课程"];
    courseSearchBar.keyboardType = UIKeyboardTypeDefault;
    
    searchDisplayController = [[UISearchDisplayController alloc]initWithSearchBar:courseSearchBar contentsController:self];
    searchDisplayController.active = NO;
    searchDisplayController.searchResultsDataSource = self;
    searchDisplayController.searchResultsDelegate = self;
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableHeaderView = courseSearchBar;
    
    [self.view addSubview:self.tableView];
}

- (void)loadnewCourseDatas
{
    // json数据解析
    NSString *newCoursePath = [[NSBundle mainBundle] pathForResource:@"addcourses" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:newCoursePath];
    NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    _coursesArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < array.count; i++) {
        WeekCourse *weekcourse = [[WeekCourse alloc] initWithPropertiesDictionary:array[i]];
        weekcourse.coursetag = [NSString stringWithFormat:@"%d",1100+i];
        [_coursesArray addObject:weekcourse];
    }
    [_mytableView  reloadData];
    [self hideHUD];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadData
{
    [self.mytableView tableViewDidFinishedLoading];
}

#pragma mark - PullingRefreshTableViewDelegate
- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView
{
    self.refreshing = YES;
    [self performSelector:@selector(loadData) withObject:nil afterDelay:1.f];
}

- (NSDate *)pullingTableViewRefreshingFinishedDate{
    NSDateFormatter *df = [[NSDateFormatter alloc] init ];
    df.dateFormat = @"yyyy-MM-dd HH:mm";
    NSDate *date = [df dateFromString:@"2015-05-27 10:10"];
    return date;
}

- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView{
    [self performSelector:@selector(loadData) withObject:nil afterDelay:1.f];
}

#pragma mark - Scroll

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [self.mytableView tableViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self.mytableView tableViewDidEndDragging:scrollView];
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (tableView == self.searchDisplayController.searchResultsTableView)  // 有搜索
    {
        return searchResults.count;
    }
    else {
        return _coursesArray.count;
    }
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CourseCell";
    CourseCell *cell = (CourseCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CourseCell" owner:self options:nil] lastObject];
    }
    
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        // 搜索结果显示
        WeekCourse *weekcourse = searchResults[indexPath.row];
        
        NSString *titletext = [NSString stringWithFormat:@"%@",weekcourse.courseName];
        NSString *teachertext = [NSString stringWithFormat:@"%@",weekcourse.teacherName];
        NSString *classroomtext = [NSString stringWithFormat:@"%@",weekcourse.classRoom];
        NSString *seweektext = [NSString stringWithFormat:@"%@",weekcourse.seWeek];
        NSString *daytext = [NSString stringWithFormat:@"%@",weekcourse.day];
        NSString *lessonsnumtext = [NSString stringWithFormat:@"%@－%d节",weekcourse.lesson,weekcourse.lesson.intValue +weekcourse.lessonsNum.intValue];
        
        cell.tag = indexPath.row;
        cell.delegate = self;
        cell.titleLabel.text = titletext;
        cell.teacherLabel.text = teachertext;
        cell.classroomLabel.text = classroomtext;
        cell.seweekLabel.text = seweektext;
        cell.dayLabel.text = daytext;
        cell.lessonsnumLabel.text = lessonsnumtext;
        cell.addCourseBtn.tag = indexPath.row;
        // cell 上的添加课程button，添加响应事件
        [cell.addCourseBtn addTarget:self action:@selector(searchAddbtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        
    }
    else {
        // 显示全部课程
        WeekCourse *weekcourse = _coursesArray[indexPath.row];
        
        NSString *titletext = [NSString stringWithFormat:@"%@",weekcourse.courseName];
        NSString *teachertext = [NSString stringWithFormat:@"%@",weekcourse.teacherName];
        NSString *classroomtext = [NSString stringWithFormat:@"%@",weekcourse.classRoom];
        NSString *seweektext = [NSString stringWithFormat:@"%@",weekcourse.seWeek];
        NSString *daytext = [NSString stringWithFormat:@"%@",weekcourse.day];
        NSString *lessonsnumtext = [NSString stringWithFormat:@"%@－%d节",weekcourse.lesson,weekcourse.lesson.intValue +weekcourse.lessonsNum.intValue-1];
        
        cell.tag = indexPath.row;
        cell.delegate = self;
        cell.titleLabel.text = titletext;
        cell.teacherLabel.text = teachertext;
        cell.classroomLabel.text = classroomtext;
        cell.seweekLabel.text = seweektext;
        cell.dayLabel.text = daytext;
        cell.lessonsnumLabel.text = lessonsnumtext;
        cell.addCourseBtn.tag = indexPath.row;
        // cell 上的添加课程button，添加响应事件
        [cell.addCourseBtn addTarget:self action:@selector(normalAddbtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    
    return cell;
}

// cell上的 添加课程按钮, 响应事件,  搜索结果中的cell
- (void)searchAddbtnClick:(UIButton *)Btn
{
    
//    NSString *title = [NSString stringWithFormat:@"确定添加该课程？"];
//    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//    [alertView show];
    WeekCourse *newcourse = searchResults[Btn.tag];    
    
    //第一步注册通知
    [[NSNotificationCenter defaultCenter]postNotificationName:@"addcourseNotification" object:newcourse];

}

// 添加课程按钮, 响应事件， table中的cell上的button
- (void)normalAddbtnClick:(UIButton *)Btn
{
    //    NSString *title = [NSString stringWithFormat:@"确定添加该课程？"];
    //    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    //    [alertView show];
    WeekCourse *newcourse = _coursesArray[Btn.tag];
    
    //第一步注册通知
    [[NSNotificationCenter defaultCenter]postNotificationName:@"addcourseNotification" object:newcourse];

}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

// 选中某个课程cell，进入 newcourse 课程详情页面
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NewCourseDetailVC *newdetail = [[NewCourseDetailVC alloc] init];
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        newdetail.weekcourse = searchResults[indexPath.row];
    }
    else {
        newdetail.weekcourse = _coursesArray[indexPath.row];
    }
    
    [self.navigationController pushViewController:newdetail animated:YES];
}

//另一种加在提示框
- (void)showHUD:(NSString *)title isDim:(BOOL)isDim
{
    _HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:_HUD];
    _HUD.delegate = self;
    _HUD.dimBackground = isDim;
    _HUD.labelText = title;
    [_HUD show:YES];
}

//隐藏提示框
- (void)hideHUD
{
    [_HUD hide:YES];
}

// 课程名称搜索，可实现汉字搜索，汉语拼音搜索和拼音首字母搜索，
// 输入课程名称courseName，进行课程搜索， 返回搜索结果searchResults
#pragma UISearchDisplayDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    NSLog(@"开始搜索课程");
    searchResults = [[NSMutableArray alloc]init];
    if (courseSearchBar.text.length>0&&![ChineseInclude isIncludeChineseInString:courseSearchBar.text]) {
        for (int i=0; i<_coursesArray.count; i++) {
            
            WeekCourse *weekcourse = _coursesArray[i];
            if ([ChineseInclude isIncludeChineseInString:weekcourse.courseName]) {
                NSString *tempPinYinStr = [PinYinForObjc chineseConvertToPinYin:weekcourse.courseName];
                NSRange titleResult=[tempPinYinStr rangeOfString:courseSearchBar.text options:NSCaseInsensitiveSearch];
                
                if (titleResult.length>0) {
                    [searchResults addObject:weekcourse];
                }
                else {
                    NSString *tempPinYinHeadStr = [PinYinForObjc chineseConvertToPinYinHead:weekcourse.courseName];
                    NSRange titleHeadResult=[tempPinYinHeadStr rangeOfString:courseSearchBar.text options:NSCaseInsensitiveSearch];
                    if (titleHeadResult.length>0) {
                        [searchResults addObject:weekcourse];
                    }
                }
                NSString *tempPinYinHeadStr = [PinYinForObjc chineseConvertToPinYinHead:weekcourse.courseName];
                NSRange titleHeadResult=[tempPinYinHeadStr rangeOfString:courseSearchBar.text options:NSCaseInsensitiveSearch];
                if (titleHeadResult.length>0) {
                    [searchResults addObject:weekcourse];
                }
            }
            else {
                NSRange titleResult=[weekcourse.courseName rangeOfString:courseSearchBar.text options:NSCaseInsensitiveSearch];
                if (titleResult.length>0) {
                    [searchResults addObject:weekcourse]; // 搜索结果
                }
            }
        }
    } else if (courseSearchBar.text.length>0&&[ChineseInclude isIncludeChineseInString:courseSearchBar.text]) {
        
//        for (NSString *tempStr in _coursesArray) {
//            NSRange titleResult=[tempStr rangeOfString:courseSearchBar.text options:NSCaseInsensitiveSearch];
//            if (titleResult.length>0) {
//                [searchResults addObject:tempStr];
//            }
//        }
         for (int i=0; i<_coursesArray.count; i++) {
             WeekCourse *weekcourse = _coursesArray[i];
             NSString *tempStr = weekcourse.courseName;
             NSRange titleResult = [tempStr rangeOfString:courseSearchBar.text options:NSCaseInsensitiveSearch];
                if (titleResult.length>0) {
                        [searchResults addObject:weekcourse];
                }
         }
    }
}



// searchbar 点击上浮，完毕复原
-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    //准备搜索前，把上面调整的TableView调整回全屏幕的状态
    [UIView animateWithDuration:1.0 animations:^{
        _mytableView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
        
    }];
    return YES;
}
-(BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    //搜索结束后，恢复原状
    [UIView animateWithDuration:1.0 animations:^{
        _mytableView.frame = CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height);
    }];
    return YES;
}




@end
