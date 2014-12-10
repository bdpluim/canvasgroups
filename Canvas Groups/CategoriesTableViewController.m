//
//  CategoriesTableViewController.m
//  Canvas Groups
//
//  Created by Brandon Pluim on 12/8/14.
//  Copyright (c) 2014 Instructure. All rights reserved.
//

#import "CategoriesTableViewController.h"

#import <CanvasKit/CanvasKit.h>

#import "CanvasKitManager.h"
#import "GroupsTableViewController.h"

#import "UIViewController+SimpleAlerts.h"

@interface CategoriesTableViewController ()

@property (nonatomic, strong) NSMutableArray *categories;

@end

@implementation CategoriesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"%@", NSStringFromClass(self.class));
    
    self.categories = [NSMutableArray new];
    [self.tableView reloadData];
    
    [[[[CanvasKitManager sharedInstance] client] fetchGroupCategoriesForCourse:self.course] subscribeNext:^(NSArray *categories) {
        NSLog(@"Fetched a Single Page of Categories");
        
        [self.categories addObjectsFromArray:categories];
    } error:^(NSError *error) {
        [self showAlertWithTitle:@"ERROR FETCHING CATEGORIES" message:[NSString stringWithFormat:@"Error: %@", [error localizedDescription]]];
    } completed:^{
        [self.categories sortUsingComparator:^NSComparisonResult(CKIGroupCategory *category1, CKIGroupCategory *category2) {
            return [category1.name compare:category2.name];
        }];
        [self.tableView reloadData];
        
        NSLog(@"Finished Fetching Categories");
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.categories.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CourseCell" forIndexPath:indexPath];

    CKIGroupCategory *category = self.categories[indexPath.row];
    cell.textLabel.text = category.name;
    return cell;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    CKIGroupCategory *category = self.categories[[self.tableView indexPathForSelectedRow].row];
    
    GroupsTableViewController *controller = segue.destinationViewController;
    controller.course = self.course;
    controller.category = category;
}

@end
