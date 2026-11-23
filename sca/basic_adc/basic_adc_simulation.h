#pragma once

#include <cstdint>
#include <systemc-ams>
#include <systemc>

#include "sca/basic_adc/basic_adc.h"

class BasicAdcSimulation
{
  public:
    BasicAdcSimulation()
    {
        stimulus_.positive(positive_);
        stimulus_.negative(negative_);
        adc_.ain_p(positive_);
        adc_.ain_n(negative_);
        adc_.dout(code_);
        stimulus_.set_timestep(1, sc_core::SC_NS);
    }

    std::uint16_t Sample(double positive, double negative)
    {
        stimulus_.SetVoltage(positive, negative);
        sc_core::sc_start(10, sc_core::SC_NS);
        return code_.read();
    }

  private:
    class Stimulus : public sca_tdf::sca_module
    {
      public:
        explicit Stimulus(sc_core::sc_module_name name) : sca_tdf::sca_module(name) {}

        sca_tdf::sca_out<double> positive{"positive"};
        sca_tdf::sca_out<double> negative{"negative"};

        void SetVoltage(double positive_voltage, double negative_voltage)
        {
            positive_voltage_ = positive_voltage;
            negative_voltage_ = negative_voltage;
        }

      private:
        void processing() override
        {
            positive.write(positive_voltage_);
            negative.write(negative_voltage_);
        }

        double positive_voltage_{};
        double negative_voltage_{};
    };

    sca_tdf::sca_signal<double> positive_{"positive"};
    sca_tdf::sca_signal<double> negative_{"negative"};
    sc_core::sc_signal<std::uint16_t> code_{"code"};
    Stimulus stimulus_{"stimulus"};
    BasicAdc adc_{"adc"};
};
