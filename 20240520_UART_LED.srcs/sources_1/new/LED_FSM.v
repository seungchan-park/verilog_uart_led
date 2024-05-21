`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/20 16:13:04
// Design Name: 
// Module Name: LED_FSM
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module Top (
    input clk,
    input reset,
    input rx,
    output [2:0] led
);
    wire [7:0] w_rx_data;
    wire w_rx_done;

    uart U_uart (
        .clk(clk),
        .reset(reset),
        // Transmitter
        .start(),
        .tx_data(),
        .tx(),
        .tx_done(),
        // Receiver
        .rx(rx),
        .rx_data(w_rx_data),
        .rx_done(w_rx_done)
    );

    LED_FSM U_led (
        .clk(clk),
        .reset(reset),
        .rx_data(w_rx_data),
        .rx_done(w_rx_done),
        .led(led)
    );

endmodule

module LED_FSM (
    input clk,
    input reset,
    input [7:0] rx_data,
    input rx_done,
    output [2:0] led
);

    localparam LED_OFF = 0, LED_1 = 1, LED_2 = 2, LED_3 = 3;

    reg [1:0] state, state_next;
    reg [7:0] rx_tmp_reg, rx_tmp_next;
    reg [2:0] led_reg, led_next;

    assign led = led_reg;

    always @(posedge clk, posedge reset) begin
        if (reset) begin
            state <= LED_OFF;
            rx_tmp_reg <= 0;
            led_reg = 0;
        end else begin
            state <= state_next;
            rx_tmp_reg <= rx_tmp_next;
            led_reg <= led_next;
        end
    end

    always @(*) begin
        state_next = state;
        rx_tmp_next = rx_tmp_reg;
        led_next = led_reg;
        case (state)
            LED_OFF: begin
                led_next = 3'b000;
                if (rx_done) begin
                    rx_tmp_next = rx_data;
                end
                if (rx_tmp_reg == "0") begin
                    state_next = LED_OFF;
                end else if (rx_tmp_reg == "1") begin
                    state_next = LED_1;
                end else if (rx_tmp_reg == "2") begin
                    state_next = LED_2;
                end else if (rx_tmp_reg == "3") begin
                    state_next = LED_3;
                end
            end
            LED_1: begin
                led_next = 3'b001;
                if (rx_done) begin
                    rx_tmp_next = rx_data;
                end
                if (rx_tmp_reg == "0") begin
                    state_next = LED_OFF;
                end else if (rx_tmp_reg == "1") begin
                    state_next = LED_1;
                end else if (rx_tmp_reg == "2") begin
                    state_next = LED_2;
                end else if (rx_tmp_reg == "3") begin
                    state_next = LED_3;
                end
            end
            LED_2: begin
                led_next = 3'b010;
                if (rx_done) begin
                    rx_tmp_next = rx_data;
                end
                if (rx_tmp_reg == "0") begin
                    state_next = LED_OFF;
                end else if (rx_tmp_reg == "1") begin
                    state_next = LED_1;
                end else if (rx_tmp_reg == "2") begin
                    state_next = LED_2;
                end else if (rx_tmp_reg == "3") begin
                    state_next = LED_3;
                end
            end
            LED_3: begin
                led_next = 3'b100;
                if (rx_done) begin
                    rx_tmp_next = rx_data;
                end
                if (rx_tmp_reg == "0") begin
                    state_next = LED_OFF;
                end else if (rx_tmp_reg == "1") begin
                    state_next = LED_1;
                end else if (rx_tmp_reg == "2") begin
                    state_next = LED_2;
                end else if (rx_tmp_reg == "3") begin
                    state_next = LED_3;
                end
            end
        endcase
    end

endmodule
