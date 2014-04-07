//
//  FlipsideViewController.h
//  Otter Space
//
//  Created by Monika Tuchowska on 4/6/14.
//  Copyright (c) 2014 Monika Tuchowska. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>
#import <AVFoundation/AVFoundation.h>
#import "ScoreViewController.h"
#import "AppDelegate.h"

@class FlipsideViewController;

@protocol FlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller;
@end

@interface FlipsideViewController : UIViewController {
    int score, multiplier, currentPowerUp;
    int screenWidth, screenHeight;
    float speed;
    bool invincible;
}
@property (strong, nonatomic) IBOutlet UILabel *powerUpLabel;

@property (strong, nonatomic) AVAudioPlayer *player;

@property (strong, nonatomic) IBOutlet UILabel *scoreLabel;

@property (weak, nonatomic) id <FlipsideViewControllerDelegate> delegate;
@property (strong, nonatomic) IBOutlet UIImageView *gameBg, *powerUp;

@property (strong, nonatomic) NSMutableArray *bgAnim, *otterAnim, *angryMeteorAnim, *vampMeteorAnim;
@property (strong, nonatomic) NSMutableArray *enemies, *enemyHitboxes, *coins;

@property (strong, nonatomic) CMMotionManager *motionManager;

@property (strong, nonatomic) IBOutlet UIImageView *otter, *otterHitbox;
@property (strong, nonatomic) NSTimer *labelTimer, *invincibilityTimer, *multiplierTimer;

- (IBAction)done:(id)sender;

@end
