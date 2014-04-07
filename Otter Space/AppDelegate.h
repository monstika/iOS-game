//
//  AppDelegate.h
//  Otter Space
//
//  Created by Monika Tuchowska on 4/6/14.
//  Copyright (c) 2014 Monika Tuchowska. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property int score;

+(AppDelegate*)appDelegate;

@end
