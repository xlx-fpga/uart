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
// Last modified Date:     2024/07/05 17:47:30 
// Last Version:           V1.0 
// Descriptions:            
//---------------------------------------------------------------------------------------- 
// Created by:             xlx_fpga
// Created date:           2024/07/05 17:47:30 
// Version:                V1.0 
// TEXT NAME:              uart.v 
// PATH:                   E:\3.xlx_fpga\4.uart\rtl\uart.v 
// Descriptions:            
//                          
//---------------------------------------------------------------------------------------- 
//****************************************************************************************// 
 
module tb();
    reg                                         clk_50M             ;
    reg                                         rst                 ;
    reg                                         uart_rxd            ;
    initial
        begin
                clk_50M <= 0;
                rst <= 1;
                uart_rxd <= 1;
            #200
                rst <= 0;
            #1000
                uart_rxd <= 1'b0;//起始位
            #8680
                uart_rxd <= 1'b1;//D0
            #8680
                uart_rxd <= 1'b0;//D1
            #8680
                uart_rxd <= 1'b1;//D2
            #8680
                uart_rxd <= 1'b0;//D3
            #8680
                uart_rxd <= 1'b1;//D4
            #8680
                uart_rxd <= 1'b0;//D5
            #8680
                uart_rxd <= 1'b1;//D6
            #8680
                uart_rxd <= 1'b0;//D7
            #8680
                uart_rxd <= 1'b1;//停止位
            #8680
                uart_rxd <= 1'b1;//空闲状态
            #8680
                uart_rxd <= 1'b0;//起始位
            #8680
                uart_rxd <= 1'b1;//D0
            #8680
                uart_rxd <= 1'b1;//D1
            #8680
                uart_rxd <= 1'b0;//D2
            #8680
                uart_rxd <= 1'b0;//D3
            #8680
                uart_rxd <= 1'b0;//D4
            #8680
                uart_rxd <= 1'b0;//D5
            #8680
                uart_rxd <= 1'b1;//D6
            #8680
                uart_rxd <= 1'b0;//D7
            #8680
                uart_rxd <= 1'b1;//停止位
            #8680
                uart_rxd <= 1'b1;//空闲状态   
        end
    localparam                                  CLK_FREQ           = 50    ; //MHZ 
    always #(500/CLK_FREQ)   clk_50M = ~clk_50M;
 

uart u_uart(
    .clk                                        (clk_50M            ),
    .rst                                        (rst                ),
    .uart_rxd                                   (uart_rxd           ) 
);
     
        endmodule