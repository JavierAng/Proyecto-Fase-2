`timescale 1ns/1ns
module Mux2_1(
    input sel,
    input [31:0] A,
    input [31:0] B,
    output reg [31:0] C
);

always@(*)
begin
    if(sel == 1'b0)
        begin
            C = B;
        end
    else
        begin
            C = A;
        end 
end

endmodule
