//
//  CoursesTableViewController.m
//  Canvas Groups
//
//  Created by Brandon Pluim on 12/5/14.
//  Copyright (c) 2014 Instructure. All rights reserved.
//

#import "CoursesTableViewController.h"

#import <CanvasKit/CanvasKit.h>

#import "CanvasKitManager.h"
#import "CategoriesTableViewController.h"
#import "UIViewController+SimpleAlerts.h"

@interface CoursesTableViewController ()
@property (nonatomic, strong) NSMutableArray *courses;
@end

@implementation CoursesTableViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSLog(@"%@", NSStringFromClass(self.class));
    
    self.courses = [NSMutableArray new];
    [self.tableView reloadData];
    
    [[[[CanvasKitManager sharedInstance] client] fetchCoursesForCurrentUser] subscribeNext:^(NSArray *courses) {
        NSLog(@"Fetched a Single Page of Courses");
        
        [self.courses addObjectsFromArray:courses];
    } error:^(NSError *error) {
        [self showAlertWithTitle:@"ERROR FETCHING COURSES" message:[NSString stringWithFormat:@"Error: %@", [error localizedDescription]]];
    } completed:^{
        [self.courses sortUsingComparator:^NSComparisonResult(CKICourse *course1, CKICourse *course2) {
            return [course1.name compare:course2.name];
        }];
        [self.tableView reloadData];
        
        NSLog(@"Finished Fetching Courses");
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.courses.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CourseCell" forIndexPath:indexPath];
    CKICourse *course = self.courses[indexPath.row];
    cell.textLabel.text = course.name;
    return cell;
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    CKICourse *course = self.courses[[self.tableView indexPathForSelectedRow].row];
    CategoriesTableViewController *controller = segue.destinationViewController;
    controller.course = course;
}

@end
