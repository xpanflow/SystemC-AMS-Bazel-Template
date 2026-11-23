#include "tlm/target_memory.h"

#include <cstring>

namespace tlm_example
{

Memory::Memory(sc_core::sc_module_name name) : sc_core::sc_module(name)
{
    socket.register_b_transport(this, &Memory::BTransport);
}

void Memory::BTransport(tlm::tlm_generic_payload& transaction, sc_core::sc_time& delay)
{
    const auto address = transaction.get_address();
    const auto length = transaction.get_data_length();
    auto* data = transaction.get_data_ptr();

    if (address >= storage_.size() || length > storage_.size() - address)
    {
        transaction.set_response_status(tlm::TLM_ADDRESS_ERROR_RESPONSE);
        return;
    }
    if (transaction.get_byte_enable_ptr() != nullptr)
    {
        transaction.set_response_status(tlm::TLM_BYTE_ENABLE_ERROR_RESPONSE);
        return;
    }
    if (transaction.get_streaming_width() < length)
    {
        transaction.set_response_status(tlm::TLM_BURST_ERROR_RESPONSE);
        return;
    }
    if (data == nullptr || length == 0)
    {
        transaction.set_response_status(tlm::TLM_GENERIC_ERROR_RESPONSE);
        return;
    }

    auto* location = storage_.data() + address;
    switch (transaction.get_command())
    {
        case tlm::TLM_READ_COMMAND:
            std::memcpy(data, location, length);
            break;
        case tlm::TLM_WRITE_COMMAND:
            std::memcpy(location, data, length);
            break;
        default:
            transaction.set_response_status(tlm::TLM_COMMAND_ERROR_RESPONSE);
            return;
    }

    delay += sc_core::sc_time(1, sc_core::SC_US);
    transaction.set_response_status(tlm::TLM_OK_RESPONSE);
}

}  // namespace tlm_example
