//
//  ANDrawnWave.m
//  SoundArt
//
//  Created by Alex Nichol on 2/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ANDrawnWave.h"

#define kPointBufferSize 16

@implementation ANDrawnWave

#pragma mark - Initialization -

- (id)init {
    if ((self = [super init])) {
        allocCount = kPointBufferSize;
        points = (ANDrawnWavePoint *)malloc(sizeof(ANDrawnWavePoint) * allocCount);
    }
    return self;
}

+ (ANDrawnWave *)sineWaveWithWidth:(CGFloat)maxX {
    ANDrawnWave * wave = [[ANDrawnWave alloc] init];
    for (float i = 0; i <= 300; i++) {
        float value = sinf(i / 300.0f * M_PI * 2);
        float x = (i / 300.0f) * maxX;
        [wave addAmplitude:value forX:x];
    }
    return wave;
}

#pragma mark - Mutation -

- (void)addAmplitude:(CGFloat)amplitude forX:(CGFloat)x {
    ANDrawnWavePoint point;
    point.amplitude = amplitude;
    point.x = x;
    if (pointCount + 1 > allocCount) {
        allocCount += 16;
        points = (ANDrawnWavePoint *)realloc(points, sizeof(ANDrawnWavePoint) * allocCount);
    }
    points[pointCount++] = point;
}

#pragma mark - Access -

#pragma mark Raw

- (NSUInteger)numberOfPoints {
    @synchronized (self) {
        return pointCount;
    }
}

- (ANDrawnWavePoint)pointAtIndex:(NSUInteger)point {
    @synchronized (self) {
        return points[point];
    }
}

#pragma mark Amplitudes

- (CGFloat)amplitudeForRelativeX:(CGFloat)x {
    @synchronized (self) {
        for (NSUInteger i = 0; i < pointCount; i++) {
            if (points[i].x == x) {
                return points[i].amplitude;
            } else if (points[i].x > x) {
                if (i == 0) {
                    return points[i].amplitude;
                } else {
                    CGFloat lowAmp = points[i - 1].amplitude;
                    CGFloat highAmp = points[i].amplitude;
                    CGFloat lowX = points[i - 1].x;
                    CGFloat highX = points[i].x;
                    CGFloat percentage = (x - lowX) / (highX - lowX);
                    return lowAmp + (highAmp - lowAmp) * percentage;
                }
            }
        }
        return 0;
    }
}

- (Float32)amplitudeForX:(float *)x {
    @synchronized (self) {
        if (pointCount == 0) return 0;
        if (pointCount == 1) return points[0].amplitude;
        
        while (*x > 1) {
            *x -= 1;
        }
        
        CGFloat minX = points[0].x;
        CGFloat maxX = points[pointCount - 1].x;
        float relX = *x * (maxX - minX) + minX;
        return (Float32)[self amplitudeForRelativeX:relX];
    }
}

#pragma mark - Misc -

- (void)addPointsToPath:(CGContextRef)context bounds:(CGRect)bounds {
    if (pointCount > 0) {
        ANDrawnWavePoint point = points[0];
        CGFloat y = (point.amplitude * bounds.size.height / 2) + (bounds.size.height / 2);
        CGContextMoveToPoint(context, point.x * bounds.size.width + bounds.origin.x, y + bounds.origin.y);
    }
    
    for (NSUInteger i = 1; i < pointCount; i++) {
        ANDrawnWavePoint point = points[i];
        CGFloat y = (point.amplitude * bounds.size.height / 2) + (bounds.size.height / 2);
        CGContextAddLineToPoint(context, point.x * bounds.size.width + bounds.origin.x, y + bounds.origin.y);
    }
}

#pragma mark - Memory Management -

- (void)dealloc {
    free(points);
}

@end
