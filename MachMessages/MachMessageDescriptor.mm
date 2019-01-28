//
// Created by @RaniXCH on 2019-01-20.
//

#include "MachMessageDescriptor.h"



MachMessageDescriptor::MachMessageDescriptor(MachMessageDescriptorType descriptorType) : descriptorType(descriptorType) {
}

MachMessageOOLDescriptor::MachMessageOOLDescriptor(void* objectAddress, mach_msg_size_t objectSize, bool shouldObjectDeallocate,
                                                   mach_msg_copy_options_t descriptorCopyOptions) : MachMessageDescriptor(OOL_DESCRIPTOR) {

    this->descriptor.size = objectSize;
    this->descriptor.address = (uint64_t )objectAddress;
    this->descriptor.deallocate = shouldObjectDeallocate;
    this->descriptor.copy = descriptorCopyOptions;
    this->descriptor.type = this->descriptorType;
}


MachMessageOOLDescriptor::~MachMessageOOLDescriptor()
{
    DEBUG_LOG("MachMessageOOL destructor");
}

mach_msg_size_t MachMessageOOLDescriptor::getSize()
{
    return sizeof(mach_msg_ool_descriptor64_t);
}


void *MachMessageOOLDescriptor::getPtr()
{
    return &this->descriptor;
}

mach_msg_size_t MachMessageOOLDescriptor::getDataSize()
{
    return this->descriptor.size;
}

MachMessagePortDescriptor::MachMessagePortDescriptor(MachPort& portName, mach_msg_type_name_t portType, mach_msg_type_name_t disposition)
        : MachMessageDescriptor(PORT_DESCRIPTOR)
{

        this->descriptor.name = mach_port_t(portName);
        this->descriptor.disposition = disposition ;
        this->descriptor.type=  portType;
}


MachMessagePortDescriptor::~MachMessagePortDescriptor()
{
    DEBUG_LOG("MachMessagePortDescriptor destructor");
}

mach_msg_size_t MachMessagePortDescriptor::getSize()
{
    return sizeof(mach_msg_port_descriptor_t);
}

void *MachMessagePortDescriptor::getPtr()
{
    return &this->descriptor;
}


