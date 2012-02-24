//
//  ANViewController.m
//  SoundArt
//
//  Created by Alex Nichol on 2/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ANViewController.h"

@interface ANViewController (Private)

- (void)setupTitleBar;

- (void)audioThread;
- (void)setAudioFrequency:(NSNumber *)obj;
- (void)setAudioPlaying:(NSNumber *)flag;
- (void)setAudioGenerator:(id<ANWaveGenerator>)generator;

@end

@implementation ANViewController

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle -

- (void)viewDidLoad {
    [super viewDidLoad];
	
    drawer = [[ANWaveDrawer alloc] initWithFrame:CGRectMake(0, 200, 320, 102)];
    [drawer setDelegate:self];
    [self.view addSubview:drawer];
    
    [self setupTitleBar];
    
    sineButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [sineButton setTitle:@"Sine" forState:UIControlStateNormal];
    [sineButton addTarget:self action:@selector(sineButton:) forControlEvents:UIControlEventTouchUpInside];
    [sineButton setFrame:CGRectMake(320 - 100, 312, 90, 35)];
    [self.view addSubview:sineButton];
    
    frequency = [[UISlider alloc] initWithFrame:CGRectMake(10, 55, 300, 23)];
    [frequency setMinimumValue:100];
    [frequency setMaximumValue:900];
    [frequency setValue:440];
    [frequency addTarget:self action:@selector(frequencyChanged:) forControlEvents:UIControlEventValueChanged];
    
    frequencyLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 83, 300, 22)];
    [frequencyLabel setBackgroundColor:[UIColor clearColor]];
    [frequencyLabel setTextAlignment:UITextAlignmentCenter];
    [frequencyLabel setText:@"440Hz"];
    
    [self.view addSubview:frequency];
    [self.view addSubview:frequencyLabel];
    
    audioThread = [[NSThread alloc] initWithTarget:self selector:@selector(audioThread) object:nil];
    [audioThread start];
}

- (void)setupTitleBar {
    startButton = [[UIBarButtonItem alloc] initWithTitle:@"Start" style:UIBarButtonItemStylePlain
                                                  target:self action:@selector(startPlaying:)];
    stopButton = [[UIBarButtonItem alloc] initWithTitle:@"Stop" style:UIBarButtonItemStylePlain
                                                 target:self action:@selector(stopPlaying:)];
    
    navItem = [[UINavigationItem alloc] initWithTitle:@"Sound Art"];
    [navItem setRightBarButtonItem:startButton];
    
    navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    [navBar pushNavigationItem:navItem animated:NO];
    
    [self.view addSubview:navBar];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)waveDrawer:(ANWaveDrawer *)waveDrawer drewWave:(ANDrawnWave *)aWave {
    [self setAudioGenerator:aWave];
}

#pragma mark - UI Actions -

- (IBAction)frequencyChanged:(id)sender {
    float value = [frequency value];
    [self setAudioFrequency:[NSNumber numberWithFloat:value]];
    [frequencyLabel setText:[NSString stringWithFormat:@"%dHz", (int)round(value)]];
}

- (IBAction)startPlaying:(id)sender {
    [self setAudioPlaying:[NSNumber numberWithBool:YES]];
    [navItem setRightBarButtonItem:stopButton animated:YES];
}

- (IBAction)stopPlaying:(id)sender {
    [self setAudioPlaying:[NSNumber numberWithBool:NO]];
    [navItem setRightBarButtonItem:startButton animated:YES];
}

- (IBAction)sineButton:(id)sender {
    ANDrawnWave * sineDrawn = [ANDrawnWave sineWaveWithWidth:1];
    [drawer setWave:sineDrawn];
    [self setAudioGenerator:sineDrawn];
}

#pragma mark - Background -

- (void)audioThread {
    @autoreleasepool {
        sampleOutput = [[ANSampleOutput alloc] initWithSampleRate:11025 bufferTime:0.25];
        [sampleOutput setFrequency:440];
        [[NSRunLoop currentRunLoop] run];
    }
}

- (void)setAudioFrequency:(NSNumber *)obj {
    if ([NSThread currentThread] != audioThread) {
        [self performSelector:@selector(setAudioFrequency:)
                     onThread:audioThread
                   withObject:obj
                waitUntilDone:NO];
        return;
    }
    [sampleOutput setFrequency:[obj integerValue]];
}

- (void)setAudioPlaying:(NSNumber *)flag {
    if ([NSThread currentThread] != audioThread) {
        [self performSelector:@selector(setAudioPlaying:)
                     onThread:audioThread
                   withObject:flag
                waitUntilDone:NO];
        return;
    }
    if ([flag boolValue]) {
        [sampleOutput startPlayer];
    } else {
        [sampleOutput stopPlayer];
    }
}

- (void)setAudioGenerator:(id<ANWaveGenerator>)generator {
    if ([NSThread currentThread] != audioThread) {
        [self performSelector:@selector(setAudioGenerator:)
                     onThread:audioThread
                   withObject:generator
                waitUntilDone:NO];
        return;
    }
    [sampleOutput setWaveGenerator:generator];
}

@end
