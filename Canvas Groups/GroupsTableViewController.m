//
//  GroupsTableViewController.m
//  Canvas Groups
//
//  Created by Brandon Pluim on 12/3/14.
//  Copyright (c) 2014 Instructure. All rights reserved.
//

#import "GroupsTableViewController.h"

#import <CanvasKit/CanvasKit.h>

#import "CanvasKitManager.h"
#import "UsersTableViewController.h"
#import "NewGroupViewController.h"

#import "UIViewController+SimpleAlerts.h"

@interface GroupsTableViewController ()
@property (nonatomic, strong) NSMutableArray *groups;
@end

@implementation GroupsTableViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSLog(@"%@", NSStringFromClass(self.class));
    
    self.groups = [NSMutableArray new];
    [self.tableView reloadData];
    
    [[[[CanvasKitManager sharedInstance] client] fetchGroupsForGroupCategory:self.category] subscribeNext:^(NSArray *groups) {
        NSLog(@"Fetched a Single Page of Groups");

        [self.groups addObjectsFromArray:groups];
    } error:^(NSError *error) {
        [self showAlertWithTitle:@"ERROR FETCHING COURSES" message:[NSString stringWithFormat:@"Error: %@", [error localizedDescription]]];
    } completed:^{
        NSLog(@"Finished Fetching Groups");
        
        [self.groups sortUsingComparator:^NSComparisonResult(CKIGroup *group1, CKIGroup *group2) {
            return [group1.name compare:group2.name];
        }];
        
        [self.tableView reloadData];
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.groups.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GroupCellIdentifier" forIndexPath:indexPath];
    
    CKIGroup *group = self.groups[indexPath.row];
    cell.textLabel.text = group.name;
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle != UITableViewCellEditingStyleDelete) {
        return;
    }
    
    __block CKIGroup *group = self.groups[indexPath.row];
    [self.tableView beginUpdates];
    [self.groups removeObject:group];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];
    
    [[[[CanvasKitManager sharedInstance] client] deleteGroup:group] subscribeError:^(NSError *error) {
        [self.tableView beginUpdates];
        NSUInteger indexToAdd = [self.groups indexOfObject:group inSortedRange:NSMakeRange(0, [self.groups count]) options:NSBinarySearchingInsertionIndex usingComparator:^NSComparisonResult(CKIGroup *group1, CKIGroup *group2) {
            return [group1.name compare:group2.name];
        }];
        
        [self.groups insertObject:group atIndex:indexToAdd];
        [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexToAdd inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView endUpdates];
        
        [self showAlertWithTitle:@"ERROR DELETING GROUP" message:[NSString stringWithFormat:@"Error: %@", [error localizedDescription]]];
    } completed:^{
        NSLog(@"Group Deleted Successfully");
    }];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"GroupSegue"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        CKIGroup *selectedGroup = self.groups[indexPath.row];
        UsersTableViewController *usersController = segue.destinationViewController;
        usersController.group = selectedGroup;
        usersController.category = self.category;
    } else {
        UINavigationController *navController = segue.destinationViewController;
        NewGroupViewController *controller = navController.viewControllers[0];
        controller.category = self.category;
    }
}

@end
