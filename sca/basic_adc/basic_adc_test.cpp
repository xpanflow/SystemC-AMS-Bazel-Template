#include <gtest/gtest.h>

#include "sca/basic_adc/basic_adc_simulation.h"

TEST(BasicAdcTest, GivenDifferentialInput_WhenSampled_ThenReturnsSaturatedTwelveBitCode)
{
    // Exercise all samples in the same SystemC simulation.
    BasicAdcSimulation simulation;
    EXPECT_EQ(simulation.Sample(0.0, 0.25), 0);
    EXPECT_EQ(simulation.Sample(0.0, 0.0), 0);
    EXPECT_EQ(simulation.Sample(0.75, 0.25), 2047);
    EXPECT_EQ(simulation.Sample(1.0, 0.0), 4095);
    EXPECT_EQ(simulation.Sample(1.25, 0.0), 4095);
}

int sc_main(int argc, char* argv[])
{
    ::testing::InitGoogleTest(&argc, argv);
    return RUN_ALL_TESTS();
}
