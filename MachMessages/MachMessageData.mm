//
// Created by @RaniXCH on 2019-01-17.
//

#include "MachMessageData.h"
#include "Logger.h"

MachMessageData::MachMessageData(void *dataBufToCopy, size_t sizeToCopy) {
    this->buffer = new unsigned char[sizeToCopy];
    this->bufferSize = sizeToCopy;
    memcpy(this->buffer, dataBufToCopy, sizeToCopy);
}

unsigned char *MachMessageData::getBuffer() const
{
    return buffer;
}

size_t MachMessageData::getBufferSize() const
{
    return bufferSize;
}

MachMessageData::~MachMessageData()
{
    DEBUG_LOG("MachMessageDtata destructor");
}
