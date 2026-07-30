module uart_tx(
    input  wire       clk,
    input  wire       reset,
    input  wire       baud_tick,
    input  wire       tx_start,
    input  wire [7:0] tx_data,
    output reg        tx,
    output reg        tx_busy
);

    reg [3:0] bit_count;
    reg [9:0] tx_shift;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            tx        <= 1'b1;
            tx_busy   <= 1'b0;
            bit_count <= 4'd0;
            tx_shift  <= 10'b1111111111;
        end

        else begin

            // Start transmission
            if (tx_start && !tx_busy) begin
                // Frame = Stop bit + 8 data bits + Start bit
                tx_shift  <= {1'b1, tx_data, 1'b0};
                tx_busy   <= 1'b1;
                bit_count <= 4'd0;
                tx        <= 1'b0;
            end

            // Send one bit at every baud tick
            else if (tx_busy && baud_tick) begin

                if (bit_count == 4'd9) begin
                    tx_busy   <= 1'b0;
                    tx        <= 1'b1;
                    bit_count <= 4'd0;
                end

                else begin
                    tx_shift  <= {1'b1, tx_shift[9:1]};
                    tx        <= tx_shift[1];
                    bit_count <= bit_count + 1'b1;
                end
            end
        end
    end

endmodule
