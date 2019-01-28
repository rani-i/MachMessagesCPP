//
// Created by @RaniXCH on 2019-01-16.
//

#include "MachPort.h"
#include "Logger.h"
#import "MachExceptions.h"

MachPort::MachPort(mach_port_t machPort) {
    this->machPort = machPort;
}

void MachPort::InsertRight(mach_msg_type_name_t rightType) {

    kern_return_t ret = mach_port_insert_right(mach_task_self(), this->machPort, this->machPort, rightType);
    
    MACH_LOG("Insert right");
    if(KERN_SUCCESS != ret)
    {
        throw MachPortCannotInsertRight();
    }
}

MachPort::MachPort() {
    
        mach_port_t allocatedPort = MACH_PORT_NULL;
        kern_return_t ret = mach_port_allocate(mach_task_self(), MACH_PORT_RIGHT_RECEIVE, &allocatedPort);
        MACH_LOG("Allocated port");
        if(KERN_SUCCESS != ret){
            throw MachPortCannotAllocatePort();
        }
        
        if(MACH_PORT_NULL == allocatedPort )
        {
            throw MachPortCannotAllocatePort();
        }
    
    this->machPort = allocatedPort;
}

MachPort::operator mach_port_t() {
    return this->machPort;
}

MachPort::~MachPort()
{
    DEBUG_LOG("MachPort destructor");
}



