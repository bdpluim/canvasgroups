//
//  NewGroupViewController.h
//  Canvas Groups
//
//  Created by Brandon Pluim on 12/4/14.
//  Copyright (c) 2014 Instructure. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CKIGroup;
@class CKICourse;
@class CKIGroupCategory;

@interface NewGroupViewController : UIViewController

@property (nonatomic, strong) CKIGroup *group;
@property (nonatomic, strong) CKIGroupCategory *category;

@end
