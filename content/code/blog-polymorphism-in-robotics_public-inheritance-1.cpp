struct control{}; // Dummy type to represent the control of your robot
struct state{};   // Dummy type to represent the state of your robot

struct controller_base {
  virtual auto advance(const state& state) const -> control = 0;
};

struct controller_a : public controller_base {
  auto advance(const state& state) const -> control override {
    std::println("controller_a::advance"); return {};
  }
};

struct controller_b : public controller_base {
  auto advance(const state& state) const -> control override {
    std::println("controller_b::advance"); return {};
  };
};

struct controller_c : public controller_base {
  auto advance(const state& state) const -> control override {
    std::println("controller_c::advance"); return {};
  };
};

int main() {
  std::unique_ptr<controller_base> controller;
  if (/* runtime_condition_for_controller_a == */ true) {
    controller = std::make_unique<controller_a>();
    controller->advance();
  }
  if (/* runtime_condition_for_controller_b == */ true) {
    controller = std::make_unique<controller_b>();
    controller->advance();
  }
  if (/* runtime_condition_for_controller_c == */ true) {
    controller = std::make_unique<controller_c>();
    controller->advance();
  }
}
