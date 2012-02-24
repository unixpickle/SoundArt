//
//  ANDrawnWave.h
//  SoundArt
//
//  Created by Alex Nichol on 2/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ANWaveGenerator.h"

struct _ANDrawnWavePoint {
    CGFloat amplitude;
    CGFloat x;
};

typedef struct _ANDrawnWavePoint ANDrawnWavePoint;

@interface ANDrawnWave : NSObject <ANWaveGenerator> {
    ANDrawnWavePoint * points;
    NSUInteger pointCount;
    NSUInteger allocCount;
}

+ (ANDrawnWave *)sineWaveWithWidth:(CGFloat)maxX;

- (void)addAmplitude:(CGFloat)amplitude forX:(CGFloat)x;
- (CGFloat)amplitudeForRelativeX:(CGFloat)x;

- (NSUInteger)numberOfPoints;
- (ANDrawnWavePoint)pointAtIndex:(NSUInteger)point;

- (void)addPointsToPath:(CGContextRef)context bounds:(CGRect)bounds;

@end
