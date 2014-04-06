//
//  FlipsideViewController.m
//  Otter Space
//
//  Created by Monika Tuchowska on 4/6/14.
//  Copyright (c) 2014 Monika Tuchowska. All rights reserved.
//

#import "FlipsideViewController.h"

@interface FlipsideViewController ()

@end

@implementation FlipsideViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    score = 0;
    screenWidth  = [[UIScreen mainScreen] bounds].size.width;
    screenHeight = [[UIScreen mainScreen] bounds].size.height;
    
    speed = 0;
	
    _bgAnim = [[NSMutableArray alloc] init];
    _angryMeteorAnim = [[NSMutableArray alloc] init];
    _vampMeteorAnim = [[NSMutableArray alloc] init];
    
    for(int i=10; i<= 30; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"starrygamebg%d.png",i]];
        if(image != nil)
            [_bgAnim addObject:image];
    }
    
    for(int i=1; i<= 2; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"angrymeteor%d.png",i]];
        if(image != nil)
            [_angryMeteorAnim addObject:image];        
    }
    
    for(int i=1; i<= 2; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"vampire%d.png",i]];
        if(image != nil)
            [_vampMeteorAnim addObject:image];
    }
    
    _gameBg.animationImages = _bgAnim;
    _gameBg.animationDuration = 1;
    _gameBg.animationRepeatCount = -1;
    [_gameBg startAnimating];
    
    self.motionManager = [[CMMotionManager alloc] init];
    self.motionManager.deviceMotionUpdateInterval = 0.1;
    
    [self.motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^(CMDeviceMotion *deviceMotion, NSError *error) {
        [self update];
   }];
}

- (void)update {
    score++;
    speed+=.0001;
    
    float roll = _motionManager.deviceMotion.attitude.roll;

    _rocket.center = CGPointMake(screenWidth/2+(roll*100), _rocket.center.y);
    
    [_scoreLabel setText:[NSString stringWithFormat:@"%f",roll]];
    
}


#pragma mark - Actions

- (IBAction)done:(id)sender
{
    [self.delegate flipsideViewControllerDidFinish:self];
}

@end
