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
const static int FASTER_POWERUP = 1, SLOWER_POWERUP = 2, INVINCIBLE_POWERUP = 3, MULTIPLY = 4, BONUS = 1000;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    srand([[NSDate date] timeIntervalSince1970]);
    
    //only one PowerUp on screen at a time
    currentPowerUp = nil;
    
    [AppDelegate appDelegate].score = 0;
    speed = 0;
    score = 0;
    
    //score multiplier
    multiplier = 1;
    
    countdown = 0;
    
    invincible = false;
    
    screenWidth  = [[UIScreen mainScreen] bounds].size.width;
    screenHeight = [[UIScreen mainScreen] bounds].size.height;
    
    _bgAnim =          [[NSMutableArray alloc] init];
    _otterAnim =       [[NSMutableArray alloc] init];
    _angryMeteorAnim = [[NSMutableArray alloc] init];
    _vampMeteorAnim =  [[NSMutableArray alloc] init];
    
    _enemies =         [[NSMutableArray alloc] init];
    _enemyHitboxes =   [[NSMutableArray alloc] init];
    
    _powerUp = [[UIImageView alloc] initWithFrame:CGRectMake(300, 300, 60, 60)];
    [_powerUp setImage:[UIImage imageNamed:@"turtle.png"]];
    [self resetPowerUp:rand()%200-800];
    [self.view addSubview:_powerUp];
    
    _otterHitbox = [[UIImageView alloc] initWithFrame:CGRectMake(_otter.center.x, _otter.center.y, _otter.frame.size.width-20, _otter.frame.size.height-20)];
    [_otterHitbox setContentMode: UIViewContentModeScaleAspectFit];
    [self.view addSubview:_otterHitbox];
    _otterAnim = [self loadImagesForFilename:@"otter" start:1 count:2];
 
    _otter.animationImages = _otterAnim;
    _otter.animationDuration = .4;
    _otter.animationRepeatCount = -1;
    [_otter startAnimating];
    
    _bgAnim = [self loadImagesForFilename:@"starrygamebg" start:10 count:20];
    _angryMeteorAnim = [self loadImagesForFilename:@"angrymeteor" start:1 count:2];
    _vampMeteorAnim = [self loadImagesForFilename:@"vampire" start:1 count:2];
 
    _gameBg.animationImages = _bgAnim;
    _gameBg.animationDuration = 1;
    _gameBg.animationRepeatCount = -1;
    [_gameBg startAnimating];
    
    [self setupEnemies];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"ShinyTech2" ofType:@"mp3"];
    NSURL *url = [NSURL fileURLWithPath:path];
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    [_player prepareToPlay];
    _player.numberOfLoops = -1;
    
    _powerUpLabel.font = [UIFont fontWithName:@"Minisystem-Regular" size:40];
    _countdownLabel.font = [UIFont fontWithName:@"Minisystem-Regular" size:40];
    
}

- (void)viewDidAppear:(BOOL)animated {
    self.motionManager = [[CMMotionManager alloc] init];
    self.motionManager.deviceMotionUpdateInterval = 1/60;
    
    [self.motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^(CMDeviceMotion *deviceMotion, NSError *error) {
        [self update];
    }];
    
    [_player play];
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
    
    //check if new xcor will move otter off screen
    if (x>30 && x<screenWidth-30){
        _otter.center = CGPointMake(x, _otter.center.y);
        _otterHitbox.center = CGPointMake(x, _otter.center.y);
    }
    
    [_scoreLabel setText:[NSString stringWithFormat:@"%d",score]];
    
    [self move];
    
}


- (void)move {
    [self checkCollision:_powerUp withHitbox:_powerUp withType:currentPowerUp];
  
    _powerUp.center = CGPointMake(_powerUp.center.x, _powerUp.center.y+1+speed);
    if (_powerUp.center.y > 800)
        [self resetPowerUp:rand()%200-800];
    
    for (int i = 0; i<[_enemies count]; i++) {
        UIImageView *meteor = _enemies[i];
        UIImageView *hitbox = _enemyHitboxes[i];
        meteor.center = CGPointMake(meteor.center.x, meteor.center.y+1+speed);
        hitbox.center = CGPointMake(meteor.center.x, meteor.center.y+30+speed);
        if (CGRectIntersectsRect(meteor.frame, _powerUp.frame))
            _powerUp.center = CGPointMake((int)(_powerUp.center.x+100)%screenWidth, _powerUp.center.y);
        [self checkCollision:meteor withHitbox:hitbox withType:ENEMY];
        if (meteor.center.y > 800)
            [self resetEnemy:meteor];
    }
}

- (void)checkCollision: (UIImageView*)object withHitbox:(UIImageView*)hitbox withType: (int)type{
    if(CGRectIntersectsRect(hitbox.frame,_otterHitbox.frame)) {
        switch (type) {
            case ENEMY:
                if (invincible){
                    [self resetEnemy:object];
                    [self resetInvincible];
                    break;
                }
                else {
                    [AppDelegate appDelegate].score = score;
                    [self die];
                    return;
                }
            case FASTER_POWERUP:
                [self setLabelText:@"FASTER!"];
                speed+=1;
                break;
            case SLOWER_POWERUP:
                [self setLabelText:@"SLOWER!"];
                speed-=1;
                break;
            case INVINCIBLE_POWERUP:
                [self setLabelText:@"SHIELD!"];
                [_otterHitbox setImage:[UIImage imageNamed:@"powerup3.png"]];
                invincible = YES;
                _otter.alpha = .5;
                break;
            case MULTIPLY:
                [self setLabelText:@"2x SCORE!"];
                multiplier = 2;
                [self startCountdownAt:5];
                [_multiplierTimer invalidate];
                _multiplierTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(resetInvincible) userInfo:nil repeats:NO];
                break;
            default:
                return;
        }
        if (type !=ENEMY)
             score += BONUS * multiplier;
        [self resetPowerUp:rand()%200-800];
    }
}


- (void) setLabelText: (NSString *) text {
    _powerUpLabel.alpha = 1;
    _powerUpLabel.text = text;
    [_labelTimer invalidate];
    _labelTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(hideLabel) userInfo:nil repeats:NO];
    
}

- (void) hideLabel {
    [UIView animateWithDuration:1 animations:^{
        _powerUpLabel.alpha=0;
    }];
}

- (void) startCountdownAt: (int) time {
    countdown = time;
    [_countdownTimer invalidate];
    [self updateCountdown];
    _countdownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateCountdown) userInfo:nil repeats:YES];
    
}

- (void) updateCountdown {
    if (countdown == 0){
       [ _countdownTimer invalidate];
        _countdownLabel.text = @"";
        return;
    }
    _countdownLabel.text = [NSString stringWithFormat:@"%d",countdown];
    countdown --;
}

- (void)resetInvincible {
    invincible = NO;
    _otter.alpha=1;
    [_otterHitbox setImage:nil];
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


- (void) resetPowerUp: (int)y{
    int x = rand()%(screenWidth-100)+50;
    _powerUp.center= CGPointMake(x, y);
    currentPowerUp = rand()%4 + 1;
    [_powerUp setImage:[UIImage imageNamed:[NSString stringWithFormat:@"powerup%d.png", currentPowerUp]]];
    switch (currentPowerUp) {
        case SLOWER_POWERUP:
            if (speed < 1)
                [self resetPowerUp:y];
            break;
        default:
            break;
    }
}

- (void) die {
    
    [_motionManager stopDeviceMotionUpdates];
    [self performSegueWithIdentifier:@"endGame" sender:self];
    [_player stop];

}

-(NSMutableArray*)loadImagesForFilename:(NSString *)filename start:(int)start count:(int)count {
    NSMutableArray *images = [NSMutableArray array];
    for(int i=start; i<= count; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%@%d.png", filename, i]];
        if(image != nil)
            [images addObject:image];
    }
    return images;
}


#pragma mark - Actions

- (IBAction)done:(id)sender
{
    [self.delegate flipsideViewControllerDidFinish:self];
}

@end
