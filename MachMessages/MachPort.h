//
// Created by @RaniXCH on 2019-01-16.
//

#pragma once
#import <mach/mach.h>
#import <exception>



class MachPort
{
    public:
        MachPort(mach_port_t machPort);
        MachPort();
        void InsertRight(mach_msg_type_name_t rightType);
public:
    virtual ~MachPort();

private:
    mach_port_t machPort = MACH_PORT_NULL;
public:
    operator mach_port_t();
};


