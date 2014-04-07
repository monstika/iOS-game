//
//  ScoreViewController.m
//  Otter Space
//
//  Created by Monika Tuchowska on 4/6/14.
//  Copyright (c) 2014 Monika Tuchowska. All rights reserved.
//

#import "ScoreViewController.h"

@interface ScoreViewController ()

@end

@implementation ScoreViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    int score = [AppDelegate appDelegate].score;
    [_scoreLabel setText:[NSString stringWithFormat:@"HIGH SCORE: %d", score]];
    [self checkHighScore:score];
   
}

- (void)checkHighScore: (int)score {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    int highScore = [prefs integerForKey: @"highScore"];
    if (score > highScore)
        [prefs setInteger: score forKey: @"highScore"];
    [prefs synchronize];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
