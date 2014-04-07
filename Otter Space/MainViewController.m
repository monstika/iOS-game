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

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
        UITouch *touch = [touches anyObject];
        if ([touch view] == _playBtn)
            [self performSegueWithIdentifier:@"beginGame" sender:_playBtn];
}


#pragma mark - Flipside View

- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showAlternate"]) {
        [[segue destinationViewController] setDelegate:self];
    }
}

@end
