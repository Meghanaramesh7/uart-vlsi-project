module uart_top (
    input        clk,
    input        reset,

    // Transmitter interface
    input        tx_start,
    input  [7:0] tx_data,
    output       tx,
    output       tx_busy,

    // Receiver interface
    input        rx,
    output [7:0] rx_data,
    output       rx_done
);

    wire baud_tick;

    // Baud Rate Generator
    baud_generator baud_gen_inst (
        .clk       (clk),
        .reset     (reset),
        .baud_tick (baud_tick)
    );

    // UART Transmitter
    uart_tx tx_inst (
        .clk       (clk),
        .reset     (reset),
        .tx_start  (tx_start),
        .tx_data   (tx_data),
        .baud_tick (baud_tick),
        .tx        (tx),
        .tx_busy   (tx_busy)
    );

    // UART Receiver
    uart_rx rx_inst (
        .clk       (clk),
        .reset     (reset),
        .rx        (rx),
        .baud_tick (baud_tick),
        .rx_data   (rx_data),
        .rx_done   (rx_done)
    );

endmodule
