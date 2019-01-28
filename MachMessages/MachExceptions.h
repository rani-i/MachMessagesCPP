//
// Created by @RaniXCH on 2019-01-23.
//

#pragma once
#import <exception>

class MachMessageComplexMessageIsNotComplex: public std::exception
{
    virtual const char* what() const throw()
    {
        return "Message is not complex";
    }
};

class MachPortCannotInsertRight: public std::exception
{
    virtual const char* what() const throw()
    {
        return "Cannot insert right";
    }
};

class MachPortCannotAllocatePort: public std::exception
{
    virtual const char* what() const throw()
    {
        return "Cannot allocate port";
    }
};


class MachConnectionNoBootstrap : public std::exception
{
    virtual const char *what() const throw()
    {
        return "No bootstrap";
    }
};

class MachConnectionServiceNotFound : public std::exception
{
    virtual const char *what() const throw()
    {
        return "Mach service not found";
    }
};


class MachMessageWasNotReceived : public std::exception
{
    virtual const char *what() const throw()
    {
        return "Mach service not found";
    }
};

class MachMessageUndefinedDescriptor : public std::exception
{
    virtual const char *what() const throw()
    {
        return "Mach service not found";
    }
};