#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "GPUImageContext.h"
#import "GPUImageOutput.h"


@interface GPUImageMovieCustom : GPUImageOutput

- (void)processMovieFrame:(CVPixelBufferRef)movieFrame withSampleTime:(CMTime)currentSampleTime;

- (BOOL)processMovieFrame:(uint8_t **)buffer lineSize:(int32_t *)lineSize pts:(int64_t)pts width:(int32_t)width height:(int32_t)height withSampleTime:(CMTime)currentSampleTime;

@end
