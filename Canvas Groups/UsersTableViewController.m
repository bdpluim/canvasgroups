//
//  UsersTableViewController.m
//  Canvas Groups
//
//  Created by Brandon Pluim on 12/3/14.
//  Copyright (c) 2014 Instructure. All rights reserved.
//

#import "UsersTableViewController.h"
#import "CanvasKitManager.h"
#import "EditGroupUserTableViewController.h"

#import "UIViewController+SimpleAlerts.h"

@interface UsersTableViewController ()

@property (nonatomic, strong) NSMutableArray *users;

@end

@implementation UsersTableViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSLog(@"%@", NSStringFromClass(self.class));
    
    self.users = [NSMutableArray new];
    [self.tableView reloadData];
    
    self.title = self.group.name;
    [[[[CanvasKitManager sharedInstance] client] fetchGroupUsersForContext:self.group] subscribeNext:^(id users) {
        [self.users addObjectsFromArray:users];
    } error:^(NSError *error) {
        [self showAlertWithTitle:@"ERROR FETCHING USERS" message:[NSString stringWithFormat:@"Error: %@", [error localizedDescription]]];
    } completed:^{
        NSLog(@"Finished Fetching Users");
        
        [self.users sortUsingComparator:^NSComparisonResult(CKIUser *user1, CKIUser *user2) {
            return [user1.name compare:user2.name];
        }];
        
        [self.tableView reloadData];
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.users.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserCellIdentifier" forIndexPath:indexPath];
    
    CKIUser *user = self.users[indexPath.row];
    cell.textLabel.text = user.name;
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle != UITableViewCellEditingStyleDelete) {
        return;
    }
    
    __block CKIUser *user = self.users[indexPath.row];
    [self.tableView beginUpdates];
    [self.users removeObject:user];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];
    
    // remove membership
    [[[[CanvasKitManager sharedInstance] client] removeGroupMemebershipForUser:user.id inGroup:self.group] subscribeError:^(NSError *error) {
        [self.tableView beginUpdates];
        NSUInteger indexToAdd = [self.users indexOfObject:user inSortedRange:NSMakeRange(0, [self.users count]) options:NSBinarySearchingInsertionIndex usingComparator:^NSComparisonResult(CKIUser *user1, CKIUser *user2) {
            return [user1.name compare:user2.name];
        }];
        
        [self.users insertObject:user atIndex:indexToAdd];
        [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexToAdd inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView endUpdates];
        
        [self showAlertWithTitle:@"ERROR DELETING USER" message:[NSString stringWithFormat:@"Error: %@", [error localizedDescription]]];
    } completed:^{
        NSLog(@"DONE REMOVING MEMBERSHIP");
    }];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    EditGroupUserTableViewController *inviteController = segue.destinationViewController;
    inviteController.group = self.group;
    inviteController.category = self.category;
    inviteController.groupUsers = self.users;
}

@end
