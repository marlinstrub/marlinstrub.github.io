struct control{}; // Dummy type to represent the control of your robot
struct state{};   // Dummy type to represent the state of your robot

struct controller_base {
  virtual auto advance(const state &state) const -> control = 0;
  virtual auto reset() const -> void = 0;
};

struct controller_a : public controller_base {
  auto advance(const state& state) const -> control override {
    std::println("controller_a::advance"); return {};
  }
  auto reset() -> void override {
    std::println("controller_a::reset")
  }
};

struct controller_b : public controller_base {
  auto advance(const state& state) const -> control override {
    std::println("controller_b::advance"); return {};
  };
  auto reset() -> void override {
    std::println("controller_b::reset")
  }
};

struct controller_c : public controller_base {
  auto advance(const state& state) const -> control override {
    std::println("controller_c::advance"); return {};
  };
  auto reset() -> void override {
    std::println("controller_c::reset")
  }
};

int main() {
  std::unique_ptr<controller_base> controller;
  std::unique_ptr<controller_base> controller;
  if (/* runtime_condition_for_controller_a == */ true) {
    controller = std::make_unique<controller_a>();
    controller->advance();
    controller->reset();
  }
  if (/* runtime_condition_for_controller_b == */ true) {
    controller = std::make_unique<controller_b>();
    controller->advance();
    controller->reset();
  }
  if (/* runtime_condition_for_controller_c == */ true) {
    controller = std::make_unique<controller_c>();
    controller->advance();
    controller->reset();
  }
}
