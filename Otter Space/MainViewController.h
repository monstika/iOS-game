//
//  MainViewController.h
//  Otter Space
//
//  Created by Monika Tuchowska on 4/6/14.
//  Copyright (c) 2014 Monika Tuchowska. All rights reserved.
//

#import "FlipsideViewController.h"

@interface MainViewController : UIViewController <FlipsideViewControllerDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *menuBg;
@property (strong, nonatomic) IBOutlet UIImageView *playBtn;

@property (strong, nonatomic) NSMutableArray *bgAnim;

@end
