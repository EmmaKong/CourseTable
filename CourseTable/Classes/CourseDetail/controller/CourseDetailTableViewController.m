//
//  CourseDetailTableViewController.m
//  CourseDetail
//
//  Created by emma on 15/5/22.
//  Copyright (c) 2015年 Emma. All rights reserved.
//

#import "CourseDetailTableViewController.h"

@interface CourseDetailTableViewController ()

@end

@implementation CourseDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"课程详情";
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Setting sections

- (void)setSections:(NSArray *)sections {
    _sections = sections;
    
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sections.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    CourseDetailSection *courseSection = self.sections[section];
    return courseSection.headerView;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    CourseDetailSection *courseSection = self.sections[section];
    return courseSection.headerTitle;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    CourseDetailSection *courseSection = self.sections[section];
    return courseSection.headerHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
   CourseDetailSection *courseSection = self.sections[section];
    return courseSection.footerView;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    CourseDetailSection *courseSection = self.sections[section];
    return courseSection.footerTitle;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    CourseDetailSection *courseSection = self.sections[section];
    return courseSection.footerHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    CourseDetailSection *courseSection = self.sections[section];
    return courseSection.reuseEnabled ? courseSection.reusedCellCount : courseSection.cells.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CourseDetailSection *courseSection = self.sections[indexPath.section];
    
    if (courseSection.reuseEnabled) {
        return courseSection.reusedCellHeight;
    }
    
    else {
        CourseDetailCell *cell = courseSection.cells[indexPath.row];
        return cell.height;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CourseDetailSection *courseSection = self.sections[indexPath.section];
    
    if (courseSection.reuseEnabled) {
        return courseSection.cellForRowBlock(tableView, indexPath.row);
    }
    
    else {
        return courseSection.cells[indexPath.row];
    }
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CourseDetailSection *courseSection = self.sections[indexPath.section];
    
    if (courseSection.reuseEnabled) {
        if (courseSection.reusedCellActionBlock) {
            courseSection.reusedCellActionBlock(indexPath.row);
        }
    }
    
    else {
        CourseDetailCell *cell = courseSection.cells[indexPath.row];
        
        if (cell.actionBlock) {
            cell.actionBlock();
        }
    }
}

@end
