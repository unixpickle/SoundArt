//
//  ANSampleOutput.mm
//  SoundMaker
//
//  Created by Alex Nichol on 2/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ANSampleOutput.h"

@interface ANSampleOutput (Private)

- (void)queueToBuffer:(AudioQueueBufferRef)buffer;
- (void)configureChannelLayout;

@end

void ANSampleOutputBufferCallback (void * inUserData, AudioQueueRef inAQ, AudioQueueBufferRef inCompleteAQBuffer);

@implementation ANSampleOutput

- (id)initWithSampleRate:(NSUInteger)rate bufferTime:(NSTimeInterval)aPeriod {
    if ((self = [super init])) {
        sampleRate = rate;
        frequency = 600;
        // TODO: create sample buffer
        
        audioFormat.mFormatID = kAudioFormatLinearPCM;
        audioFormat.mChannelsPerFrame = 1;
        audioFormat.mBitsPerChannel = 8 * sizeof(Float32);
        audioFormat.mFramesPerPacket = 1;
        audioFormat.mSampleRate = rate;
        audioFormat.mBytesPerFrame = sizeof(Float32);
        audioFormat.mBytesPerPacket = sizeof(Float32);
        audioFormat.mFormatFlags = kAudioFormatFlagIsNonInterleaved | kAudioFormatFlagIsPacked | kAudioFormatFlagIsFloat;
        
        OSStatus status = AudioQueueNewOutput(&audioFormat, ANSampleOutputBufferCallback,
                                              (__bridge void *)self, CFRunLoopGetCurrent(),
                                              kCFRunLoopDefaultMode, 0, &audioQueue);
        if (status != noErr) {
            return nil;
        }
        
        framesPerBuffer = round((double)rate * aPeriod);
        
        for (int i = 0; i < kBufferCount; i++) {
            status = AudioQueueAllocateBuffer(audioQueue, sizeof(Float32) * framesPerBuffer, &buffers[i]);
            if (status != noErr) {
                for (int j = i - 1; j >= 0; j--) {
                    AudioQueueFreeBuffer(audioQueue, buffers[j]);
                }
                AudioQueueDispose(audioQueue, NO);
                return nil;
            }
        }
        
        sampleBuffer = [[ANSampleBuffer alloc] initWithSampleCount:framesPerBuffer rate:rate];
        sampleBuffer.waveGenerator = [[ANSineWaveGenerator alloc] init];
    }
    return self;
}

- (BOOL)startPlayer {
    for (int i = 0; i < kBufferCount; i++) {
        [self queueToBuffer:buffers[i]];
    }
    
    AudioQueueStart(audioQueue, NULL);
    AudioQueueSetParameter(audioQueue, kAudioQueueParam_Volume, 1.0);

    return YES;
}

- (void)stopPlayer {
    AudioQueueStop(audioQueue, YES);
}

- (void)setFrequency:(NSUInteger)number {
    NSDate * now = [NSDate date];
    NSTimeInterval time = [now timeIntervalSinceDate:lastUpdate];
    lastUpdate = now;
    // append old frequency buffer...
    [sampleBuffer appendSamplesForTime:time withFrequency:frequency];
    frequency = number;
}

- (void)setWaveGenerator:(id<ANWaveGenerator>)generator {
    [sampleBuffer setWaveGenerator:generator];
}

- (void)queueToBuffer:(AudioQueueBufferRef)buffer {
    Float32 * samples = (Float32 *)buffer->mAudioData;
    [sampleBuffer fillRemainingWithFrequency:frequency];
    [sampleBuffer setOffset:0];
    memcpy((void *)samples, (void *)sampleBuffer.samples, framesPerBuffer * audioFormat.mBytesPerFrame);
    
    buffer->mAudioDataByteSize = framesPerBuffer * audioFormat.mBytesPerFrame;

    AudioQueueEnqueueBuffer(audioQueue, buffer, 0, NULL);
}

@end

void ANSampleOutputBufferCallback (void * inUserData, AudioQueueRef inAQ, AudioQueueBufferRef inCompleteAQBuffer) {
    [(__bridge ANSampleOutput *)inUserData queueToBuffer:inCompleteAQBuffer];
}

