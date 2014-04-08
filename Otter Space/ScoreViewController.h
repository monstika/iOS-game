//
//  ScoreViewController.h
//  Otter Space
//
//  Created by Monika Tuchowska on 4/6/14.
//  Copyright (c) 2014 Monika Tuchowska. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface ScoreViewController : UIViewController
{
    int score;
}

@property (strong, nonatomic) IBOutlet UILabel *scoreLabel;
@property (strong, nonatomic) IBOutlet UILabel *highscoreLabel;
@property (strong, nonatomic) IBOutlet UILabel *menuBtn;

@end
