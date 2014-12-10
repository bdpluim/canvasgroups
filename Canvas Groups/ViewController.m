//
//  ViewController.m
//  Canvas Groups
//
//  Created by Brandon Pluim on 12/3/14.
//  Copyright (c) 2014 Instructure. All rights reserved.
//

#import "ViewController.h"
#import "CanvasKitManager.h"
#import <CanvasKit.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [[[[CanvasKitManager sharedInstance] client] fetchGroupsForLocalUser] subscribeNext:^(id x) {
        NSLog(@"");
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
