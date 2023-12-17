#include <iostream>

#include "hello.hpp"

int main()
{
    std::cout << "hello world" << std::endl;
    if(HelloLib::number() != 42)
        exit(1);
}