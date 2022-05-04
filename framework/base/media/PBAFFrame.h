//
// Created by moqi on 2019-08-28.
//

#ifndef CICADA_PLAYER_PBAFFRAME_H
#define CICADA_PLAYER_PBAFFRAME_H

#include "base/media/IAFPacket.h"
#include <CoreMedia/CoreMedia.h>
#include <utils/AFMediaType.h>

class AVAFFrame;

class PBAFFrame : public IAFFrame {
public:
    PBAFFrame(CVPixelBufferRef pixelBuffer, int64_t pts, int64_t duration);

    ~PBAFFrame() override
    {
        CVPixelBufferRelease(mPBuffer);
    }

    FrameType getType() override
    {
        return FrameTypeVideo;
    };

    uint8_t **getData() override
    {
        return nullptr;
    }

    int *getLineSize() override
    {
        return nullptr;
    }

    CVPixelBufferRef getPixelBuffer()
    {
        return mPBuffer;
    }
    
    void setPixelBuffer(CVPixelBufferRef buffer)
    {
        CVPixelBufferRetain(buffer);
        CVPixelBufferRelease(mPBuffer);
        mPBuffer = buffer;
    }

    std::unique_ptr<IAFFrame> clone() override
    {
        return nullptr;
    }

    explicit operator AVAFFrame *();

    
    CVPixelBufferRef mPBuffer;


};


#endif //CICADA_PLAYER_PBAFFRAME_H
