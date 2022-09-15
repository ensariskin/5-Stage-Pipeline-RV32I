`timescale 1ns / 1ps


module FA(
    input x,
    input y,
    input ci,
    output cout,
    output s);

    wire c0, c1, s0;
    HA half_adder_1(
        .x(x),
        .y(y),
        .cout(c0),
        .s(s0));
    HA half_adder_2(
        .x(ci),
        .y(s0),
        .cout(c1),
        .s(s));
    
    assign cout = c0 | c1;

endmodule
