//
// Created by @RaniXCH on 2019-01-17.
//
#pragma once

#include "MachMessage.h"
#include "MachMessageDescriptor.h"
#include <list>

typedef std::list<std::reference_wrapper<MachMessageDescriptor>> MachMessageDescriptorList;

class MachMessageComplex : public MachMessage {
public:
    MachMessageComplex(MachConnection& machConnection, mach_msg_id_t msgId, mach_msg_bits_t msgBits);
    void addDescriptor(MachMessageDescriptor& msgDescriptor);
    mach_msg_header_t* buildMachMessage() override;
    ~MachMessageComplex();
    mach_msg_size_t calculateMessageSize() override;

    MachMessageDescriptorList& getMachMessageDescriptorList();

    void parseMessageReceived() override;


private:
    MachMessageDescriptorList msgDescriptors;
};


