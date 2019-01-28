//
// Created by @RaniXCH on 2019-01-15.
//

#include "MachConnection.h"
#import "MachExceptions.h"


#define MACH_MODULE "MachConnection"

MachConnection::MachConnection(std::string service) {
    mach_port_t bootstrap_port = MACH_PORT_NULL;
    kern_return_t ret = task_get_bootstrap_port(mach_task_self(), &bootstrap_port);
    if(ret != KERN_SUCCESS || bootstrap_port == MACH_PORT_NULL)
    {
        throw MachConnectionNoBootstrap();
    }
    this->bootstrap_port = MachPort(bootstrap_port);
    this->connectToMachService(service);
    this->localPort = MachPort();
}

MachConnection::MachConnection(MachPort machPort) {
    mach_port_t bootstrap_port = MACH_PORT_NULL;
    kern_return_t ret = task_get_bootstrap_port(mach_task_self(), &bootstrap_port);
    if(ret != KERN_SUCCESS || bootstrap_port == MACH_PORT_NULL)
    {
        throw MachConnectionNoBootstrap();
    }
    this->bootstrap_port = MachPort(bootstrap_port);
    this->service_port = machPort;
    this->localPort = MachPort();
}

void MachConnection::connectToMachService(const std::string &service_name)
{
    kern_return_t ret;
    mach_port_t service_port = MACH_PORT_NULL;

    ret = bootstrap_look_up(this->bootstrap_port, service_name.c_str(), &service_port);
    if (ret != KERN_SUCCESS || service_port == MACH_PORT_NULL)
    {
        throw MachConnectionServiceNotFound();
    }

    DEBUG_LOG("Found port %x", service_port);
    this->service_port = service_port;
}

MachConnection::~MachConnection() {

    DEBUG_LOG("MachConnection destructor");
    if(this->service_port != MACH_PORT_NULL)
    {
        mach_port_destroy(mach_task_self(), this->service_port);
    }

    if(this->bootstrap_port != MACH_PORT_NULL)
    {
        mach_port_destroy(mach_task_self(), this->bootstrap_port);
    }
    if(this->localPort != MACH_PORT_NULL)
    {
        mach_port_destroy(mach_task_self(), this->localPort);
    }
}




std::string MachConnection::resolveMachMsgError(mach_msg_return_t error)
{
    std::string errorString = std::string(mach_error_string(error));
    return errorString;
}



MachPort& MachConnection::getServicePort()
{
    return this->service_port;
}

MachPort& MachConnection::getLocalPort()
{
    return this->localPort;
}






