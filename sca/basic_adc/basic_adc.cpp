#include "sca/basic_adc/basic_adc.h"

#include <algorithm>
#include <cmath>
#include <stdexcept>

BasicAdc::BasicAdc(
    sc_core::sc_module_name name, double v_ref, std::uint32_t res, std::uint32_t /*fs*/, std::uint32_t /*rate*/)
    : sca_tdf::sca_module(name), ain_p("ain_p"), ain_n("ain_n"), dout("dout"), v_ref_(v_ref)
{
    if (!std::isfinite(v_ref_) || v_ref_ <= 0.0)
    {
        throw std::invalid_argument("ADC reference voltage must be finite and positive");
    }
    if (res < 1 || res > 16)
    {
        throw std::invalid_argument("ADC resolution must be between 1 and 16 bits");
    }
    max_code_ = (std::uint32_t{1} << res) - 1;
}

void BasicAdc::processing()
{
    const double input_voltage = ain_p.read() - ain_n.read();
    const double fraction = std::max(0.0, std::min(input_voltage / v_ref_, 1.0));
    dout.write(static_cast<std::uint16_t>(fraction * max_code_));
}
