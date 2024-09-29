#include <fmt/core.h>
#include <fmt/format.h>
#include <fmt/printf.h>
#include <fmt/ranges.h>
#include <functional>
#include <numeric>
#include <vector>

using namespace std::string_literals;

auto main([[maybe_unused]] int argc, [[maybe_unused]] char **argv) -> int {
  std::vector vec{1, 2, 3, 4, 5, 6, 7, 8, 9};
  fmt::println("Hello, {:n}!", vec);
  auto res = std::reduce(vec.begin(), vec.end(), 0, std::plus<>{});
  fmt::print("Sum: {}\n", res);
  return 0;
}
