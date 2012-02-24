//
//  ANWaveDrawer.h
//  SoundArt
//
//  Created by Alex Nichol on 2/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ANDrawnWave.h"
#import "ANPointArray.h"

@class ANWaveDrawer;

@protocol ANWaveDrawerDelegate <NSObject>

@optional
- (void)waveDrawer:(ANWaveDrawer *)waveDrawer drewWave:(ANDrawnWave *)aWave;

@end

@interface ANWaveDrawer : UIView {
    ANDrawnWave * wave;
    
    CGFloat lastX;
    ANPointArray * touchPoints;
    
    __unsafe_unretained id<ANWaveDrawerDelegate> delegate;
}

@property (nonatomic, assign) id<ANWaveDrawerDelegate> delegate;

- (id)initWithFrame:(CGRect)frame;
- (void)setWave:(ANDrawnWave *)aWave;

@end
