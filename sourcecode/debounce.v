module debounce (clk,rst,key,key_pulse);
    parameter   N=6;
	   //要消除的按键的数量
		input clk;
		input rst;
		input [N-1:0] key;//输入的按键;
		output [N-1:0] key_pulse;//按键动作产生的脉冲

        reg [N-1:0]  key_rst_pre;//定义一个寄存器型变量储存上一个触发时的按键值
		reg [N-1:0]  key_rst;//定义一个寄存器型变量储存当前时刻触发的按键值

		wire [N-1:0]  key_edge;//检测边缘变化，将两个时钟触发时按键状态储存在两个寄存器变量中


		always@ (posedge clk or negedge rst)
		begin 
		if (!rst)
			begin
			key_rst<={N{1'b1}};//初始化时给key_rst赋值全为1，{}中表示N个1
			key_rst_pre<={N{1'b1}} ;
			end
			else
			begin
			key_rst<=key;
			key_rst_pre<=key_rst;
			//相当于经过两个时钟触发，key_rst储存的是当前时刻key的值
			//key_rst_pre储存的是前一个时钟的key的值
			end
		end 
		
	assign key_edge = key_rst_pre & (~key_rst);
	reg [17:0]  cnt;//产生20ms延时，当检测到key_edge有效是计数器清零开始计数
	always @(posedge clk or negedge rst)
	begin 
		if (!rst)
			cnt<= 18'h0;
			else if (key_edge)cnt<= 18'h0;	
					else
					cnt <=cnt + 1'h1;
			end
			
			reg  [N-1:0]  key_sec_pre;//延时后检测电平寄存器变量
			reg  [N-1:0]  key_sec;//延时后检测key,如果按键状态遍地说明产生一个时钟的高脉冲，如果按键状态是高说明按键无效
			
	always @(posedge clk or negedge rst)
	begin 
		if (!rst)
		key_sec<={N{1'b1}};
		else if (cnt==18'h3ffff)key_sec<=key;
		end
	always @(posedge clk or negedge rst)
	begin 
		if (!rst)
			key_sec_pre<={N{1'b1}};
			else key_sec_pre<=key_sec;
		end
	assign key_pulse = key_sec_pre & (~key_sec);
	
endmodule