// UART Baud Rate Generator
// Clock Frequency: 50 MHz
// Baud Rate: 9600

module baud_generator (
    input  clk,
    input reset,
    output reg baud_tick
);

    // 50,000,000 / 9600 = approximately 5208 clock cycles
    parameter BAUD_COUNT = 5208;

    reg [12:0] counter;

    always @(posedge clk or posedge reset) begin

        if (reset) begin
            counter   <= 13'd0;
            baud_tick <= 1'b0;
        end

        else begin

            if (counter == BAUD_COUNT - 1) begin
                counter   <= 13'd0;
                baud_tick <= 1'b1;
            end

            else begin
                counter   <= counter + 1'b1;
                baud_tick <= 1'b0;
            end

        end

    end

endmodule
