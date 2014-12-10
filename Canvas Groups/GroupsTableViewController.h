//
//  GroupsTableViewController.h
//  Canvas Groups
//
//  Created by Brandon Pluim on 12/3/14.
//  Copyright (c) 2014 Instructure. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CKICourse;
@class CKIGroupCategory;

@interface GroupsTableViewController : UITableViewController

@property (nonatomic, strong) CKICourse *course;
@property (nonatomic, strong) CKIGroupCategory *category;

@end
