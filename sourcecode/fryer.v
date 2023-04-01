module fryer(
    //输入
    input clk_1Khz,
    input rst,
    input SW3,//开关
    input btn0,//开始
    input btn1,//复位
    input btn3,//暂停
    input btn4,//设置模式
    input btn6,//设置时间个位
    input btn7,//设置时间十位

    //输出
    output  [7:0] seg_data,//数码管段码
    output  [7:0] seg_en,//数码管位码

    output led,//LD15 LED指示灯
    output buzzer,//蜂鸣器
    output  [7:0] row,//点阵行信号
    output  [7:0] colr,//点阵红色信号
    output  [7:0] colg//点阵绿色信号
);

//消抖后按键脉冲信号
wire BTN0,BTN1.BTN3,BTN4,BTN6,BTN7;

//控制点阵的中间信号
wire state;
wire mode;

//控制数码管显示数据的中间信号
wire [11:0] disp_data;

//调用按键消抖模块
debounce u1(
    .clk(clk_1Khz),
    .rst(rst),
    .key({btn0,btn1,btn3,btn4,btn6,btn7}),
    .key_pulse({BTN0,BTN1,BTN3,BTN4,BTN6,BTN7})
);

state_control u2(
    .clk_1Khz(clk_1Khz),
    .rst(rst),
    .SW3(SW3),
    .BTN0(BTN0),//开始
    .BTN1(BTN1),
    .BTN4(BTN4),//选择火力
    .BTN6(BTN6),//加1 DISP6
    .BTN7(BTN7),//加1  DISP7
    .disp_data(disp_data),//数码管时间
    .buzzer(buzzer),//蜂鸣器
    .state(state),
    .mode(mode),
    .led(led)
    //FIXME .matrix_enable(matrix_enable)
);


two_color_matrix u3(
    .clk_1Khz(clk_1Khz),
    .rst(rst),
    //FIXME .SW3(SW3),
    .state(state)
    .mode(mode),//点阵图的模式，小火中火大火
    //FIME .matrix_enable(matrix_enable),
    .colr(colr),//红色
    .row(row),//行扫描
    .colg(colg),//绿色
);

seg_counter u4(
    .clk_1Khz(clk_1Khz),
    .rst(rst),
    .disp_data_7(disp_data[11:8]),
    .disp_data_6(disp_data[7:4]),
    .disp_data_4(disp_data[3:0]),
    .seg_data(seg_data),
    .seg_en(seg_en)
);

endmodule
