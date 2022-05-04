#import "CicadaRenderCBWrapper.h"
#import <base/media/PBAFFrame.h>
#import "CicadaRenderDelegate.h"

//#include <utils/pixelBufferConvertor.h>

extern "C" {
#include <libswscale/swscale.h>
}

bool CicadaRenderCBWrapper::OnRenderFrame(void *userData, IAFFrame *frame)
{
    @autoreleasepool {
        id<CicadaRenderDelegate> delegate = (__bridge id<CicadaRenderDelegate>) userData;
        if (nullptr == delegate) {
            return false;
        }

        if (frame->getType() == IAFFrame::FrameTypeVideo) {
            switch (frame->getInfo().video.format) {
//                case AF_PIX_FMT_APPLE_PIXEL_BUFFER: { // 魔改 直接替换原CVPixelBufferRef
//                    auto *ppBFrame = dynamic_cast<PBAFFrame *>(frame);
//                    CVPixelBufferRef pixelBuffer = ppBFrame->getPixelBuffer();
//                    if ([delegate respondsToSelector:@selector(applyVideoPixelBuffer:pts:)]) {
//                        CVPixelBufferRef newPixelBuffer = [delegate applyVideoPixelBuffer:pixelBuffer pts:frame->getInfo().pts];
//                        ppBFrame->setPixelBuffer(newPixelBuffer);
//                    }
//                    return false
//                    break;
//                }
                case AF_PIX_FMT_APPLE_PIXEL_BUFFER: {
                    auto *ppBFrame = dynamic_cast<PBAFFrame *>(frame);
                    CVPixelBufferRef pixelBuffer = ppBFrame->getPixelBuffer();
                    if ([delegate respondsToSelector:@selector(onVideoPixelBuffer:pts:)]) {
                        return [delegate onVideoPixelBuffer:pixelBuffer pts:frame->getInfo().pts];
                    }
                    break;
                }
                case AF_PIX_FMT_YUV420P: // 魔改 将 YUV420P转成RGB再返回
                    if ([delegate respondsToSelector:@selector(onRGBVideoPixelBuffer:pts:)]) {
                        int imgWidth = frame->getInfo().video.width;
                        int imgHeight = frame->getInfo().video.height;
                        SwsContext * ctx = sws_getContext(imgWidth, imgHeight,
                                                          AV_PIX_FMT_RGB24, imgWidth, imgHeight,
                                                          AV_PIX_FMT_YUV420P, 0, 0, 0, 0);
                        uint8_t *rgb24Data = new uint8_t[3 * imgWidth * imgHeight];
                        uint8_t *inData[1] = { rgb24Data }; // RGB24 have one plane
                        int inLinesize[1] = { 3 * imgWidth }; // RGB stride
                        sws_scale(ctx, inData, inLinesize, 0, imgHeight, frame->getData(), frame->getLineSize());
                        
                        return [delegate onRGBVideoRawBuffer:rgb24Data lineSize:frame->getLineSize() pts:frame->getInfo().pts width:imgWidth height:imgHeight];
                    }
                    break;
//                case AF_PIX_FMT_YUV420P:
//                    if ([delegate respondsToSelector:@selector(onVideoPixelBuffer:pts:)]) {
//                        return [delegate onVideoRawBuffer:frame->getData()
//                                                 lineSize:frame->getLineSize()
//                                                      pts:frame->getInfo().pts
//                                                    width:frame->getInfo().video.width
//                                                   height:frame->getInfo().video.height];
//                    }
//                    break;
                default:
                    break;
            }
        }

        return false;
    }
}
