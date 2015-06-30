//
//  ViewController.m
//  CourseTable
//
//  Created by emma on 15/6/29.
//  Copyright (c) 2015年 Emma. All rights reserved.
//

#import "ViewController.h"
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "DateUtils.h"
#import "WeekCourse.h"
#import "CourseButton.h"
#import "TwoTitleButton.h"
#import "WeekChoseView.h"
#import "AddCourseViewController.h"

@interface ViewController ()<WeekChoseViewDelegate>

@end

@implementation ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad {
    // Do any additional setup after loading the view.
    // self.title = @"课程视图";
    [super viewDidLoad];
    
    //加载一些基本数据
    [self loadBaseData];
    //初始化导航栏
    [self _initNavigationBar];
    
     //初始化周的视图
    [self _initWeekView];
     //初始化隐藏的周选择视图
    [self _initWeekChoseView];
     // 加载网络数据
    [self loadNetDataWithWeek:[NSString stringWithFormat:@"%d",clickTag-250+1]];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//加载一些不需要从服务器请求的数据
- (void)loadBaseData
{
    // 课程 button 颜色， 初始化
    _colors = [[NSArray alloc] initWithObjects:@"9,155,43",@"251,136,71",@"163,77,140",@"32,81,148",@"255,170,0",@"4,155,151",@"38,101,252",@"234,51,36",@"107,177,39",@"245,51,119", nil];
    
    //如果数据当前周为空，则默认为第一周
    // NSUserDefaults类存储 当前周
    NSUserDefaults  *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString  *currentWeek = [userDefaults objectForKey:@"currentWeek"];
    if (currentWeek == nil) {
        [userDefaults setObject:@"1" forKey:@"currentWeek"];
        [userDefaults synchronize];
    }
    
    // 先加载本周的月份以及日期
    horTitles = [DateUtils getDatesOfCurrence];
    
    //赋值计算今天的日期
    NSDate *today = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    todayComp = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:today];
}



//请求网络数据
- (void)loadNetDataWithWeek:(NSString *)week
{
    [self showHUD:@"加载课程..." isDim:NO];
    //加载网络数据，这里用本地数据代替
    //    [self performSelectorInBackground:@selector(ABCAction) withObject:nil];
    
    [self performSelector:@selector(loadLoacalData:) withObject:week afterDelay:1.5];
}

//加载本地的模拟数据
- (void)loadLoacalData:(NSString *)week
{
    
    static BOOL flag = YES;
    NSString *coursePath;
    if (flag) {
        coursePath = [[NSBundle mainBundle] pathForResource:@"courses" ofType:@"json"];
        NSLog(@"%@",coursePath);
        flag = NO;
    }else {
        coursePath = [[NSBundle mainBundle] pathForResource:@"courses-1" ofType:@"json"];
        NSLog(@"%@",coursePath);
        flag = YES;
    }
    NSData *data = [[NSData alloc] initWithContentsOfFile:coursePath];
    //解析
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    NSString *status = [dict objectForKey:@"status"];
    if (![@"200" isEqualToString:status]) {
        NSLog(@"没有数据");
        return;
    }
    
    NSArray *array = [dict objectForKey:@"data"];
    [self handleWeek:array week:week];
    [self hideHUD];
    
}


- (void)handleWeek:(NSArray *)array week:(NSString *)week
{
    int coursenum = 0;
    NSMutableArray *allCourses =[NSMutableArray array];
    if (array != nil && array.count > 0) {
        for (int i = 0; i < array.count; i++) {
            NSDictionary *dayDict = array[i];
            NSArray *dayCourses = [dayDict objectForKey:@"data"];
            NSString *weekDay = [dayDict objectForKey:@"weekDay"];
            NSString *weekNum;
            if ([@"monday" isEqualToString:weekDay]) {
                weekNum = @"1";
            }else if ([@"tuesday" isEqualToString:weekDay]){
                weekNum = @"2";
            }else if ([@"wednesday" isEqualToString:weekDay]){
                weekNum = @"3";
            }else if ([@"thursday" isEqualToString:weekDay]){
                weekNum = @"4";
            }else if ([@"friday" isEqualToString:weekDay]){
                weekNum = @"5";
            }else if ([@"saturday" isEqualToString:weekDay]){
                weekNum = @"6";
            }else if([@"sunday" isEqualToString:weekDay]){
                weekNum = @"7";
            }else {
                weekNum = weekDay;
            }
            for (int j = 0; j<dayCourses.count; j++) { //一天一天的解析
                NSMutableDictionary *course = [NSMutableDictionary dictionaryWithDictionary:dayCourses[j]];
                [course setObject:weekNum forKey:@"weekDay"];
                WeekCourse *weekCourse = [[WeekCourse alloc] initWithPropertiesDictionary:course];
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                NSString *year = [userDefaults objectForKey:CURRENTYEAR];
                NSString *term = [userDefaults objectForKey:CURRENTTERM];
                NSString *stuId = [userDefaults objectForKey:USERNAME];
                NSString *yearRange = [NSString stringWithFormat:@"%@%@",year,term];
                weekCourse.studentId = stuId;
                weekCourse.term = yearRange;
                weekCourse.weeks = week;
                weekCourse.coursetag = [NSString stringWithFormat:@"%d",1000+coursenum];
                coursenum += 1;
                
                [allCourses addObject:weekCourse];
            }
        }
    }
    //对数据解析
    [self handleData:allCourses];
}

//数据解析后，展示在UI上
- (void)handleData:(NSArray *)courses
{
    
    for (UIView *view in weekScrollView.subviews) {
        if ([view isKindOfClass:[CourseButton class]]) {
            [view removeFromSuperview];
        }
    }
    
    if (courses.count > 0) {
        //处理周课表
        for (int i = 0; i<courses.count; i++) {
            WeekCourse *course = courses[i];
            
            int rowNum = course.lesson.intValue - 1;
            int colNum = course.day.intValue;
            int lessonsNum = course.lessonsNum.intValue;
            
            //每个lesson 格子 视为一个 button
            CourseButton *courseButton = [[CourseButton alloc] initWithFrame:CGRectMake((colNum-0.5)*kWidthGrid, 50*rowNum+1, kWidthGrid-2, 50*lessonsNum-2)];
            courseButton.weekCourse = course;
            int index = i%10;
            // 本地数据课程 tag
            courseButton.tag = [course.coursetag intValue];
            courseButton.backgroundColor = [self handleRandomColorStr:_colors[index]];
            [courseButton addTarget:self action:@selector(courseClick:) forControlEvents:UIControlEventTouchUpInside];
            [weekScrollView addSubview:courseButton];
            
            //第二步,通知中心,发送一条消息通知
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(deletecourse:) name:@"deletecourseNotification" object:nil];
            
        }
        
    }
    
}

// 点击已添加课程，进入课程详情视图
- (void)courseClick:(CourseButton *)courseButton
{
    
    WeekCourse *weekCourse = courseButton.weekCourse;
    
    AddedCourseDetailVC *addeddetailCtr = [[AddedCourseDetailVC alloc] init];
    addeddetailCtr.weekcourse = weekCourse;
    
    
    [self.navigationController pushViewController:addeddetailCtr animated:YES];
    
}

// 删除课程
// 第三，处理通知
- (void)deletecourse:(NSNotification *)notification
{
    WeekCourse *weekcourse = notification.object;
    NSLog(@"删除课程%@",weekcourse.courseName);
    for (CourseButton *courseButton in weekScrollView.subviews)
    {
        if(courseButton.tag == [weekcourse.coursetag intValue])  // 配对
            [courseButton removeFromSuperview];
    }
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}
#pragma mark - 初始化控件
//初始化导航栏
- (void)_initNavigationBar
{
    
    //左侧 添加课程按钮
    UIButton *addcourseButton = [UIButton  buttonWithType:UIButtonTypeContactAdd];
    addcourseButton.frame = CGRectMake(0, 0, 30, 30);
    [addcourseButton addTarget:self action:@selector(addcourseAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *addcourseItem = [[UIBarButtonItem alloc] initWithCustomView:addcourseButton];
    self.navigationItem.rightBarButtonItem = addcourseItem;
    
    // 添加通知中心
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(addnewcourse:) name:@"addcourseNotification" object:nil];
    
    // navagationitem.titleview
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 90, 30)];
    titleView.backgroundColor = [UIColor clearColor];
    
    UIButton *weeksButton = [UIButton  buttonWithType:UIButtonTypeRoundedRect];
    weeksButton.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    weeksButton.frame = CGRectMake(0, 0, 90, 30);
    
    weeksButton.tag = 110;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *currentWeek = [userDefaults objectForKey:@"currentWeek"];
    clickTag = currentWeek.intValue + 250-1;
    currentWeekTag = clickTag;
    weeksButton.titleLabel.font = [UIFont systemFontOfSize:18.0f];
    [weeksButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [weeksButton setTitle:[NSString stringWithFormat:@"第%@周",currentWeek] forState:UIControlStateNormal];
    
    [weeksButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -12, 0, 12)];
    [weeksButton setImage:[UIImage imageNamed:@"course_arrow.png"] forState:UIControlStateNormal];
    [weeksButton setImageEdgeInsets:currentWeek.length>1?UIEdgeInsetsMake(0, 60, 0, -60):UIEdgeInsetsMake(0, 40, 0, -60)];
    
    // 添加 触发事件， 单击 button，进行周选择
    [weeksButton addTarget:self action:@selector(weekChooseAction:) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:weeksButton];
    
    backLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 25, 80, 10)];
    backLabel.backgroundColor = [UIColor clearColor];
    backLabel.textColor = [UIColor redColor];
    backLabel.textAlignment = NSTextAlignmentCenter;
    backLabel.font = [UIFont systemFontOfSize:10];
    backLabel.text = @"返回本周";
    backLabel.hidden = YES;
    [weeksButton addSubview:backLabel];

    self.navigationItem.titleView = titleView;
    
    //背景视图
    bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 60, ScreenWidth, ScreenHeight-60)];
   // bgImageView.image = [UIImage imageNamed:@"course_bg_2.jpeg"];
    bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:bgImageView];
    
}

// 添加课程， 进入添加课程table
- (void)addcourseAction
{
    AddCourseViewController* addcourse = [[AddCourseViewController alloc] initWithNibName:@"AddCourseViewController" bundle:nil];
    
    [self.navigationController pushViewController:addcourse animated:YES];
}

// 添加新课程， 通知中心传值
// 实现通知中心内部的方法,并实现传值
- (void)addnewcourse:(NSNotification *)notification
{
    WeekCourse *weekcourse = notification.object;
    NSLog(@"添加课程%@",weekcourse.courseName);
    
    // 将 中文周数转换成数字
    NSString *weekNum;
    if ([@"周一" isEqualToString:weekcourse.day]||[@"monday" isEqualToString:weekcourse.day]) {
        weekNum = @"1";
    }else if ([@"周二" isEqualToString:weekcourse.day]||[@"tuesday" isEqualToString:weekcourse.day]){
        weekNum = @"2";
    }else if ([@"周三" isEqualToString:weekcourse.day]||[@"wednesday" isEqualToString:weekcourse.day]){
        weekNum = @"3";
    }else if ([@"周四" isEqualToString:weekcourse.day]||[@"thursday" isEqualToString:weekcourse.day]){
        weekNum = @"4";
    }else if ([@"周五" isEqualToString:weekcourse.day]||[@"friday" isEqualToString:weekcourse.day]){
        weekNum = @"5";
    }else if ([@"周六" isEqualToString:weekcourse.day]||[@"saturday" isEqualToString:weekcourse.day]){
        weekNum = @"6";
    }else if([@"周日" isEqualToString:weekcourse.day]||[@"sunday" isEqualToString:weekcourse.day]){
        weekNum = @"7";
    }else {
        weekNum = weekcourse.day;
    }
    
    int rowNum = weekcourse.lesson.intValue - 1;
    int colNum = weekNum.intValue;
    int lessonsNum = weekcourse.lessonsNum.intValue;
    
    CourseButton *courseButton = [[CourseButton alloc] initWithFrame:CGRectMake((colNum-0.5)*kWidthGrid, 50*rowNum+1, kWidthGrid-2, 50*lessonsNum-2)];
    courseButton.weekCourse = weekcourse;
    courseButton.backgroundColor = [self handleRandomColorStr:_colors[arc4random() % 10]]; //获取0-x之间的随机整数：数arc4random()%x
    [courseButton addTarget:self action:@selector(courseClick:) forControlEvents:UIControlEventTouchUpInside];
    [weekScrollView addSubview:courseButton];
    courseButton.tag = [weekcourse.coursetag intValue];
    
    // 跳回至课程主视图
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}


//初始化隐藏的周选择视图, 滚动栏, 初始隐藏，点击显示
- (void)_initWeekChoseView
{
    weekChoseScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 50)];
    weekChoseScrollView.backgroundColor = WEEKDAY_BGCOLOR;
    weekChoseScrollView.contentSize = CGSizeMake(50*25, 50);
    weekChoseScrollView.showsHorizontalScrollIndicator = NO;
    for (int i = 0; i< 25; i++)
    {
        WeekChoseView *weekChoseView = [[WeekChoseView alloc] initWithFrame:CGRectMake(50*i, 0, 50, 50)];
        weekChoseView.number = [NSString stringWithFormat:@"%d",i+1];
        weekChoseView.delegate = self;
        weekChoseView.tag = 250+i;
        if (clickTag == (250 +i)) {
            weekChoseView.isCurrentWeek = YES;
            weekChoseView.isChosen = YES;
            [weekChoseView reset];
            weekChoseScrollView.contentOffset = CGPointMake(50*i, 0);
        }
        [weekChoseScrollView addSubview:weekChoseView];
    }
    
    [self.view addSubview:weekChoseScrollView];
}

//初始化周视图
- (void)_initWeekView
{
    //周视图的大小，位置设置
    weekView = [[UIView alloc] initWithFrame:CGRectMake(0, 60, ScreenWidth, ScreenHeight-60)];
    //初始化周视图的头
    UIView *weekHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 30)];
    UIButton *monthButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kWidthGrid*0.5, 30)];
    [monthButton setTitle:horTitles[0] forState:UIControlStateNormal];
    [monthButton setTitleColor:WEEKDAY_FONT_COLOR forState:UIControlStateNormal];
    monthButton.titleLabel.font = [UIFont fontWithName:@"Microsoft YaHei" size:9.0f];
    monthButton.layer.borderColor = WEEKDAY_SELECT_COLOR.CGColor;
    monthButton.layer.borderWidth = 0.3f;
    monthButton.layer.masksToBounds = YES;
    [weekHeaderView addSubview:monthButton];
    
    NSArray *weekDays = @[@"一",@"二",@"三",@"四",@"五",@"六",@"日"];
    for (int i = 0; i< 7; i++) {
        TwoTitleButton *button = [[TwoTitleButton alloc] initWithFrame:CGRectMake((i+0.5)*kWidthGrid, 0, kWidthGrid, 30)];
        NSString *title = [NSString stringWithFormat:@"周%@",weekDays[i]];
        button.tag = 9000+i;
        button.title = horTitles[i+1];
        button.subtitle = title;
        button.textColor = WEEKDAY_FONT_COLOR;
        
        NSString *month = [NSString stringWithFormat:@"%d月",[todayComp month]];
        
        NSString *day = [NSString stringWithFormat:@"%d",[todayComp day]];
        if ([month isEqualToString:horTitles[0]] && [day isEqualToString:horTitles[i+1]]) {
            button.backgroundColor = WEEKDAY_SELECT_COLOR;
        }
        
        [weekHeaderView addSubview:button];
    }
    [weekView addSubview:weekHeaderView];
    
    //主体部分
    weekScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 30, ScreenWidth, weekView.frame.size.height -30)];
    weekScrollView.bounces = NO;
    weekScrollView.contentSize = CGSizeMake(ScreenWidth, 50*12);
    for (int i = 0; i<12; i++) {  // 每天12节课
        for (int j = 0; j< 8; j++) {  // 7天＋左侧课程号栏
            if (j == 0) {
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(j*kWidthGrid, i*50,kWidthGrid*0.5, 50)];
                label.backgroundColor = [UIColor clearColor];
                label.layer.borderColor = WEEKDAY_SELECT_COLOR.CGColor;
                label.layer.borderWidth = 0.3f;
                label.layer.masksToBounds = YES;
                label.textAlignment = NSTextAlignmentCenter;
                label.textColor = WEEKDAY_FONT_COLOR;
                label.text =[NSString stringWithFormat:@"%d",i+1];
                [weekScrollView addSubview:label];
            } else {
                // 课程 分隔网线
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((j-0.5)*kWidthGrid-1, i*50, kWidthGrid, 50+1)];
                imageView.image = [UIImage imageNamed:@"course_excel.png"];
                [weekScrollView addSubview:imageView];
            }
            
        }
    }
    [weekView addSubview:weekScrollView];
    
    [self.view addSubview:weekView];
    
}

//另一种加载提示框
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

#pragma mark - 私有方法
//生成随机颜色，  课程背景颜色
- (UIColor *)randomColor
{
    
    UIColor *color1 = [UIColor colorWithRed:9/255.0f green:155/255.0f blue:43/255.0f alpha:0.5];
    UIColor *color2 = [UIColor colorWithRed:251/255.0f green:136/255.0f blue:71/255.0f alpha:0.5];
    UIColor *color3 = [UIColor colorWithRed:163/255.0f green:77/255.0f blue:140/255.0f alpha:0.5];
    NSArray *array = [[NSArray alloc] initWithObjects:color1,color2,color3, nil];
    return [array objectAtIndex:arc4random()%3];
}

//处理随机颜色字符串
- (UIColor *)handleRandomColorStr:(NSString *)randomColorStr
{
    NSArray *array = [randomColorStr componentsSeparatedByString:@","];
    if (array.count >2) {
        NSString *red = array[0];
        NSString *green = array[1];
        NSString *blue = array[2];
        return [UIColor colorWithRed:red.floatValue/255.0f green:green.floatValue/255.0f blue:blue.floatValue/255.0f alpha:0.5];
    }
    return [UIColor lightGrayColor];
}


- (void)weekChooseAction:(id)sender
{
    //本来显示，点击之后要隐藏
    if (weekChoseViewShow) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationRepeatCount:1];
        [UIView setAnimationDuration:0.5f];
        weekChoseScrollView.frame = CGRectMake(0, -60, ScreenWidth, 50);  //隐藏
        [self changeSubViewsFrameByWeek:weekChoseViewShow];
        [UIView commitAnimations];
        weekChoseViewShow = NO;
        if(clickTag!=currentWeekTag){  // 选中的周的tag 不等于 当前周的tag
            WeekChoseView *view = (WeekChoseView *)[weekChoseScrollView viewWithTag:clickTag];
            view.isChosen = NO;
            [view reset];
            clickTag = currentWeekTag;
            NSString *week = [[NSString alloc] initWithFormat:@"%d",clickTag-250+1];
            UIButton *weekButton = (UIButton *)[self.navigationItem.titleView viewWithTag:110];
            
            [weekButton setTitle:[NSString stringWithFormat:@"第%@周",week] forState:UIControlStateNormal];
            [weekButton setImageEdgeInsets:week.length>1?UIEdgeInsetsMake(0, 60, 0, -60):UIEdgeInsetsMake(0, 40, 0, -60)];
            [self bounceTargetView:weekButton];  // weekButton 弹跳显示
            backLabel.hidden = YES;
            //数据也重新加载
            [self loadNetDataWithWeek:week];
        }
    }else {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationRepeatCount:1];
        [UIView setAnimationDuration:0.5f];
        weekChoseScrollView.frame = CGRectMake(0, 60, ScreenWidth, 50);     //周选择滚动栏 显示
        [self changeSubViewsFrameByWeek:weekChoseViewShow];
        [UIView commitAnimations];
        weekChoseViewShow = YES;
        
        if(clickTag ==currentWeekTag){
            WeekChoseView *view = (WeekChoseView *)[weekChoseScrollView viewWithTag:currentWeekTag];
            view.isChosen = YES;
            [view reset];
        }
    }
    
}

- (void)bounceTargetView:(UIView *)targetView
{
    [UIView animateWithDuration:0.1 animations:^{
        targetView.transform = CGAffineTransformMakeScale(0.9, 0.9);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 animations:^{
            targetView.transform = CGAffineTransformMakeScale(1.1, 1.1);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1 animations:^{
                targetView.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                
            }];
        }];
    }];
}

//修改子类的frame
- (void)changeSubViewsFrameByWeek:(BOOL)_weekViewShow
{
    if (_weekViewShow) {
        //设置周课表视图以及其子视图的frame
        weekView.frame =  CGRectMake(0, 60, ScreenWidth, ScreenHeight-60);
        CGRect frame = weekScrollView.frame;
        frame.size.height = weekView.frame.size.height-30;
        weekScrollView.frame = frame;
        
    } else {
        
        //设置周课表视图以及其子视图的frame
        weekView.frame =  CGRectMake(0, 60+50, ScreenWidth, ScreenHeight-60-50);
        CGRect frame = weekScrollView.frame;
        frame.size.height = weekView.frame.size.height-30;
        weekScrollView.frame = frame;
        
    }
    
}

//修改子类的frame
- (void)changeSubViewsFrame:(BOOL)_toolViewShow
{
    if (_toolViewShow) {
        
        //设置周课表视图以及其子视图的frame
        weekView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight-60);
        CGRect frame = weekScrollView.frame;
        frame.size.height = weekView.frame.size.height-30;
        weekScrollView.frame = frame;
        
    } else {
        
        //设置周课表视图以及其子视图的frame
        weekView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight-20-44-40);
        CGRect frame = weekScrollView.frame;
        frame.size.height = weekView.frame.size.height-30;
        weekScrollView.frame = frame;
        
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)_scrollView
{
    //本来显示，点击之后要隐藏
    if (weekChoseViewShow) {
        [UIView animateWithDuration:0.5 animations:^{
            weekChoseScrollView.frame = CGRectMake(0, -60, ScreenWidth, 50);
            [self changeSubViewsFrameByWeek:weekChoseViewShow];
            weekChoseViewShow = NO;
        } completion:^(BOOL finished) {
            if (_scrollView == scrollView) {
                int page = scrollView.contentOffset.x/ScreenWidth;
                for (int i = 0; i < 7; i++) {
                    TwoTitleButton *button = (TwoTitleButton *)[dayView viewWithTag:9000+i];
                    if (page == i) {
                        button.backgroundColor = WEEKDAY_SELECT_COLOR;
                        if (sliderLabel) {
                            [UIView beginAnimations:nil context:nil];
                            [UIView setAnimationDuration:0.2];
                            CGRect rect = sliderLabel.frame;
                            rect.origin.x = (i+0.5)*kWidthGrid;
                            sliderLabel.frame = rect;
                            [UIView commitAnimations];
                        }
                    }else {
                        button.backgroundColor = [UIColor clearColor];
                    }
                    
                }
            }
            
        }];
    } else {
        if (_scrollView == scrollView) {
            int page = scrollView.contentOffset.x/ScreenWidth;
            for (int i = 0; i < 7; i++) {
                TwoTitleButton *button = (TwoTitleButton *)[dayView viewWithTag:9000+i];
                if (page == i) {
                    button.backgroundColor = WEEKDAY_SELECT_COLOR;
                    if (sliderLabel) {
                        [UIView beginAnimations:nil context:nil];
                        [UIView setAnimationDuration:0.2];
                        CGRect rect = sliderLabel.frame;
                        rect.origin.x = (i+0.5)*kWidthGrid;
                        sliderLabel.frame = rect;
                        [UIView commitAnimations];
                    }
                }else {
                    button.backgroundColor = [UIColor clearColor];
                }
                
            }
        }
        
    }
    
}


#pragma mark - WeekChoseViewDelegate
- (void)tapAction:(int)tag
{
    if (clickTag == 0) {
        clickTag = tag;
    }else {
        WeekChoseView *view = (WeekChoseView *)[weekChoseScrollView viewWithTag:clickTag];
        view.isChosen = NO;
        [view reset];
        clickTag = tag;
    }
    NSString *week = [[NSString alloc] initWithFormat:@"%d",tag-250+1];
    UIButton *weekButton = (UIButton *)[self.navigationItem.titleView viewWithTag:110];
    [weekButton setTitle:[NSString stringWithFormat:@"第%@周",week] forState:UIControlStateNormal];
    [weekButton setImageEdgeInsets:week.length>1?UIEdgeInsetsMake(0, 60, 0, -60):UIEdgeInsetsMake(0, 40, 0, -60)];
    [self bounceTargetView:weekButton];
    
    if(clickTag !=currentWeekTag){
        backLabel.hidden = NO;
    }
    else if(clickTag == currentWeekTag){
        backLabel.hidden = YES;
    }
    
    //重新加载
    [self loadNetDataWithWeek:week];
}

- (void)setCurrentWeek:(NSString *)number
{
    NSString *title = [NSString stringWithFormat:@"将第%@周设置为本周？",number];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        //点击取消
    }else {
        //点击确定按钮
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        //先取消原来本周控件的背景色
        NSString *currentWeek = [userDefaults objectForKey:@"currentWeek"];
        WeekChoseView *weekChoseView = (WeekChoseView *)[weekChoseScrollView viewWithTag:(currentWeek.intValue +250-1)];
        weekChoseView.isCurrentWeek = NO;
        [weekChoseView reset];
        
        WeekChoseView *newView = (WeekChoseView *)[weekChoseScrollView viewWithTag:clickTag];
        newView.isCurrentWeek = YES;
        currentWeekTag = clickTag;
        [newView reset];
        [userDefaults setObject:[NSString stringWithFormat:@"%d",clickTag-250+1] forKey:@"currentWeek"];
        [userDefaults synchronize];
        
        backLabel.hidden = YES;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        weekChoseScrollView.frame = CGRectMake(0, -60, ScreenWidth, 50);
        [self changeSubViewsFrameByWeek:weekChoseViewShow];
        weekChoseViewShow = NO;
        [UIView commitAnimations];
    }
}

#pragma mark - MBProgressHUDDelegate
- (void)hudWasHidden:(MBProgressHUD *)hud {
    // Remove HUD from screen when the HUD was hidded
    [hud removeFromSuperview];
    hud = nil;
}



@end
