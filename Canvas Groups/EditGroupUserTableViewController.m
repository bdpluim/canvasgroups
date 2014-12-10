//
//  InviteUsersTableViewController.m
//  Canvas Groups
//
//  Created by Brandon Pluim on 12/4/14.
//  Copyright (c) 2014 Instructure. All rights reserved.
//

#import "EditGroupUserTableViewController.h"

#import <CanvasKit.h>
#import "CanvasKitManager.h"

#import "UIViewController+SimpleAlerts.h"

@interface EditGroupUserTableViewController ()

@property (nonatomic, strong) NSMutableArray *categoryUsers;
@property (nonatomic, strong) NSMutableDictionary *groupUsersDictionary;

@end

@implementation EditGroupUserTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.groupUsersDictionary = [NSMutableDictionary new];
    self.categoryUsers = [NSMutableArray new];
    [self.tableView reloadData];
    
    self.title = [NSString stringWithFormat:@"Edit %@", self.group.name];
    
    [self.groupUsers enumerateObjectsUsingBlock:^(CKIUser *user, NSUInteger idx, BOOL *stop) {
        [self.groupUsersDictionary setObject:user forKey:user.id];
    }];

    [[[[CanvasKitManager sharedInstance] client] fetchUsersInGroupCategory:self.category] subscribeNext:^(NSArray *categoryUsers) {
        NSLog(@"Fetched a Single Page of Users in Group Category");
        [self.categoryUsers addObjectsFromArray:categoryUsers];
    } error:^(NSError *error) {
        [self showAlertWithTitle:@"ERROR FETCHING USERS" message:[NSString stringWithFormat:@"Error: %@", [error localizedDescription]]];
    } completed:^{
        NSLog(@"Finished Fetching Users");
        
        [self.categoryUsers sortUsingComparator:^NSComparisonResult(CKIUser *user1, CKIUser *user2) {
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
    return self.categoryUsers.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserCell" forIndexPath:indexPath];
    
    CKIUser *user = self.categoryUsers[indexPath.row];
    cell.textLabel.text = user.name;
    
    CKIUser *existingUser = [self.groupUsersDictionary objectForKey:user.id];
    if (existingUser) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CKIUser *user = self.categoryUsers[indexPath.row];
    CKIUser *existingUser = [self.groupUsersDictionary objectForKey:user.id];
    
    if (existingUser) {
        // remove membership
        [self.groupUsersDictionary removeObjectForKey:user.id];
        [[[[CanvasKitManager sharedInstance] client] removeGroupMemebershipForUser:user.id inGroup:self.group] subscribeError:^(NSError *error) {
            [self showAlertWithTitle:@"ERROR REMOVING MEMBERSHIP" message:[NSString stringWithFormat:@"Error: %@", [error localizedDescription]]];
            
            [self.groupUsersDictionary setObject:user forKey:user.id];
            [self.tableView reloadData];
        } completed:^{
            NSLog(@"DONE REMOVING MEMBERSHIP");
        }];
    } else {
        // create membership
        [self.groupUsersDictionary setObject:user forKey:user.id];
        [[[[CanvasKitManager sharedInstance] client] createGroupMemebershipForUser:user.id inGroup:self.group] subscribeError:^(NSError *error) {
            [self showAlertWithTitle:@"ERROR CREATING MEMBERSHIP" message:[NSString stringWithFormat:@"Error: %@", [error localizedDescription]]];
            
            [self.groupUsersDictionary removeObjectForKey:user.id];
            [self.tableView reloadData];
        } completed:^{
            NSLog(@"DONE CREATING MEMBERSHIP");
        }];
    }
    
    [self.tableView beginUpdates];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];
}

@end
