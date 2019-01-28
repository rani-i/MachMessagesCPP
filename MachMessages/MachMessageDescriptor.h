//
// Created by @RaniXCH on 2019-01-20.
//

#pragma once

#import "MachPort.h"
#include "Logger.h"
#import <mach/mach.h>

enum MachMessageDescriptorType
{
    PORT_DESCRIPTOR = MACH_MSG_PORT_DESCRIPTOR,
    OOL_DESCRIPTOR = MACH_MSG_OOL_DESCRIPTOR,
    OOL_PORTS_DESCRIPTOR = MACH_MSG_OOL_PORTS_DESCRIPTOR,
    OOL_VOLATILE_DESCRIPTOR = MACH_MSG_OOL_VOLATILE_DESCRIPTOR
};



class MachMessageDescriptor
{
public:
    MachMessageDescriptor(MachMessageDescriptorType descriptorType);

    virtual mach_msg_size_t getSize()=0;
    virtual void *getPtr()=0;

protected:
    MachMessageDescriptorType descriptorType;
};

class MachMessagePortDescriptor : public MachMessageDescriptor
{
public:
    ~MachMessagePortDescriptor();

    MachMessagePortDescriptor(MachPort &portName, mach_msg_type_name_t portType, mach_msg_type_name_t disposition);

    mach_msg_size_t getSize() override;

    void* getPtr() override;

private:
    mach_msg_port_descriptor_t descriptor = {0};
};


class MachMessageOOLDescriptor : public MachMessageDescriptor
{
public:
    MachMessageOOLDescriptor(void *objectAddress, mach_msg_size_t objectSize, bool shouldObjectDeallocate,
                             mach_msg_copy_options_t descriptorCopyOptions);

    mach_msg_size_t getSize() override;
    void* getPtr() override;
    mach_msg_size_t getDataSize();

    ~MachMessageOOLDescriptor();

private:
    mach_msg_ool_descriptor64_t descriptor = {0};
};

