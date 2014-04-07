//
//  MainViewController.m
//  Otter Space
//
//  Created by Monika Tuchowska on 4/6/14.
//  Copyright (c) 2014 Monika Tuchowska. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    _bgAnim = [[NSMutableArray alloc] init];
    
    for(int i=10; i<= 30; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"starrybg%d.png",i]];
        if(image != nil)
            [_bgAnim addObject:image];
            
    }
    
    _menuBg.animationImages = _bgAnim;
    _menuBg.animationDuration = 1;
    _menuBg.animationRepeatCount = -1;
    [_menuBg startAnimating];
    

}

- (void)viewDidAppear:(BOOL)animated {
    [self animateOtter];
    _otterMoveTimer = [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(animateOtter) userInfo:nil repeats:YES];
    
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
        UITouch *touch = [touches anyObject];
        if ([touch view] == _playBtn)
            [self performSegueWithIdentifier:@"beginGame" sender:_playBtn];
}

-(void) animateOtter {
    [UIView animateWithDuration:2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _otter.center = CGPointMake(_otter.center.x, _otter.center.y+20);
    } completion:^(BOOL finished){
        [UIView animateWithDuration:2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                _otter.center = CGPointMake(_otter.center.x, _otter.center.y-20);
        } completion:^(BOOL finished){}];
    }];
}

#pragma mark - Flipside View

- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [_otterMoveTimer invalidate];
    if ([[segue identifier] isEqualToString:@"showAlternate"]) {
        [[segue destinationViewController] setDelegate:self];
    }
}

@end
