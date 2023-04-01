`timescale 1ns / 1ps //设置时间精度及最小单位
module fryer_tb();
	
reg		clk=0;
reg		rst_n=0;
wire [7:0]	ROW;
wire [7:0]	COLR;
wire [7:0]	COLG;
wire [7:0] SEG_DATA;
wire [7:0] SEG_EN;

reg       SW3;
reg		BTN0=0;  //开始
reg		BTN4=0;  //选择火力
reg		BTN6=0;  	//加1 DISP6
reg		BTN7=0;  //加1  DISP7	
reg     BTN3=0;  //复位
reg     BTN5=0; //暂停
	
//仿真用到的端口及其定义
	
fryer i1(
.clk(clk),
.rst_n(rst_n),
.ROW(ROW),
.COLR(COLR),
.COLG(COLG),
.SW3(SW3),
.SEG_DATA(SEG_DATA),
.SEG_EN(SEG_EN),
.buzzer(buzzer),
.LD15(LD15),
// .LCD_E(LCD_E),
// .LCD_RS(LCD_RS),
.BTN0(BTN0),   //开始
.BTN3(BTN3),
.BTN4(BTN4),   //选择火力
.BTN5(BTN5),zhi
.BTN6(BTN6),   	//加1 DISP6
.BTN7(BTN7)   //加1  DISP7
    );	
//调用顶层文件模块

defparam 	i1.u0.CNT_NUM = 4;
defparam 	i1.u1.T_1S = 1000;

//设置时钟频率
always #10 clk =~clk;// 1s=1000*20 = 20000

initial
begin
SW3 =0;
#100
rst_n =1;
//初始化

#10000;//延时5s
SW3 =1;//开机

BTN4 = 1;//设定模式
#200;
BTN4 = 0;
#1000;

repeat(7)//按七下 设置个位时间
begin
BTN6 =1;
#200;
BTN6 = 0;
#1000;
end

repeat(2)//两下 十位时间  对应27
begin
BTN7 =1;
#200;
BTN7 = 0;
#1000;
end

BTN0 = 1;//开始加热
#200;
BTN0 = 0;

#3_00_000;//=15s 等待十五秒

BTN5 = 1;//复位 回到待机
#200
BTN5 = 0;

repeat(12)//按动十二次 循环 对应2
begin
BTN6 =1;
#200;
BTN6 = 0;
#1000;
end

repeat(2)//按动两次 
begin
BTN7 =1;
#200;
BTN7 = 0;
#1000;
end

BTN0 = 1;//开始加热
#200;
BTN0 = 0;

#1_00_000;//五秒

BTN3 = 1;//暂停
#200;
BTN3 = 0;

repeat(12)//按动十二次 循环 对应2
begin
BTN6 =1;
#200;
BTN6 = 0;
#1000;
end

repeat(2)//按动两次 
begin
BTN7 =1;
#200;
BTN7 = 0;
#1000;
end

BTN0 = 1;//开始加热
#200;
BTN0 = 0;

#1_00_000;//五秒

repeat(1)//此时按动无效
begin
BTN6 =1;
#200;
BTN6 = 0;
#1000;
end

repeat(1)//按动无效
begin
BTN7 =1;
#200;
BTN7 = 0;
#1000;
end

#6_00_000;//等待三十秒，加热结束

$stop;
end	

endmodule
