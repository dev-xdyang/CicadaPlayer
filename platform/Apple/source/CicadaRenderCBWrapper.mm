#import "CicadaRenderCBWrapper.h"
#import <base/media/PBAFFrame.h>
#import "CicadaRenderDelegate.h"

#include <utils/pixelBufferConvertor.h>
#include <base/media/AVAFPacket.h>

extern "C" {
#include <libswscale/swscale.h>
}

Cicada::pixelBufferConvertor *renderConvertor;

bool CicadaRenderCBWrapper::OnRenderFrame(void *userData, IAFFrame *frame)
{
    @autoreleasepool {
        id<CicadaRenderDelegate> delegate = (__bridge id<CicadaRenderDelegate>) userData;
        if (nullptr == delegate) {
            return false;
        }

        if (frame->getType() == IAFFrame::FrameTypeVideo) {
            switch (frame->getInfo().video.format) {
                case AF_PIX_FMT_APPLE_PIXEL_BUFFER: {
                    auto *ppBFrame = dynamic_cast<PBAFFrame *>(frame);
                    CVPixelBufferRef pixelBuffer = ppBFrame->getPixelBuffer();
                    if ([delegate respondsToSelector:@selector(onVideoPixelBuffer:pts:)]) {
                        return [delegate onVideoPixelBuffer:pixelBuffer pts:frame->getInfo().pts];
                    }
                    break;
                }
                case AF_PIX_FMT_YUV420P: { // 魔改 将 YUV420P转成RGB再返回
                    auto *avBFrame = dynamic_cast<AVAFFrame *>(frame);
                    if (avBFrame != nullptr && ([delegate respondsToSelector:@selector(onVideoPixelBuffer:pts:)])) {
                        if (renderConvertor == NULL) {
                            renderConvertor = new Cicada::pixelBufferConvertor();
                        }
                        IAFFrame *newFrame = renderConvertor->convert(frame);
                        auto *ppBFrame = dynamic_cast<PBAFFrame *>(newFrame);
                        if (ppBFrame != nullptr) {
                            CVPixelBufferRef pixelBuffer = ppBFrame->getPixelBuffer();
                            bool result = [delegate onVideoPixelBuffer:pixelBuffer pts:frame->getInfo().pts];
                            CFRelease(pixelBuffer);
                            return result;
                        }
                    }
                    break;
                }
                default:
                    break;
            }
        }

        return false;
    }
}

//
//
//bool CicadaRenderCBWrapper::OnRenderFrame(void *userData, IAFFrame *frame)
//{
//    @autoreleasepool {
//        id<CicadaRenderDelegate> delegate = (__bridge id<CicadaRenderDelegate>) userData;
//        if (nullptr == delegate) {
//            return false;
//        }
//
//        if (frame->getType() == IAFFrame::FrameTypeVideo) {
//            switch (frame->getInfo().video.format) {
////                case AF_PIX_FMT_APPLE_PIXEL_BUFFER: { // 魔改 直接替换原CVPixelBufferRef
////                    auto *ppBFrame = dynamic_cast<PBAFFrame *>(frame);
////                    CVPixelBufferRef pixelBuffer = ppBFrame->getPixelBuffer();
////                    if ([delegate respondsToSelector:@selector(applyVideoPixelBuffer:pts:)]) {
////                        CVPixelBufferRef newPixelBuffer = [delegate applyVideoPixelBuffer:pixelBuffer pts:frame->getInfo().pts];
////                        ppBFrame->setPixelBuffer(newPixelBuffer);
////                    }
////                    return false
////                    break;
////                }
//                case AF_PIX_FMT_APPLE_PIXEL_BUFFER: {
//                    auto *ppBFrame = dynamic_cast<PBAFFrame *>(frame);
//                    CVPixelBufferRef pixelBuffer = ppBFrame->getPixelBuffer();
//                    if ([delegate respondsToSelector:@selector(onVideoPixelBuffer:pts:)]) {
//                        return [delegate onVideoPixelBuffer:pixelBuffer pts:frame->getInfo().pts];
//                    }
//                    break;
//                }
//                case AF_PIX_FMT_YUV420P: // 魔改 将 YUV420P转成RGB再返回
//                    auto *avBFrame = dynamic_cast<AVAFFrame *>(frame);
//                    if (avBFrame != nullptr && ([delegate respondsToSelector:@selector(onVideoPixelBuffer:pts:)])) {
//                        if (renderConvertor == NULL) {
//                            renderConvertor = new Cicada::pixelBufferConvertor();
//                        }
//                        IAFFrame *newFrame = renderConvertor->convert(frame);
//                        auto *ppBFrame = dynamic_cast<PBAFFrame *>(newFrame);
//                        if (ppBFrame != nullptr) {
//                            CVPixelBufferRef pixelBuffer = ppBFrame->getPixelBuffer();
//                            bool result = [delegate onVideoPixelBuffer:pixelBuffer pts:frame->getInfo().pts];
//                            CFRelease(pixelBuffer);
//                            return result;
//                        }
//                    }
//                    break;
////                case AF_PIX_FMT_YUV420P:
////                    if ([delegate respondsToSelector:@selector(onVideoPixelBuffer:pts:)]) {
////                        return [delegate onVideoRawBuffer:frame->getData()
////                                                 lineSize:frame->getLineSize()
////                                                      pts:frame->getInfo().pts
////                                                    width:frame->getInfo().video.width
////                                                   height:frame->getInfo().video.height];
////                    }
////                    break;
//                default:
//                    break;
//            }
//        }
//
//        return false;
//    }
//}
