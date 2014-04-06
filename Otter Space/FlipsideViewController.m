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
    
    [self.motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^(CMDeviceMotion *deviceMotion, NSError *error) { [self update];
   }];
}

- (void)update {
    float pitch = _motionManager.deviceMotion.attitude.pitch;

    _rocket.center = CGPointMake(pitch*100, _rocket.center.y);
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (IBAction)done:(id)sender
{
    [self.delegate flipsideViewControllerDidFinish:self];
}

@end
