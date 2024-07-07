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
// Last modified Date:     2024/07/07 15:03:00 
// Last Version:           V1.0 
// Descriptions:            
//---------------------------------------------------------------------------------------- 
// Created by:             xlx_fpga
// Created date:           2024/07/07 15:03:00 
// Version:                V1.0 
// TEXT NAME:              uart_tx.v 
// PATH:                   E:\3.xlx_fpga\4.uart\rtl\uart_tx.v 
// Descriptions:            
//                          
//---------------------------------------------------------------------------------------- 
//****************************************************************************************// 

module uart_tx#(
    parameter                                   CLK_FREQ           = 50_000_000,
    parameter                                   UART_BPS           = 115200
    )
(
    input                                       clk                 ,
    input                                       rst                 ,
    input                                       rx_done             ,
    input              [7: 0]                   rx_data             ,
    output reg                                  uart_txd             
);
    localparam                                  BAUD_CNT_MAX       = CLK_FREQ/UART_BPS;
    
    localparam                                  TX_IDLE            = 3'b000;
    localparam                                  TX_BGEIN           = 3'B001;
    localparam                                  TX_DATA            = 3'B010;
    localparam                                  TX_END             = 3'b100;

    reg                                         tx_en_d0            ;
    reg                                         tx_en_d1            ;
    reg                [16: 0]                  baud_cnt            ;
    reg                [3: 0]                   tx_data_cnt         ;
    reg                [7: 0]                   tx_data             ;
                                                             
    reg                [2: 0]                   cur_state           ;
    reg                [2: 0]                   next_state          ;

    always @(posedge clk )
        begin
            if(rst)
        begin
                tx_en_d0 <= 0;
                tx_en_d1 <= 0;
        end
            else 
        begin
                tx_en_d0 <= rx_done;
                tx_en_d1 <= tx_en_d0;
        end
        end
    //同步时序描述状态转移
    always @(posedge clk )
        begin
            if(rst)
                cur_state <= TX_IDLE;
            else 
                cur_state <= next_state;
        end
    //组合逻辑判断状态转移条件
    always @( * ) begin
            case(cur_state)
                TX_IDLE:
        begin
            if(tx_en_d0 & (~tx_en_d1) )
                next_state <= TX_BGEIN        ;
            else 
                next_state <= TX_IDLE;
        end
                TX_BGEIN:
        begin
            if(tx_data_cnt == 0 && baud_cnt == BAUD_CNT_MAX) begin
                next_state <= TX_DATA;
        end
            else begin
                next_state <= cur_state;
        end
        end
                TX_DATA:
        begin
            if(tx_data_cnt == 8 && baud_cnt == BAUD_CNT_MAX) begin
                next_state <= TX_END;
        end
            else begin
                next_state <= cur_state;
        end
        end
                TX_END:if (tx_data_cnt == 9 && baud_cnt == BAUD_CNT_MAX) begin
                next_state <= TX_IDLE;
        end
            else begin
                next_state <= cur_state;
        end
                default: next_state <= TX_IDLE;
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
            else if(cur_state !=TX_IDLE ) begin
                baud_cnt <= baud_cnt+1;
        end
            else begin
                baud_cnt <= baud_cnt;
        end
        end
//tx_data_cnt
    always @(posedge clk )
        begin
            if(rst) begin
                tx_data_cnt <= 0;
        end
            else if(tx_data_cnt == 9 &&baud_cnt ==BAUD_CNT_MAX) begin
                tx_data_cnt <= 0;
        end
            else if(baud_cnt ==BAUD_CNT_MAX) begin
                tx_data_cnt <= tx_data_cnt +1;
        end
            else begin
                tx_data_cnt <= tx_data_cnt;
        end
        end

//tx_data
    always @(posedge clk )
        begin
            if(rst) begin
                tx_data <= 0;
        end
            else if(cur_state == TX_BGEIN) begin
                tx_data <= rx_data;
        end
            else if(cur_state == TX_DATA && baud_cnt ==BAUD_CNT_MAX) begin
                tx_data <= {tx_data>>1};
        end
            else begin
                tx_data <= tx_data;
        end
        end
                                         
//uart_txd
    always @(posedge clk )
        begin
            if(rst) begin
                uart_txd <= 1;
        end
            else if(cur_state == TX_BGEIN) begin
                uart_txd <= 0;
        end
            else if(cur_state ==TX_DATA && baud_cnt ==0) begin
                uart_txd <= tx_data[0];
        end
            else if(cur_state ==TX_END && baud_cnt ==0) begin
                uart_txd <= 1;
        end
            else begin
                uart_txd <= uart_txd;
        end
        end
        endmodule
