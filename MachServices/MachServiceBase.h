//
// Created by @RaniXCH on 2019-01-23.
//

#pragma once

#import "../MachMessages/MachConnection.h"


class MachServiceBase
{
public:
    MachServiceBase();
    virtual ~MachServiceBase();
    virtual void setupMachService()=0;

protected:
    MachConnection* machConnection = NULL;

};


