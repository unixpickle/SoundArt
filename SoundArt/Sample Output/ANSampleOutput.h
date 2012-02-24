//
//  ANSampleOutput.h
//  SoundMaker
//
//  Created by Alex Nichol on 2/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <AudioToolbox/AudioToolbox.h>
#import "ANSampleBuffer.h"
#import "ANSineWaveGenerator.h"

#define kBufferCount 4

@interface ANSampleOutput : NSObject {
    AudioStreamBasicDescription audioFormat;
    AudioQueueRef audioQueue;
    AudioQueueBufferRef buffers[kBufferCount];
    
    NSUInteger sampleRate;
    UInt32 framesPerBuffer;
    
    NSUInteger frequency;
    ANSampleBuffer * sampleBuffer;
    NSDate * lastUpdate;
}

- (id)initWithSampleRate:(NSUInteger)rate bufferTime:(NSTimeInterval)aPeriod;

- (BOOL)startPlayer;
- (void)stopPlayer;

- (void)setFrequency:(NSUInteger)frequency;
- (void)setWaveGenerator:(id<ANWaveGenerator>)generator;

@end
