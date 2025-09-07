
// `GEN_CLK(signal_name, frequency_MHz, start_high, duty_cycle)
// Example: `GEN_CLK(clk, 500, 1, 0.5) generates a 500 MHz clock, starting high, with 50% duty cycle
`define GEN_CLK(signal_name, frequency, start_high, duty_cycle) \
    initial begin \
        signal_name = start_high; \
        forever begin \
            signal_name = ~signal_name; \
            #(1000/(2*frequency)); \
        end \
    end \
    /* synthesis translate_off */ 
    /* synthesis syn_preserve = 1 */ 
    /* synthesis syn_translate = 0 */ 
    /* synthesis translate_on */

// `GEN_RST(signal_name, clk_name, reset_valid_at_1, cycles)
// Example: `GEN_RST(rst_n, clk, 0, 0, 7) generates a synchronous, active-low reset
`define GEN_RST(signal_name, clk_name, reset_valid_at_1, cycles) \
    initial begin \
        signal_name = reset_valid_at_1 ? 1'b1 : 1'b0; \
        #(2);\
        signal_name = reset_valid_at_1 ? 1'b0 : 1'b1; \
        repeat(cycles) @(posedge clk_name); \
        signal_name = reset_valid_at_1 ? 1'b1 : 1'b0; \
    end \
    /* synthesis translate_off */ 
    /* synthesis syn_preserve = 1 */ 
    /* synthesis syn_translate = 0 */ 
    /* synthesis translate_on */

// `GEN_VCD(top_module_name, dump_level, dump_vars)
// Example:
// `GEN_VCD(tb_top, 0)
// `GEN_VCD(tb_top, 1) // Dump only the DUT instance
`define GEN_VCD(top_module_name, dump_level) \
    initial begin \
        $dumpfile("top_module_name"); \
        $dumpvars(dump_level, top_module_name); \
    end \
    /* synthesis translate_off */ \
    /* synthesis syn_preserve = 1 */ \
    /* synthesis syn_translate = 0 */ \
    /* synthesis translate_on */

// `GEN_FSDB(top_module_name, dump_level)
// Example:
// `GEN_FSDB(tb_top, 0)
`define GEN_FSDB(top_module_name, dump_level) \
    initial begin \
        $fsdbDumpfile("top_module_name"); \
        $fsdbDumpvars(dump_level, top_module_name); \
    end \
    /* synthesis translate_off */ \
    /* synthesis syn_preserve = 1 */ \
    /* synthesis syn_translate = 0 */ \
    /* synthesis translate_on */

// `FINISH_SIM(message)
// Example: `FINISH_SIM("Simulation completed successfully!")
`define FINISH_SIM(message) \
    begin \
        $display("INFO: %s", message); \
        $display("INFO: Simulation finished at time %0t", $time); \
        $finish; \
    end


// `RAND_DELAY(min_ns, max_ns)
// Example: `RAND_DELAY(10, 100) // Random delay between 10ns and 100ns
`define RAND_DELAY(min_ns, max_ns) \
    #((min_ns) + $random % ((max_ns) - (min_ns) + 1));



