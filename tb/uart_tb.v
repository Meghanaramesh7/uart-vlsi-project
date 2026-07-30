`timescale 1ns/1ps

module uart_tb;

    // Clock and reset
    reg clk;
    reg reset;

    // Transmitter inputs
    reg        tx_start;
    reg [7:0]  tx_data;

    // Receiver input
    wire       rx;

    // UART outputs
    wire       tx;
    wire       tx_busy;
    wire [7:0] rx_data;
    wire       rx_done;

    // ------------------------------------------------
    // UART Top Module
    // ------------------------------------------------
    uart_top uut (
        .clk       (clk),
        .reset     (reset),

        .tx_start  (tx_start),
        .tx_data   (tx_data),
        .tx        (tx),
        .tx_busy   (tx_busy),

        .rx        (rx),
        .rx_data   (rx_data),
        .rx_done   (rx_done)
    );

    // ------------------------------------------------
    // Loopback connection
    // TX output is directly connected to RX input
    // ------------------------------------------------
    assign rx = tx;

    // ------------------------------------------------
    // 50 MHz Clock
    // Period = 20 ns
    // ------------------------------------------------
    initial begin
        clk = 1'b0;

        forever #10 clk = ~clk;
    end

    // ------------------------------------------------
    // Test procedure
    // ------------------------------------------------
    initial begin

        // Initial values
        reset    = 1'b1;
        tx_start = 1'b0;
        tx_data  = 8'h00;

        // Apply reset
        #100;
        reset = 1'b0;

        // Send hexadecimal value 0xA5
        #100;
        tx_data  = 8'hA5;
        tx_start = 1'b1;

        #20;
        tx_start = 1'b0;

        // Wait until transmission/reception completes
        wait (rx_done);

        // Display received data
        #20;

        $display("----------------------------------");
        $display("UART TEST RESULT");
        $display("Transmitted Data = %h", tx_data);
        $display("Received Data    = %h", rx_data);
        $display("----------------------------------");

        // Check result
        if (rx_data == tx_data)
            $display("TEST PASSED!");
        else
            $display("TEST FAILED!");

        #100;
        $finish;

    end

endmodule
