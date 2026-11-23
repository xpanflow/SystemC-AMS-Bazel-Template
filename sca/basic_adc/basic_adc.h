#pragma once

#include <cstdint>
#include <systemc-ams>

// A TDF model of a unipolar differential ADC.
class BasicAdc : public sca_tdf::sca_module
{
  public:
    sca_tdf::sca_in<double> ain_p;
    sca_tdf::sca_in<double> ain_n;
    sca_tdf::sc_out<std::uint16_t> dout;

    // v_ref is in volts and res is in bits (1–16). fs and rate are retained
    // for existing callers. The connected TDF stimulus sets the timestep.
    BasicAdc(sc_core::sc_module_name name = "adc",
             double v_ref = 1.0,
             std::uint32_t res = 12,
             std::uint32_t fs = 100'000'000,
             std::uint32_t rate = 1);

  private:
    void processing() override;

    double v_ref_;
    std::uint32_t max_code_{};
};
