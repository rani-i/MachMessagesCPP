//
// Created by @RaniXCH on 2019-02-04.
//

#include "MachService.h"



MachService::MachService()
{
    this->setupMachService();
}

void MachService::setupMachService()
{
    this->machConnection = new MachConnection("com.apple.server.bluetooth");
}

// Based on the PoC - https://github.com/rani-i/bluetoothdPoC/blob/master/bluetoothdPoC/main.m
void MachService::playground()
{

    MachMessage machMessage = MachMessage(*this->machConnection, 3+0xFA300, 0x113);

}
