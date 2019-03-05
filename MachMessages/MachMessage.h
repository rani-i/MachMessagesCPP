//
// Created by @RaniXCH on 2019-01-16.
//

#pragma once

#import "MachPort.h"
#import <mach/mach.h>
#import "MachMessageData.h"
#import "MachMessageDescriptor.h"
#include <list>
#include "Logger.h"
#include "MachConnection.h"
#include <exception>


typedef std::list<std::reference_wrapper<MachMessageData>> MachMessageDataList;

class MachMessage
{
public:
    MachMessage(mach_msg_id_t msgId, mach_msg_bits_t msgBits);

    bool isComplex();

    ~MachMessage();

    void addData(MachMessageData& msgData);

    const mach_msg_header_t *getMachMessage() const;

    void addRemotePortRight(mach_msg_type_name_t typeName);

    void addLocalPortRight(mach_msg_type_name_t typeName);


    // TODO: Why sendMessage or recv need MAchConnection
    mach_msg_return_t sendMessage(MachConnection& machConnection);

    mach_msg_return_t recvMessage(MachConnection& machConnection);

    MachMessageDataList& getMessageDataList();

    operator mach_msg_header_t *();

    virtual mach_msg_header_t *buildMachMessage();

    virtual mach_msg_size_t calculateMessageSize();

    virtual void parseMessageReceived();

    static void AddPortRight(MachPort& machPort, mach_msg_type_name_t tyeName);

protected:
    mach_msg_header_t *machMessage;
    mach_msg_header_t *machMessagetoSend = NULL;
    MachMessageDataList msgDataList;

};


