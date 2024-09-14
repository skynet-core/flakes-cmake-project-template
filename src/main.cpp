#include <fmt/format.h>
#include <fmt/printf.h>

using namespace std::string_literals;

int main(int argc, char** argv)
{
    fmt::println("Hello, {}!", "World"s);
    return 0;
}
