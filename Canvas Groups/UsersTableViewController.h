//
//  UsersTableViewController.h
//  Canvas Groups
//
//  Created by Brandon Pluim on 12/3/14.
//  Copyright (c) 2014 Instructure. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CanvasKit.h>

@interface UsersTableViewController : UITableViewController

@property (nonatomic, strong) CKIGroup *group;
@property (nonatomic, strong) CKIGroupCategory *category;

@end
