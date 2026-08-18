struct control{}; // Dummy type to represent the control of your robot
struct state{};   // Dummy type to represent the state of your robot

struct controller_base {
  virtual auto advance(const state &state) const -> control = 0;
  virtual auto reset() -> void = 0; // This change is only needed because of the mechanism
};

struct controller_a : public controller_base {
  auto advance(const state& state) const -> control override {
    std::println("controller_a::advance"); return {};
  }
  auto reset() -> void override {
    std::println("controller_a::reset"); // Resets the integrator (the change you want)
  }
};

struct controller_b : public controller_base {
  auto advance(const state& state) const -> control override {
    std::println("controller_b::advance"); return {};
  };
  auto reset() -> void override {
    std::println("controller_b::reset"); // This change is only needed because of the mechanism
  }
};

int main() {
  std::unique_ptr<controller_base> controller;
  if (/* runtime_condition_for_controller_a == */ true) {
    controller = std::make_unique<controller_a>();
    controller->advance(state{});
    controller->reset();
  }
  if (/* runtime_condition_for_controller_b == */ true) {
    controller = std::make_unique<controller_b>();
    controller->advance(state{});
    controller->reset(); // You can call it but it may not do anything meaningful
  }
}
