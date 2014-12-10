//
//  CanvasKitManager.m
//  Canvas Groups
//
//  Created by Brandon Pluim on 12/3/14.
//  Copyright (c) 2014 Instructure. All rights reserved.
//

#import "CanvasKitManager.h"

static NSString *const BASE_URL = @"[INSERT_DOMAIN_HERE]";
static NSString *const TOKEN = @"[INSERT_TOKEN_HERE]";

@interface CanvasKitManager ()
@end

@implementation CanvasKitManager

+ (instancetype)sharedInstance {
    static CanvasKitManager *sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
        sharedInstance.client = [[CKIClient alloc] initWithBaseURL:[NSURL URLWithString:BASE_URL] token:TOKEN];
    });
    
    return sharedInstance;
}

@end
