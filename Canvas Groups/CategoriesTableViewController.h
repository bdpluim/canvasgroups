//
//  CategoriesTableViewController.h
//  Canvas Groups
//
//  Created by Brandon Pluim on 12/8/14.
//  Copyright (c) 2014 Instructure. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CKICourse;

@interface CategoriesTableViewController : UITableViewController

@property (nonatomic, strong) CKICourse *course;

@end
