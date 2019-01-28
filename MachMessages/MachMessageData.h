//
// Created by @RaniXCH on 2019-01-17.
//

#pragma once
#include <mach/mach.h>
#include <vector>


class MachMessageData {
public:
    MachMessageData(void* dataBufToCopy, size_t sizeToCopy);

    unsigned char *getBuffer() const;

    size_t getBufferSize() const;

    virtual ~MachMessageData();

private:
    unsigned char *buffer;
    size_t bufferSize;
//TODO: Should be tenmplate of struct or whatever instead of void*
};


