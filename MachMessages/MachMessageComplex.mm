//
// Created by @RaniXCH on 2019-01-17.
//

#include "MachMessageComplex.h"
#import "MachExceptions.h"



MachMessageComplex::MachMessageComplex(MachConnection& machConnection, mach_msg_id_t msgId,
                                       mach_msg_bits_t msgBits) : MachMessage(msgId, msgBits),
                                       msgDescriptors(MachMessageDescriptorList()){

    if(!MACH_MSGH_BITS_IS_COMPLEX(msgBits))
    {
        throw MachMessageComplexMessageIsNotComplex();
    }

    this->msgDataList = MachMessageDataList();
}
void MachMessageComplex::addDescriptor(MachMessageDescriptor& msgDescriptor)
{
    this->msgDescriptors.push_front(msgDescriptor);
}


mach_msg_header_t *MachMessageComplex::buildMachMessage()
{
    char* messageWriteSeek = NULL;

    if(this->machMessagetoSend != NULL)
    {
        delete machMessagetoSend;
    }

    mach_msg_size_t  sizeToAllocate = this->calculateMessageSize();

    // Allocate - free on destructor
    this->machMessagetoSend = (mach_msg_header_t*) operator new(sizeToAllocate);
    bzero(this->machMessagetoSend, sizeToAllocate);

    messageWriteSeek = (char*)this->machMessagetoSend;
    // copy mach_msg_header_t to seek
    mach_msg_header_t * message = (mach_msg_header_t*)messageWriteSeek;
    *message = *this->machMessage;

    // Set message size
    message->msgh_size = sizeToAllocate;

    messageWriteSeek+= sizeof(mach_msg_header_t);

    // Copy mach_msg_body_t and set it to number of complex descriptors
    (*(mach_msg_body_t*)messageWriteSeek).msgh_descriptor_count = (mach_msg_size_t)this->msgDescriptors.size();
    messageWriteSeek+= sizeof(mach_msg_body_t);

    // Copy descriptor objects if exist
    // Add the size of descriptors
    for (MachMessageDescriptor& descriptor : this->msgDescriptors)
    {
        memcpy(messageWriteSeek, descriptor.getPtr(), descriptor.getSize());
        messageWriteSeek += descriptor.getSize();
    }
    for (MachMessageData& data: this->msgDataList)
    {
        memcpy(messageWriteSeek, data.getBuffer(), data.getBufferSize());
        messageWriteSeek += data.getBufferSize();
    }

    return this->machMessagetoSend;
}

MachMessageComplex::~MachMessageComplex()
{
    DEBUG_LOG("MachMessageComplex destructor");
}

mach_msg_size_t MachMessageComplex::calculateMessageSize()
{
    mach_msg_size_t msgSize = sizeof(mach_msg_header_t);

    // Add the size of mach_msg_body_t in case we have complex descriptors and set mach_msg_body_t
    msgSize += sizeof(mach_msg_body_t);

    // Add the size of descriptors
    for (MachMessageDescriptor& descriptor : this->msgDescriptors)
    {
        msgSize += descriptor.getSize();
    }

    // Add the size of the out of line raw data
    for (MachMessageData& data: this->msgDataList)
    {
        msgSize += data.getBufferSize();
    }

    return msgSize;
}

void MachMessageComplex::parseMessageReceived()
{
    if(this->machMessagetoSend != NULL)
    {
        this->msgDataList.clear();
        // Bytes left to read, already read message header
        mach_msg_size_t bytesLeft = this->machMessagetoSend->msgh_size - sizeof(mach_msg_header_t);
        char *messagePtr = (char*) this->machMessagetoSend;

        mach_msg_body_t* msg_body = (mach_msg_body_t*) messagePtr;
        size_t numberOfComplexElements = msg_body->msgh_descriptor_count;

        messagePtr += sizeof(mach_msg_body_t);
        bytesLeft -= sizeof(mach_msg_body_t);

        for (int i = 0; i < numberOfComplexElements; ++i)
        {
            mach_msg_descriptor_t* descriptorType = (mach_msg_descriptor_t*) messagePtr;
            MachMessageDescriptor * msgDescriptor;

            mach_msg_descriptor_type_t type = descriptorType->type.type;
            switch(type)
            {
                case OOL_DESCRIPTOR:
                {
                    mach_msg_ool_descriptor64_t *oolDescriptor = (mach_msg_ool_descriptor64_t *) messagePtr;
                    msgDescriptor = new MachMessageOOLDescriptor((void *) oolDescriptor->address, oolDescriptor->size
                                                                 , oolDescriptor->deallocate, oolDescriptor->copy);
                    break;
                }
                case PORT_DESCRIPTOR:
                {
                    mach_msg_port_descriptor_t *portDescriptor = (mach_msg_port_descriptor_t *) messagePtr;
                    MachPort msgPort = MachPort(portDescriptor->name);
                    msgDescriptor = new MachMessagePortDescriptor(msgPort, portDescriptor->type
                                                                  , portDescriptor->disposition);
                    break;
                }
                default:
                    throw MachMessageUndefinedDescriptor();
            }

            this->msgDescriptors.push_front(*msgDescriptor);
            messagePtr += sizeof(mach_msg_descriptor_t);
            bytesLeft -= sizeof(mach_msg_descriptor_t);
        }
        messagePtr += sizeof(mach_msg_header_t);
        // Read the rest to message data,
        // Unfortunately if this is not complex message we cannot distinguish between data, so we have only one msgdata
        MachMessageData msgData = MachMessageData(messagePtr, bytesLeft);
        this->msgDataList.push_front(msgData);
    }
    else{
        throw MachMessageWasNotReceived();
    }
}

MachMessageDescriptorList &MachMessageComplex::getMachMessageDescriptorList()
{
    return this->msgDescriptors;
}

