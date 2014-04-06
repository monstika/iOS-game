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
    
    srand([[NSDate date] timeIntervalSince1970]);
    
    score = 0;
    screenWidth  = [[UIScreen mainScreen] bounds].size.width;
    screenHeight = [[UIScreen mainScreen] bounds].size.height;
    
    speed = 0;
	
    _bgAnim = [[NSMutableArray alloc] init];
    _angryMeteorAnim = [[NSMutableArray alloc] init];
    _vampMeteorAnim = [[NSMutableArray alloc] init];
    
    _enemies = [[NSMutableArray alloc] init];
    _enemyHitboxes = [[NSMutableArray alloc] init];
    
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
    
 
    
    [self setupEnemies];
    

    
    
}

- (void)viewDidAppear:(BOOL)animated {
    self.motionManager = [[CMMotionManager alloc] init];
    self.motionManager.deviceMotionUpdateInterval = 1/60;
    
    [self.motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^(CMDeviceMotion *deviceMotion, NSError *error) {
        [self update];
    }];
    
 
}

- (void)setupEnemies {
    
    for (int i = 0; i<5; i++){
        int x = rand() % (screenWidth);
        
        UIImageView *meteor = [[UIImageView alloc] initWithFrame:CGRectMake(x, -125-200*i, 78, 125)];
        UIImageView *hitbox = [[UIImageView alloc] initWithFrame:CGRectMake(x, -125-200*i, 54, 54)];
        
        if (x%2==1)
            meteor.animationImages = _angryMeteorAnim;
        else
            meteor.animationImages = _vampMeteorAnim;
        meteor.animationDuration = .2;
        meteor.animationRepeatCount = -1;
        [meteor startAnimating];
        
        [_enemies addObject:meteor];
        [_enemyHitboxes addObject:hitbox];
        
        int count = [_enemies count];
        
        [self.view addSubview:meteor];
        [self.view addSubview:hitbox];
        
    }
}

- (void)update {
    score++;
    speed+=.0005;
    
    float roll = _motionManager.deviceMotion.attitude.roll;

    _rocket.center = CGPointMake(screenWidth/2+(roll*175), _rocket.center.y);
    
    
    [_scoreLabel setText:[NSString stringWithFormat:@"%f",speed]];
    
    [self move];
    
}

- (void)moveb {
    for (UIImageView *enemy in _enemies)
        enemy.center = CGPointMake(enemy.center.x, enemy.center.y+1);
}

- (void)move {
    for (int i = 0; i<[_enemies count]; i++) {
        UIImageView *meteor = _enemies[i];
        UIImageView *hitbox = _enemyHitboxes[i];
        int meteorspeed = (rand()%4)/10;
        meteor.center = CGPointMake(meteor.center.x, meteor.center.y+1+speed);
        hitbox.center = CGPointMake(meteor.center.x, meteor.center.y+30+speed);
        [self checkCollision:hitbox];
        if (meteor.center.y > 800)
            [self resetEnemy:meteor];
    }
}

- (void)checkCollision: (UIImageView*)hitbox {
    if(CGRectIntersectsRect(hitbox.frame,_rocket.frame))
        [_scoreLabel setText:@"DEATHHHHHH!!!!!"];
       // [self performSegueWithIdentifier:@"gameOver" sender:self];
}

- (void)resetEnemy: (UIImageView*)meteor {
    int x = rand()%(screenWidth);
  //  int y = rand()%100 -150;
    int y = -125;
    meteor.center = CGPointMake(x, y);
    
    [meteor stopAnimating];
    if (rand()%2==1)
        meteor.animationImages = _angryMeteorAnim;
    else
        meteor.animationImages = _vampMeteorAnim;
    [meteor startAnimating];
    
}


#pragma mark - Actions

- (IBAction)done:(id)sender
{
    [self.delegate flipsideViewControllerDidFinish:self];
}

@end
