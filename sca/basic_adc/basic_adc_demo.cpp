#include <iostream>

#include "sca/basic_adc/basic_adc_simulation.h"

int sc_main(int, char**)
{
    BasicAdcSimulation simulation;
    for (double voltage : {0.0, 0.5, 1.0})
    {
        const auto code = simulation.Sample(voltage, 0.0);
        std::cout << voltage << " V -> " << code << '\n';
    }
    return 0;
}
