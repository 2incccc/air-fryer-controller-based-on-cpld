module state_control(
    //输入
    input clk_1Khz,//外部时钟，频率1Khz
    input rst,//复位
    input SW3,//开关，SW3
    input BTN0,//开始，使用消抖后信号，下同
    input BTN1,//复位
    input BTN3,//暂停
    input BTN4,//设置模式
    input BTN6,//设置时间个位
    input BTN7,//设置时间十位
    //输出
    output mode,//加热模式
    output state,
    output led,//LD15, 开机指示灯
    //FIXME output matrix_enable,
    output reg [11:0] disp_data,//数码管需要展示的数字
    output reg buzzer//蜂鸣器


);

parameter IDLE = 3'd0;//以下为四种工作状态，最初待机（只有LD指示灯亮，其余全灭），加热结束
parameter PREPARE = 3'd3;//准备加热，（可以开始设置时间及模式），暂停后同样转换到此状态
parameter WORK = 3'd1;//开始加热，（可设置时间及模式）
parameter FINISH =3'd2;//加热结束（蜂鸣器响鸣）
parameter PAUSE = 3'd4;//暂停状态，与待机状态区别在于点阵状态，其余相同

parameter T_1S=1_000;//外部时钟频率1000hz 对应一秒时间

reg [3:0] disp_data_6;//时间个位
reg [3:0] disp_data_7;//时间十位
reg [3:0] disp_data_4;//模式数字
reg [2:0] STATE;//状态





reg [31:0] cnt_time;//倒计时中的总时间，与设置的加热时间所对应
reg [2:0] cnt_for_finish;//结束后用于蜂鸣器的倒计时
reg [6:0] cnt_1s;// 这个是计算一秒的计数器，至多为T_1S

//FIXME assign disp_data={disp_data_4,disp_data_7,disp_data_6};
//FIXME assign buzzer_enable = (state==FINISH)?1:0;
//FIXME assign disp_data_4=disp_data_4;

always@(posedge clk_1Khz or negedge rst)//状态转移函数
begin
    if(!rst)//初始化
    begin
        STATE <= IDLE;
        disp_data_6 <= 0;
        disp_data_7 <= 0;
        disp_data_4<=0;
        cnt_for_finish <= 0;
        cnt_1s <= 0;
        matrix_enable_reg <= 0;
    end
    else if(SW3 == 1)//开机
    begin
        case(STATE)
        IDLE://最初的待机状态
        begin
            if(BTN6)//按键后状态转移至准备状态，下同 
                begin
                STATE<= PREPARE;
                end
            if(BTN7)
                begin
                STATE<=PREPARE;
                end
                if(BTN4)
                begin
                STATE<=PREPARE;
                end
        end
        PREPARE://准备状态，可设置加热时间、加热模式
        begin
            if(BTN6)//设置时间个位
            begin
                if(disp_data_6 < 9)
                disp_data_6 <= disp_data_6 + 1;
                else
                begin
                disp_data_6 <= 0;
                disp_data_7 <= disp_data_7 + 1;
                end
            end
            if(BTN7)//设置时间十位
            begin
                if(disp_data_7<9)
                disp_data_7 <= disp_data_7 + 1;
                else
                disp_data_7 <= 0;
            end
            if(BTN4)//设置模式
            begin
                if(disp_data_4<3)
                disp_data_4 <= disp_data_4+1;
                else
                disp_data_4 <= 1;
            end
            if(BTN0) //点击开火
            begin
                STATE <= WORK;
                cnt_time<=disp_data_7*10 + disp_data_6;//将前面设置的时间赋值给倒计时时间
            end
        end
        WORK://加热状态
        begin
            disp_data_6<=0;
            disp_data_7<=0;
            // matrix_enable_reg <= 1'b1;
            if(cnt_1s<T_1S)//等效分频操作，一秒计数器
            begin
                cnt_1s <= cnt_1s + 1;
                if(BTN1)//加热过程中可复位（回到待机状态）
                begin
                STATE<=IDLE;//状态结束至待机状态
                end
            end
            else//计数器计数一秒
            begin
                cnt_1s<=0;
                if(cnt_time == 0)//若加热最终结束
                begin
                cnt_time<=0;
                STATE<=FINISH;//状态转移至结束状态
                end
                else//若加热未结束
                cnt_time <= cnt_time -1;//倒计时减一秒
            if(BTN1)
            begin
                STATE<=IDLE;
                buzzer<=0; 
                disp_data_6<=0;
                disp_data_7<=0;
                mode <=1;
                cnt_time<=0;
                cnt_1s<=0;
                cnt_for_finish<=0;
            end
            if(BTN3)
            begin
                disp_data_7<=time_cnt/10;
                disp_data_6<=time_cnt%10;//给`disp_data`赋值，回到暂停状态，可重新设置时间及模式
                state<=PAUSE;//转移至暂停状态
            end
            end
            disp_data_6<=cnt_time%10;
            disp_data_7<=cnt_time/10;//加热状态下，数码管显示时间需要通过加热倒计时计算得到
        end
        PAUSE:
        begin
            if(BTN6)//设置时间个位
            begin
                if(disp_data_6 < 9)
                disp_data_6 <= disp_data_6 + 1;
                else
                begin
                disp_data_6 <= 0;
                disp_data_7 <= disp_data_7 + 1;
                end
            end
            if(BTN7)//设置时间十位
            begin
                if(disp_data_7<9)
                disp_data_7 <= disp_data_7 + 1;
                else
                disp_data_7 <= 0;
            end
            if(BTN4)//设置模式
            begin
                if(disp_data_4<3)
                disp_data_4 <= disp_data_4+1;
                else
                disp_data_4 <= 1;
            end
            if(BTN0) //点击开火
            begin
                STATE <= WORK;
                cnt_time<=disp_data_7*10 + disp_data_6;//将前面设置的时间赋值给倒计时时间
            end
            //上方与准备状态部分操作一致，区别见点阵控制模块。
            //XXX 这里出现代码复用，可以完善，性能有待提高
        end
        FINISH://加热结束状态
        begin
            if(cnt_for_finish==3)//计时三秒后回到待机状态
            begin
                cnt_for_finish<=0;
                disp_data_4<=1;
                STATE<=IDLE;//状态转移至待机状态
            end
            else
            begin
                if (cnt_1s==T_1S)//计时器计时一秒
                begin
                cnt_for_finish<=cnt_for_finish+1;//计时加一，等效分频
                end
                else if(cnt_1s<500)//一秒计数一千次，五百次计数对应前半秒
                begin
                buzzer<=cnt_time[5];//无源蜂鸣器响鸣
                cnt_1s<=cnt_1s+1;//计数器加一
                end
                else
                begin
                buzzer<=1'd0;
                cnt_1s<=cnt_1s+1;//同上，计数器加一
                end
            end
        end
        endcase
    end
end

//模块输出，LD15指示灯赋值
assign led = SW3;

//模块输出，用于控制点阵模块
assign mode = disp_data_4;//直接用模式数码管显示的数字给模式赋值
assign state = STATE;

//FIXME assign matrix_enable = matrix_enable_reg;

always@(posedge clk_1Khz or negedge rst)//模块输出，用于控制数码管显示模块
begin
    if(!rst)
    begin
        disp_data <= 12'b0000_0000_0000;
    end
    else if(SW3==0||STATE == IDLE)//关机或待机状态
    begin
        disp_data <= 12'b0000_0000_0000;//数码管不显示
    end
    else if(STATE == PREPRARE)//准备状态
    begin
        disp_data = {disp_data_4,disp_data_7,disp_data_6};//准备状态，数码管实时显示设置的数字
    end
    else if (STATE == WORK)//加热状态
    begin
        disp_data = {disp_data_4,counting_time/10,counting_time%10};//加热状态，时间显示为倒计时的时间
    end
end
endmodule