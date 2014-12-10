//
//  NewGroupViewController.m
//  Canvas Groups
//
//  Created by Brandon Pluim on 12/4/14.
//  Copyright (c) 2014 Instructure. All rights reserved.
//

#import "NewGroupViewController.h"

#import <CanvasKit/CanvasKit.h>
#import "CanvasKitManager.h"

#import "UIViewController+SimpleAlerts.h"

@interface NewGroupViewController ()

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UISwitch *isPublicSwitch;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;

@end

@implementation NewGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.group = [[CKIGroup alloc] init];
}

- (IBAction)cancelTouched:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)saveTouched:(id)sender {
    // populate group properties
    self.group.name = self.nameTextField.text;
    self.group.isPublic = self.isPublicSwitch.isOn;
    self.group.groupDescription = self.descriptionTextView.text;
    self.group.joinLevel = CKIGroupJoinLevelParentContextAutoJoin;
    
    [[[[CanvasKitManager sharedInstance] client] createGroup:self.group category:self.category] subscribeError:^(NSError *error) {
        [self showAlertWithTitle:@"ERROR CREATING GROUP" message:[NSString stringWithFormat:@"Error: %@", [error localizedDescription]]];
    } completed:^{
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}

@end
