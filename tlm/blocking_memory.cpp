#include <tlm_utils/simple_initiator_socket.h>

#include <iomanip>
#include <iostream>
#include <systemc>
#include <tlm>

#include "tlm/target_memory.h"

namespace
{

constexpr sc_dt::uint64 kAddress = 0x10;
constexpr unsigned char kValue = 0x2a;

class Initiator : public sc_core::sc_module
{
  public:
    SC_HAS_PROCESS(Initiator);

    explicit Initiator(sc_core::sc_module_name name) : sc_core::sc_module(name)
    {
        SC_THREAD(Run);
    }

    bool Passed() const
    {
        return passed_;
    }

    tlm_utils::simple_initiator_socket<Initiator> socket{"socket"};

  private:
    void Run()
    {
        unsigned char written = kValue;
        unsigned char read = 0;
        if (!Transfer(tlm::TLM_WRITE_COMMAND, written) || !Transfer(tlm::TLM_READ_COMMAND, read))
        {
            return;
        }
        if (read != kValue)
        {
            std::cerr << "TLM readback mismatch at address 0x" << std::hex << kAddress << '\n';
            return;
        }

        passed_ = true;
        std::cout << "TLM wrote and read back 0x" << std::hex << static_cast<unsigned>(read) << " at address 0x"
                  << kAddress << '\n';
    }

    bool Transfer(tlm::tlm_command command, unsigned char& data)
    {
        tlm::tlm_generic_payload transaction;
        transaction.set_command(command);
        transaction.set_address(kAddress);
        transaction.set_data_ptr(&data);
        transaction.set_data_length(1);
        transaction.set_streaming_width(1);
        transaction.set_response_status(tlm::TLM_INCOMPLETE_RESPONSE);

        sc_core::sc_time delay = sc_core::SC_ZERO_TIME;
        socket->b_transport(transaction, delay);
        if (transaction.get_response_status() != tlm::TLM_OK_RESPONSE)
        {
            std::cerr << "TLM transaction failed: " << transaction.get_response_string() << '\n';
            return false;
        }

        wait(delay);
        return true;
    }

    bool passed_ = false;
};

}  // namespace

int sc_main(int, char**)
{
    Initiator initiator("initiator");
    tlm_example::Memory memory("memory");
    initiator.socket.bind(memory.socket);

    sc_core::sc_start(10, sc_core::SC_US);
    return initiator.Passed() ? 0 : 1;
}
