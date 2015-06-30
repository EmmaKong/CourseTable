//
//  ClassPeerTableViewController.m
//  Calendar
//
//  Created by emma on 15/5/27.
//  Copyright (c) 2015年 Emma. All rights reserved.
//

#import "ClassPeerViewController.h"
#import "PeerCell.h"
#import "PullingRefreshTableView.h"
#import "Member.h"

@interface ClassPeerViewController ()<PullingRefreshTableViewDelegate>

@property (retain,nonatomic) PullingRefreshTableView *mytableView;

@property (nonatomic) BOOL refreshing;

@end

@implementation ClassPeerViewController

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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"课堂同伴";
    
    //CGRect bounds = self.view.bounds;
    _mytableView = [[PullingRefreshTableView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height-64) pullingDelegate:self];
    self.tableView = _mytableView;
    
    [self showHUD:@"正在加载..." isDim:NO]; // 拉动加载
    //加载本地数据
    [self performSelector:@selector(loadnewCourseDatas) withObject:nil afterDelay:0.5];

    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.view addSubview:self.tableView];

}

- (void)loadnewCourseDatas
{
    // json数据解析
    NSString *classpeerPath = [[NSBundle mainBundle] pathForResource:@"classpeer" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:classpeerPath];
    NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    _classpeersArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < array.count; i++) {
        Member *classpeer = [[Member alloc] initWithPropertiesDictionary:array[i]];
        
        [_classpeersArray  addObject:classpeer];
    }
    [_mytableView  reloadData];
    [self hideHUD];
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
    return _classpeersArray .count;

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PeerCell";
    PeerCell *cell = (PeerCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"PeerCell" owner:self options:nil] lastObject];
    }
    
    Member *classpeer = _classpeersArray[indexPath.row];
    
    NSString *nametext = [NSString stringWithFormat:@"%@",classpeer.name];
    NSString *somethingtext = [NSString stringWithFormat:@"%@",classpeer.something];

        
    cell.tag = indexPath.row;
    cell.delegate = self;
    cell.nameLabel.text = nametext;
    cell.somethingLabel.text = somethingtext;
    
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
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


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
   
}


@end
