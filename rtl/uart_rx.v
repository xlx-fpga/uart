`timescale 1ns / 1ns
//****************************************VSCODE PLUG-IN**********************************// 
//---------------------------------------------------------------------------------------- 
// IDE :                   VSCODE      
// VSCODE plug-in version: Verilog-Hdl-Format-2.4.20240526
// VSCODE plug-in author : Jiang Percy 
//---------------------------------------------------------------------------------------- 
//****************************************Copyright (c)***********************************// 
// Copyright(C)            xlx_fpga
// All rights reserved      
// File name:               
// Last modified Date:     2024/07/05 16:57:12 
// Last Version:           V1.0 
// Descriptions:            
//---------------------------------------------------------------------------------------- 
// Created by:             xlx_fpga
// Created date:           2024/07/05 16:57:12 
// Version:                V1.0 
// TEXT NAME:              uart_rx.v 
// PATH:                   E:\3.xlx_fpga\4.uart\rtl\uart_rx.v 
// Descriptions:            
//                          
//---------------------------------------------------------------------------------------- 
//****************************************************************************************// 

module uart_rx #(
    parameter                                   CLK_FREQ           = 50_000_000,
    parameter                                   UART_BPS           = 115200
)
(
    input                                       clk                 ,
    input                                       rst                 ,
    input                                       uart_rxd            ,
    output reg         [7: 0]                   rx_data             ,
    output reg                                  rx_done              
);

    localparam                                  BAUD_CNT_MAX       = CLK_FREQ/UART_BPS;
    localparam                                  BAUD_CNT_HALF      = BAUD_CNT_MAX/2;
    reg                                         uart_rxd_d0         ;
    reg                                         uart_rxd_d1         ;
    reg                [16: 0]                  baud_cnt            ;
    reg                [3: 0]                   rx_data_cnt         ;
    always @(posedge clk )
        begin
            if(rst)
        begin
                uart_rxd_d0 <= 0;
                uart_rxd_d1 <= 0;
        end
            else 
        begin
                uart_rxd_d0 <= uart_rxd;
                uart_rxd_d1 <= uart_rxd_d0;
        end
        end

    localparam                                  RX_IDLE            = 3'b000;
    localparam                                  RX_BEGIN           = 3'b001;
    localparam                                  RX_DATA            = 3'b010;
    localparam                                  RX_END             = 3'b100;
                                                          
    reg                [3: 0]                   cur_state           ;
    reg                [3: 0]                   next_state          ;
    //同步时序描述状态转移
    always @(posedge clk )
        begin
            if(rst)
                cur_state <= RX_IDLE;
            else 
                cur_state <= next_state;
        end
//组合逻辑判断状态转移条件
    always @( * ) begin
        case(cur_state)
            RX_IDLE:
        begin
            if(uart_rxd_d1 & (~uart_rxd_d0))
                next_state <= RX_BEGIN        ;
            else 
                next_state <= RX_IDLE;
        end
            RX_BEGIN:
        begin
            if(baud_cnt == BAUD_CNT_MAX && rx_data_cnt ==0) begin
                next_state <= RX_DATA;
        end
            else 
                next_state <= cur_state;
        end
            RX_DATA:
        begin
            if(baud_cnt ==BAUD_CNT_MAX && rx_data_cnt ==8) begin
                next_state <= RX_END ;
        end
            else 
                next_state <= cur_state;
        end
            RX_END:
            if(baud_cnt ==BAUD_CNT_MAX && rx_data_cnt ==9) begin
                next_state <= RX_IDLE;
        end
            default: next_state <= RX_IDLE;
        endcase
        end

//时序电路描述状态输出

//波特率计数器
    always @(posedge clk )
        begin
            if(rst) begin
                baud_cnt <= 0;
        end
            else if(baud_cnt ==BAUD_CNT_MAX) begin
                baud_cnt <= 0;
        end
            else if(cur_state !=RX_IDLE ) begin
                baud_cnt <= baud_cnt+1;
        end
            else begin
                baud_cnt <= baud_cnt;
        end
        end

//rx_data_cnt
    always @(posedge clk )
        begin
            if(rst) begin
                rx_data_cnt <= 0;
        end
            else if(rx_data_cnt == 9 &&baud_cnt ==BAUD_CNT_MAX) begin
                rx_data_cnt <= 0;
        end
            else if(baud_cnt ==BAUD_CNT_MAX) begin
                rx_data_cnt <= rx_data_cnt +1;
        end
            else begin
                rx_data_cnt <= rx_data_cnt;
        end
        end
//接收数据
    always @(posedge clk )
        begin
            if(rst) begin
                rx_data <= 0;
        end
            else if(cur_state==RX_DATA&&baud_cnt == BAUD_CNT_HALF ) begin
                rx_data ={uart_rxd_d1,rx_data[7:1]};
        end
            else begin
                rx_data <= rx_data;
        end
        end
//发送rx_done信号
    always @(posedge clk )
        begin
            if(rst) begin
                rx_done <= 0;
        end
            else if(cur_state == RX_END) begin
                rx_done <= 1'b1;
        end
            else begin
                rx_done <= 0;
        end
        end
        endmodule
