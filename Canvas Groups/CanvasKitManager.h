//
//  CanvasKitManager.h
//  Canvas Groups
//
//  Created by Brandon Pluim on 12/3/14.
//  Copyright (c) 2014 Instructure. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CanvasKit.h>

@interface CanvasKitManager : NSObject

@property (nonatomic, strong) CKIClient *client;
+ (instancetype)sharedInstance;

@end
