module freq_div(
    input clk_1Khz,
    input rst,
    output reg clk_1hz
);

parameter N = 26'd1_000 , WIDTH = 25;
reg [WIDTH:0] counter;

always @(posedge clk_1Khz or negedge rst) begin
	if (~rst) begin
		counter <= 0;
		clk_1hz <= 0;
	end
	else if (counter == N-1) begin
		clk_1hz <= ~clk_1hz;
		counter <= 0;
	end
	else
		counter <= counter + 1;
end

endmodule