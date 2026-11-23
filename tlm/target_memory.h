#pragma once

#include <tlm_utils/simple_target_socket.h>

#include <array>
#include <systemc>
#include <tlm>

namespace tlm_example
{

class Memory : public sc_core::sc_module
{
  public:
    explicit Memory(sc_core::sc_module_name name);

    tlm_utils::simple_target_socket<Memory> socket{"socket"};

  private:
    void BTransport(tlm::tlm_generic_payload& transaction, sc_core::sc_time& delay);

    std::array<unsigned char, 1024> storage_{};
};

}  // namespace tlm_example
