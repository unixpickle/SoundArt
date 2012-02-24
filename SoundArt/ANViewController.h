//
//  ANViewController.h
//  SoundArt
//
//  Created by Alex Nichol on 2/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ANWaveDrawer.h"
#import "ANSampleOutput.h"

@interface ANViewController : UIViewController <ANWaveDrawerDelegate> {
    ANWaveDrawer * drawer;
    UISlider * frequency;
    UILabel * frequencyLabel;
    UIButton * sineButton;
    
    UINavigationBar * navBar;
    UINavigationItem * navItem;
    UIBarButtonItem * startButton;
    UIBarButtonItem * stopButton;
    
    NSThread * audioThread;
    ANSampleOutput * sampleOutput;
}

- (IBAction)frequencyChanged:(id)sender;
- (IBAction)startPlaying:(id)sender;
- (IBAction)stopPlaying:(id)sender;
- (IBAction)sineButton:(id)sender;

@end
