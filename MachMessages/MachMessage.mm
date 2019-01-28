//
// Created by @RaniXCH on 2019-01-16.
//

#include "MachMessage.h"
#import "MachExceptions.h"
#import <mach/mach.h>

#define MACH_MODULE "MACH_MESSAGE"
MachMessage::MachMessage(MachConnection& machConnection, mach_msg_id_t msgId, mach_msg_bits_t msgBits) : machConnection(machConnection)
{
    this->machMessage = new mach_msg_header_t();
    this->machMessage->msgh_id = msgId;
    this->machMessage->msgh_bits = msgBits;

    this->msgDataList = MachMessageDataList();
}

void MachMessage::setLocalPort(MachPort& machPort)
{
    this->machMessage->msgh_local_port = mach_port_t(this->machConnection.getLocalPort());
}

void MachMessage::setRemotePort(MachPort& machPort)
{
    this->machMessage->msgh_remote_port = mach_port_t(this->machConnection.getServicePort());
}


const mach_msg_header_t *MachMessage::getMachMessage() const
{
    return machMessage;
}

const MachPort& MachMessage::getRemotePort() const
{
    return this->machConnection.getServicePort();
}

bool MachMessage::isComplex()
{
    return MACH_MSGH_BITS_IS_COMPLEX(this->machMessage->msgh_bits);
}

MachMessage::~MachMessage()
{
    DEBUG_LOG("MachMessage destructor");
    if(this->machMessagetoSend != NULL)
    {
        delete this->machMessagetoSend;
    }

    if(this->machMessage != NULL)
    {
        delete this->machMessage;
    }
}

MachMessage::operator mach_msg_header_t *()
{
    return this->machMessage;
}



void MachMessage::addData(MachMessageData& msgData)
{
    this->msgDataList.push_front(msgData);
}

void MachMessage::addRemotePortRight(mach_msg_type_name_t typeName)
{
    this->machConnection.getServicePort().InsertRight(typeName);
}


void MachMessage::addLocalPortRight(mach_msg_type_name_t typeName)
{
    this->machConnection.getLocalPort().InsertRight(typeName);
}


mach_msg_return_t MachMessage::sendMessage(MachConnection &machConnection)
{
    kern_return_t ret;
    this->setRemotePort(machConnection.getServicePort());
    this->setLocalPort(machConnection.getLocalPort());
    this->addLocalPortRight(MACH_MSG_TYPE_MAKE_SEND);
    mach_msg_header_t * mach_msg_header = this->buildMachMessage();

    DEBUG_LOG("Sending Mach Message 0x%x", mach_msg_header->msgh_size);
    typedef struct retMessage_t {
            mach_msg_header_t hdr;
            mach_msg_body_t body;
            mach_msg_port_descriptor_t port;
            mach_msg_ool_descriptor64_t ool;
            int a1;
            int a2;
            int size;
            long a3;
        } retMessage;


    retMessage* rMg = (retMessage*) mach_msg_header;
    ret = mach_msg(mach_msg_header, MACH_SEND_MSG, mach_msg_header->msgh_size,
                   0x00, MACH_PORT_NULL, MACH_MSG_TIMEOUT_NONE, MACH_PORT_NULL);



    MACH_LOG("Mach message sent");
    return ret;
}


mach_msg_return_t MachMessage::recvMessage(MachConnection &machConnection)
{
    kern_return_t ret;
    this->setRemotePort(machConnection.getServicePort());
    this->setLocalPort(machConnection.getLocalPort());

    
    mach_msg_header_t * mach_msg_header = this->buildMachMessage();
    DEBUG_LOG("Receiving Mach Message 0x%x", mach_msg_header->msgh_size);

    mach_msg_size_t receivedSize = mach_msg_header->msgh_size;
    ret = mach_msg(mach_msg_header, MACH_RCV_MSG | MACH_RCV_TIMEOUT, 0,
            mach_msg_header->msgh_size, mach_msg_header->msgh_local_port, 1000*3, MACH_PORT_NULL);

    mach_msg_header->msgh_size = receivedSize;
    MACH_LOG("Mach message receive");

    this->parseMessageReceived();
    return ret;
}



mach_msg_header_t *MachMessage::buildMachMessage()
{

    if(this->machMessagetoSend != NULL)
    {
        delete machMessagetoSend;
    }

    char* messageWriteSeek = NULL;
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

    for (MachMessageData& data: this->msgDataList)
    {
        memcpy(messageWriteSeek, data.getBuffer(), data.getBufferSize());
        messageWriteSeek += data.getBufferSize();
    }

    return this->machMessagetoSend;
}


mach_msg_size_t MachMessage::calculateMessageSize()
{
    mach_msg_size_t msgSize = sizeof(mach_msg_header_t);

    // Add the size of the out of line raw data
    for (MachMessageData& data: this->msgDataList)
    {
        msgSize += data.getBufferSize();
    }

    return msgSize;
}

const MachPort& MachMessage::getLocalPort()
{
    return this->machConnection.getLocalPort();
}

MachMessageDataList& MachMessage::getMessageDataList()
{
    return this->msgDataList;
}

void MachMessage::parseMessageReceived()
{
    if(this->machMessagetoSend != NULL)
    {
        this->msgDataList.clear();
        // Bytes left to read, already read message header
        mach_msg_size_t bytesLeft = this->machMessagetoSend->msgh_size - sizeof(mach_msg_header_t);
        char *messageData = (char*) this->machMessagetoSend;
        // Read the rest to message data,
        // Unfortunately if this is not complex message we cannot distinguish between data, so we have only one msgdata
        MachMessageData msgData = MachMessageData(messageData, bytesLeft);
        this->msgDataList.push_front(msgData);
    }
    else{
        throw MachMessageWasNotReceived();
    }
}

