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
const static int FASTER_POWERUP = 1, SLOWER_POWERUP = 2, INVINCIBLE_POWERUP = 3, MULTIPLY = 4, BONUS = 500;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    srand([[NSDate date] timeIntervalSince1970]);
    
    //only one PowerUp on screen at a time
    currentPowerUp = nil;
    [AppDelegate appDelegate].score = 0;
    
    speed = 0;
    score = 0;
    
    multiplier = 1;
    screenWidth  = [[UIScreen mainScreen] bounds].size.width;
    screenHeight = [[UIScreen mainScreen] bounds].size.height;
    
    _bgAnim =          [[NSMutableArray alloc] init];
    _angryMeteorAnim = [[NSMutableArray alloc] init];
    _vampMeteorAnim =  [[NSMutableArray alloc] init];
    
    _enemies =         [[NSMutableArray alloc] init];
    _enemyHitboxes =   [[NSMutableArray alloc] init];
    _coins =           [[NSMutableArray alloc]init];
    
    invincible = false;
    
    _powerUp = [[UIImageView alloc] initWithFrame:CGRectMake(300, 300, 40, 40)];
    [_powerUp setImage:[UIImage imageNamed:@"rocketz.bmp"]];
    [self resetPowerUp:rand()%200-800];
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
    score+= multiplier;
    speed+=.0005;
    
    float roll = _motionManager.deviceMotion.attitude.roll;

    int x = screenWidth/2+(roll*175);
    
    //check if new xcor will move rocket off screen
    if (x>30 && x<screenWidth-30)
        _rocket.center = CGPointMake(x, _rocket.center.y);
    
    [_scoreLabel setText:[NSString stringWithFormat:@"%d",score]];
    
    [self move];
    
}


- (void)move {
    [self checkCollision:_powerUp withType:currentPowerUp];
  
    _powerUp.center = CGPointMake(screenWidth/2, _powerUp.center.y+1+speed);
    if (_powerUp.center.y > 800)
        [self resetPowerUp:rand()%200-800];
    
    for (int i = 0; i<[_enemies count]; i++) {
        UIImageView *meteor = _enemies[i];
        UIImageView *hitbox = _enemyHitboxes[i];
        meteor.center = CGPointMake(meteor.center.x, meteor.center.y+1+speed);
        hitbox.center = CGPointMake(meteor.center.x, meteor.center.y+30+speed);
        if (CGRectIntersectsRect(meteor.frame, _powerUp.frame))
            _powerUp.center = CGPointMake((int)(_powerUp.center.x+100)%screenWidth, _powerUp.center.y);
        [self checkCollision:hitbox withType:ENEMY];
        if (meteor.center.y > 800)
            [self resetEnemy:meteor];
    }
}

- (void)checkCollision: (UIImageView*)hitbox withType: (int)type{
    
    if(CGRectIntersectsRect(hitbox.frame,_rocket.frame)) {
        
        if (type == ENEMY && !invincible) {
            //[_scoreLabel setText:@"DEATHHHHHH!!!!!"];
            [AppDelegate appDelegate].score = score;
            [self performSegueWithIdentifier:@"endGame" sender:self];
            return;
        }
        else switch (type) {
            NSLog([NSString stringWithFormat:@"COLLIDED: %d",currentPowerUp]);
            case FASTER_POWERUP:
                speed+=1;
                break;
            case SLOWER_POWERUP:
                speed-=1;
                break;
            case INVINCIBLE_POWERUP:
                invincible = YES;
                _rocket.alpha = .5;
                [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(resetInvincible) userInfo:nil repeats:NO];
                break;
            case MULTIPLY:
                multiplier = 2;
                [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(resetInvincible) userInfo:nil repeats:NO];
                break;
            default:
                return;
        }
        score += BONUS * multiplier;
        [self resetPowerUp:rand()%200-800];
    }
    
}

- (void)resetInvincible {
    invincible = NO;
    _rocket.alpha=1;
}

- (void)resetMultiplier {
    multiplier = 1;
}

- (void)resetEnemy: (UIImageView*)meteor {
  
    int x = rand()%(screenWidth);
    int y = -125;
    meteor.center = CGPointMake(x, y);
    
    [meteor stopAnimating];
    if (rand()%2==1)
        meteor.animationImages = _angryMeteorAnim;
    else
        meteor.animationImages = _vampMeteorAnim;
    [meteor startAnimating];
    
}

/*
-(void)animate {
    [UIView animateWithDuration:2.0 animations:^{
        _powerUpLabel.alpha = .8;
    }completion:^(BOOL finished) {
        [UIView animateWithDuration:3.0 animations:^{
            _powerUpLabel.alpha = 0;
        }];
    }];
}
 */

- (void) resetPowerUp: (int)y{
    int x = rand()%(screenWidth-100)+50;
    _powerUp.center= CGPointMake(x, y);
    currentPowerUp = rand()%4 + 1;
    switch (currentPowerUp) {
        case SLOWER_POWERUP:
            //[_powerUpLabel setImage:[UIImage imageNamed:@"slow.png"]];
            // [self animate];
            if (speed < 1)
                [self resetPowerUp:y];
            [_powerUp setImage:[UIImage imageNamed:@"rocketz.bmp"]];
            break;
        default:
            break;
    }
  //  NSLog([NSString stringWithFormat:@"RESET POWERUP TO: %d", currentPowerUp]);
}


#pragma mark - Actions

- (IBAction)done:(id)sender
{
    [self.delegate flipsideViewControllerDidFinish:self];
}

@end
