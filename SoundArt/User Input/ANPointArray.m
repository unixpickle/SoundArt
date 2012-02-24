//
//  ANPointArray.m
//  SoundArt
//
//  Created by Alex Nichol on 2/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ANPointArray.h"

#define kPointBufferSize 16

@implementation ANPointArray

- (id)init {
    if ((self = [super init])) {
        allocCount = kPointBufferSize;
        points = (CGPoint *)malloc(sizeof(CGPoint) * allocCount);
    }
    return self;
}

- (void)dealloc {
    free(points);
}

#pragma mark - Mutation -

- (void)addPoint:(CGPoint)aPoint {
    if (pointCount + 1 > allocCount) {
        allocCount += kPointBufferSize;
        points = (CGPoint *)realloc(points, sizeof(CGPoint) * allocCount);
    }
    points[pointCount++] = aPoint;
}

- (void)removePointAtIndex:(NSUInteger)index {
    NSUInteger writeIndex = 0;
    for (NSUInteger i = 0; i < pointCount; i++) {
        if (i != index) {
            points[writeIndex++] = points[i];
        }
    }
    pointCount = writeIndex;
}

- (void)popPointsToX:(CGFloat)x {
    while (pointCount > 0) {
        if (points[pointCount - 1].x >= x) {
            [self removePointAtIndex:pointCount - 1];
        } else break;
    }
}

#pragma mark - Access -

- (NSUInteger)numberOfPoints {
    return pointCount;
}

- (CGPoint)pointAtIndex:(NSUInteger)index {
    return points[index];
}

#pragma mark - Misc -

- (void)addPointsToPath:(CGContextRef)context {
    if (pointCount == 0) return;
    CGContextMoveToPoint(context, points[0].x, points[0].y);
    for (NSUInteger i = 1; i < pointCount; i++) {
        CGContextAddLineToPoint(context, points[i].x, points[i].y);
    }
}

- (ANDrawnWave *)normalizedWaveForHeight:(CGFloat)height {
    ANDrawnWave * wave = [[ANDrawnWave alloc] init];
    if (pointCount == 0) return wave;
    
    CGFloat minX = points[0].x;
    CGFloat maxX = points[pointCount - 1].x;
    CGFloat divisor = (maxX - minX != 0 ? maxX - minX : 1);
    for (NSUInteger i = 0; i < pointCount; i++) {
        CGFloat xValue = (points[i].x - minX) / divisor;
        CGFloat amplitude = (points[i].y - (height / 2)) / (height / 2);
        [wave addAmplitude:amplitude forX:xValue];
    }
    
    return wave;
}

@end
