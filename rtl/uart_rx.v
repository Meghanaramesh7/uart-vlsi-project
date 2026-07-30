module uart_rx (
    input        clk,
    input        reset,
    input        rx,
    input        baud_tick,

    output reg [7:0] rx_data,
    output reg       rx_done
);

    localparam IDLE  = 2'b00;
    localparam START = 2'b01;
    localparam DATA  = 2'b10;
    localparam STOP  = 2'b11;

    reg [1:0] state;
    reg [3:0] bit_count;

    always @(posedge clk or posedge reset) begin

        if (reset) begin
            state     <= IDLE;
            bit_count <= 4'd0;
            rx_data   <= 8'd0;
            rx_done   <= 1'b0;
        end

        else begin

            rx_done <= 1'b0;

            case (state)

                IDLE: begin
                    bit_count <= 4'd0;

                    if (rx == 1'b0) begin
                        state <= START;
                    end
                end

                START: begin
                    if (baud_tick) begin

                        if (rx == 1'b0) begin
                            state <= DATA;
                            bit_count <= 4'd0;
                        end
                        else begin
                            state <= IDLE;
                        end

                    end
                end

                DATA: begin
                    if (baud_tick) begin

                        rx_data[bit_count] <= rx;

                        if (bit_count == 4'd7) begin
                            state <= STOP;
                        end
                        else begin
                            bit_count <= bit_count + 1'b1;
                        end

                    end
                end

                STOP: begin
                    if (baud_tick) begin

                        if (rx == 1'b1) begin
                            rx_done <= 1'b1;
                        end

                        state <= IDLE;
                    end
                end

                default: begin
                    state <= IDLE;
                end

            endcase
        end
    end

endmodule
