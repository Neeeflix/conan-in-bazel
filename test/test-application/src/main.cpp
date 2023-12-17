#include <iostream>

#include "hello.hpp"

int main()
{
    std::cout << "hello world" << std::endl;
    exit(HelloLib::number() == 42);
}