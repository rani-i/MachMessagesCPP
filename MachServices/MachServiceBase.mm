//
// Created by @RaniXCH on 2019-01-23.
//

#include "MachServiceBase.h"

MachServiceBase::MachServiceBase()
{
}

MachServiceBase::~MachServiceBase()
{
    if(this->machConnection != NULL)
    {
        delete this->machConnection;
    }
}
