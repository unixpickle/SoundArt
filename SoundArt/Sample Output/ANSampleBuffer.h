//
//  ANSampleBuffer.h
//  SoundMaker
//
//  Created by Alex Nichol on 2/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ANWaveGenerator.h"

@interface ANSampleBuffer : NSObject {
    Float32 * samples;
    NSUInteger sampleCount;
    NSUInteger sampleRate;
    NSUInteger offset;
    float xValue;
    id<ANWaveGenerator> waveGenerator;
}

@property (readonly) Float32 * samples;
@property (readonly) NSUInteger sampleCount;
@property (readonly) NSUInteger sampleRate;
@property (readwrite) NSUInteger offset;
@property (nonatomic, strong) id<ANWaveGenerator> waveGenerator;

- (id)initWithSampleCount:(NSUInteger)count rate:(NSUInteger)rate;
- (void)appendSamples:(NSUInteger)count withFrequency:(NSInteger)frequency;
- (void)appendSamplesForTime:(NSTimeInterval)time withFrequency:(NSInteger)frequency;
- (void)fillRemainingWithFrequency:(NSInteger)frequency;

@end
