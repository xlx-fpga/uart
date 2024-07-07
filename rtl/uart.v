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
// Last modified Date:     2024/07/05 17:35:23 
// Last Version:           V1.0 
// Descriptions:            
//---------------------------------------------------------------------------------------- 
// Created by:             xlx_fpga
// Created date:           2024/07/05 17:35:23 
// Version:                V1.0 
// TEXT NAME:              uart.v 
// PATH:                   E:\3.xlx_fpga\4.uart\rtl\uart.v 
// Descriptions:            
//                          
//---------------------------------------------------------------------------------------- 
//****************************************************************************************// 

module uart(
    input                                       clk                 ,
    input                                       rst                 ,
    input                                       uart_rxd            ,
    output                                      uart_txd             
);
                                                                   
    wire               [7: 0]                   rx_data             ;
    wire                                        rx_done             ;

    wire                                        uart_txd            ;

uart_rx#(
    .CLK_FREQ                                   (50_000_000         ),
    .UART_BPS                                   (115200             ) 
)
 u_uart_rx(
    .clk                                        (clk                ),
    .rst                                        (rst                ),
    .uart_rxd                                   (uart_rxd           ),
    .rx_data                                    (rx_data            ),
    .rx_done                                    (rx_done            ) 
);

uart_tx#(
    .CLK_FREQ                                   (50_000_000         ),
    .UART_BPS                                   (115200             ) 
)
 u_uart_tx(
    .clk                                        (clk                ),
    .rst                                        (rst                ),
    .rx_done                                    (rx_done            ),
    .rx_data                                    (rx_data            ),
    .uart_txd                                   (uart_txd           ) 
);
                                                                  
        endmodule
