//
//  UIViewController+SimpleAlerts.m
//  Canvas Groups
//
//  Created by Brandon Pluim on 12/10/14.
//  Copyright (c) 2014 Instructure. All rights reserved.
//

#import "UIViewController+SimpleAlerts.h"

@implementation UIViewController (SimpleAlerts)

#pragma mark - Alerts

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message {
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [controller addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }]];
    [self presentViewController:controller animated:YES completion:nil];
}


@end
