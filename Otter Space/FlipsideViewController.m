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

const static int ENEMY = 0;
const static int FASTER_POWERUP = 1, SLOWER_POWERUP = 2, INVINCIBLE_POWERUP = 3;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    srand([[NSDate date] timeIntervalSince1970]);
    
    
    //only one PowerUp on screen at a time
    currentPowerUp = nil;
    
    score = 0;
    screenWidth  = [[UIScreen mainScreen] bounds].size.width;
    screenHeight = [[UIScreen mainScreen] bounds].size.height;
    
    speed = 0;
	
    _bgAnim = [[NSMutableArray alloc] init];
    _angryMeteorAnim = [[NSMutableArray alloc] init];
    _vampMeteorAnim = [[NSMutableArray alloc] init];
    
    _enemies = [[NSMutableArray alloc] init];
    _enemyHitboxes = [[NSMutableArray alloc] init];
    
    invincible = false;
    
    _powerUp = [[UIImageView alloc] initWithFrame:CGRectMake(300, 300, 30, 30)];
    [_powerUp setImage:[UIImage imageNamed:@"rocketz.bmp"]];
    [self.view addSubview:_powerUp];
    
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
        int x = rand() % (screenWidth-30);
        
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
        
        [self.view addSubview:meteor];
        [self.view addSubview:hitbox];
        
    }
}

- (void)update {
    score++;
    speed+=.0005;
    
    float roll = _motionManager.deviceMotion.attitude.roll;

    int x = screenWidth/2+(roll*175);
    
    //check if new xcor will move rocket off screen
    if (x>30 && x<screenWidth-30)
        _rocket.center = CGPointMake(x, _rocket.center.y);
    
    [_scoreLabel setText:[NSString stringWithFormat:@"%f",speed]];
    
    [self move];
    
}


- (void)move {
    [self checkCollision:_powerUp withType:INVINCIBLE_POWERUP];
  
    _powerUp.center = CGPointMake(screenWidth/2, _powerUp.center.y+1+speed);
    
    for (int i = 0; i<[_enemies count]; i++) {
        UIImageView *meteor = _enemies[i];
        UIImageView *hitbox = _enemyHitboxes[i];
   
        meteor.center = CGPointMake(meteor.center.x, meteor.center.y+1+speed);
        hitbox.center = CGPointMake(meteor.center.x, meteor.center.y+30+speed);
        [self checkCollision:hitbox withType:ENEMY];
        if (meteor.center.y > 800)
            [self resetEnemy:meteor];
    }
}

- (void)checkCollision: (UIImageView*)hitbox withType: (int)type{
    if(CGRectIntersectsRect(hitbox.frame,_rocket.frame)) {
        if (type == ENEMY && !invincible)
            [_scoreLabel setText:@"DEATHHHHHH!!!!!"];
            // [self performSegueWithIdentifier:@"gameOver" sender:self];
        else if (type == FASTER_POWERUP)
            speed+=.2;
        else if (type == SLOWER_POWERUP)
            speed-=.2;
        else if (type == INVINCIBLE_POWERUP) {
            invincible = YES;
            _rocket.alpha = .5;
        }
    }
    
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
