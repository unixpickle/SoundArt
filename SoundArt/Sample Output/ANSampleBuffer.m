//
//  ANSampleBuffer.m
//  SoundMaker
//
//  Created by Alex Nichol on 2/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ANSampleBuffer.h"

@implementation ANSampleBuffer

@synthesize samples;
@synthesize sampleCount;
@synthesize sampleRate;
@synthesize offset;
@synthesize waveGenerator;

- (id)initWithSampleCount:(NSUInteger)count rate:(NSUInteger)rate {
    if ((self = [super init])) {
        samples = (Float32 *)malloc(sizeof(Float32) * count);
        sampleCount = count;
        sampleRate = rate;
    }
    return self;
}

- (void)appendSamples:(NSUInteger)count withFrequency:(NSInteger)frequency {
    if (count + offset > sampleCount) {
        count = sampleCount - offset;
    }
    for (NSUInteger i = offset; i < offset + count; i++) {
        samples[i] = [waveGenerator amplitudeForX:&xValue];
        xValue += (Float32)frequency / (Float32)sampleRate;
    }
    offset += count;
}

- (void)appendSamplesForTime:(NSTimeInterval)time withFrequency:(NSInteger)frequency {
    NSUInteger count = round(time * (double)sampleRate);
    [self appendSamples:count withFrequency:frequency];
}

- (void)fillRemainingWithFrequency:(NSInteger)frequency {
    for (NSUInteger i = offset; i < sampleCount; i++) {
        samples[i] = [waveGenerator amplitudeForX:&xValue];
        xValue += (Float32)frequency / (Float32)sampleRate;
    }
    offset = sampleCount;
}

- (void)dealloc {
    free(samples);
}

@end
