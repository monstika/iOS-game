//
//  FlipsideViewController.h
//  Otter Space
//
//  Created by Monika Tuchowska on 4/6/14.
//  Copyright (c) 2014 Monika Tuchowska. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>

@class FlipsideViewController;

@protocol FlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller;
@end

@interface FlipsideViewController : UIViewController

@property (weak, nonatomic) id <FlipsideViewControllerDelegate> delegate;
@property (strong, nonatomic) IBOutlet UIImageView *gameBg;

@property (strong, nonatomic) NSMutableArray *bgAnim, *angryMeteorAnim, *vampMeteorAnim;
@property (strong, nonatomic) NSMutableArray *enemies, *enemyHitboxes;

@property (strong, nonatomic) IBOutlet UIImageView *rocket;

@property (strong, nonatomic) CMMotionManager *motionManager;


- (IBAction)done:(id)sender;

@end
