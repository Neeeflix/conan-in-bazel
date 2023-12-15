#include <iostream>

#include "hello.hpp"

int main()
{
    std::cout << "hello world" << std::endl;
    exit(Hello::number() == 42);
}