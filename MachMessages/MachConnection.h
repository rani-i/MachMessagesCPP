//
// Created by @RaniXCH on 2019-01-15.
//

#pragma once

#include <mach/mach.h>
#include <mach/bootstrap.h>
#import <string>
#import <exception>
#import "MachPort.h"
#import "Logger.h"

extern "C" kern_return_t bootstrap_look_up(mach_port_t bs, const char *service_name, mach_port_t *service);




class MachConnection
{
public:
    MachConnection(std::string service);

    MachConnection(MachPort machPort);

    ~MachConnection();

    MachPort &getServicePort();

    MachPort &getLocalPort();

    std::string resolveMachMsgError(mach_msg_return_t error);

private:
    void connectToMachService(const std::string &service_name);

    MachPort service_port;
    MachPort bootstrap_port;
    MachPort localPort;
};
