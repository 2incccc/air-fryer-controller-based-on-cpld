module two_color_matrix(
    input clk_1Khz,//外部时钟信号 1kHz
    input rst,//reset
    input state,//加热状态，相当于点阵点亮使能信号
    input mode,//加热模式，与点阵颜色直接相关
    //FIXME input matrix_enable,

    output  reg [7:0] row,//点阵行信号
    output  reg [7:0] colr,//红色点亮
    output  reg [7:0] colg//绿色点亮



);
    parameter T_1S = 1_000;//一秒时间，用于分频

    
    reg [7:0] col;//点亮信号
    reg [1:0] cnt_pic;//计数显示的第几张图
    reg [2:0] cnt_row;//计数显示的第几行


always@(posedge clk_1Khz or negedge rst)//行扫描，无需分频，类似三八译码器
begin
    if (~rst)
        cnt_row = 0;
    else   
    if (cnt_row == 3'b111)
        begin
            cnt_row = 3'b000;
        end
    else 
        begin
            cnt_row  <= cnt_row + 1;
        end
end

reg cnt_pic_1s;//用于点阵图形扫描的分频计数器

always@(posedge clk_1Khz)//内部分频，对图扫描
begin
    if(rst)
        begin
            cnt_pic <= 0;
            cnt_pic_1s <= 0;
        end
    else if (state == WORK || state == PAUSE)//当且仅当状态为加热或暂停时，点阵才开始工作，下同
        if(cnt_pic_1s == T_1S)//若计时一秒
        begin
            cnt_pic_1s <= 0;//秒计时清零
            if(cnt_pic == 2'b11)
            begin
                cnt_pic <= 2'b00;
            end
            else
                cnt_pic <= cnt_pic + 1;
        end
        else 
            cnt_pic_1s <= cnt_pic_1s + 1;
end

always@(*)
begin
    if(state == WORK || state == PAUSE)//当且仅当状态为加热或暂停时，点阵才开始工作，上同
    begin
        case(cnt_pic)//对图判断
        2'b00://第一幅图
        begin
            case(cnt_row)//对行判断
            3'b000://第一行，下同
            begin
                ROW = 8'b0111_1111;
                COL = 8'b0000_0000;
            end
            3'b001://第二行，下同
            begin
                ROW = 8'b1011_1111;
                COL = 8'b0000_0000;
            end
            3'b010://第三行，下同
            begin
                ROW = 8'b1101_1111;
                COL = 8'b0010_0100;
            end
            3'b011://第四行，下同
            begin
                ROW = 8'b1110_1111;
                COL = 8'b0001_1000;
            end
            3'b100://第五行，下同
            begin
                ROW = 8'b1111_0111;
                COL = 8'b0001_1000;
            end
            3'b101://第六行，下同
            begin
                ROW = 8'b1111_1011;
                COL = 8'b0010_0100;
            end
            3'b110://第七行，下同
            begin
                ROW = 8'b1111_1101;
                COL = 8'b0000_0000;
            end
            3'b111://第八行，下同
            begin
                ROW = 8'b1111_1110;
                COL = 8'b0000_0000;
            end
            endcase
        end
        2'b01://第一幅图
        begin
            case(cnt_row)
            3'b000:
            begin
                ROW = 8'b0111_1111;
                COL = 8'b0000_0000;
            end
            3'b001:
            begin
                ROW = 8'b1011_1111;
                COL = 8'b0000_0000;
            end
            3'b010:
            begin
                ROW = 8'b1101_1111;
                COL = 8'b0011_1100;
            end
            3'b011:
            begin
                ROW = 8'b1110_1111;
                COL = 8'b0011_1100;
            end
            3'b100:
            begin
                ROW = 8'b1111_0111;
                COL = 8'b0011_1100;
            end
            3'b101:
            begin
                ROW = 8'b1111_1011;
                COL = 8'b0011_1100;
            end
            3'b110:
            begin
                ROW = 8'b1111_1101;
                COL = 8'b0000_0000;
            end
            3'b111:
            begin
                ROW = 8'b1111_1110;
                COL = 8'b0000_0000;
            end
            endcase
        end
        2'b10://第三幅图
        begin
            case(cnt_row)
            3'b000:
            begin
                ROW = 8'b0111_1111;
                COL = 8'b0000_0000;
            end
            3'b001:
            begin
                ROW = 8'b1011_1111;
                COL = 8'b0100_0010;
            end
            3'b010:
            begin
                ROW = 8'b1101_1111;
                COL = 8'b0011_1100;
            end
            3'b011:
            begin
                ROW = 8'b1110_1111;
                COL = 8'b0011_1100;
            end
            3'b100:
            begin
                ROW = 8'b1111_0111;
                COL = 8'b0011_1100;
            end
            3'b101:
            begin
                ROW = 8'b1111_1011;
                COL = 8'b0011_1100;
            end
            3'b110:
            begin
                ROW = 8'b1111_1101;
                COL = 8'b0100_0010;
            end
            3'b111:
            begin
                ROW = 8'b1111_1110;
                COL = 8'b0000_0000;
            end
            endcase
        end
        2'b11://第四幅图
        begin
            case(cnt_row)
            3'b000:
            begin
                ROW = 8'b0111_1111;
                COL = 8'b0000_0000;
            end
            3'b001:
            begin
                ROW = 8'b1011_1111;
                COL = 8'b0111_1110;
            end
            3'b010:
            begin
                ROW = 8'b1101_1111;
                COL = 8'b0111_1110;
            end
            3'b011:
            begin
                ROW = 8'b1110_1111;
                COL = 8'b0111_1110;
            end
            3'b100:
            begin
                ROW = 8'b1111_0111;
                COL = 8'b0111_1110;
            end
            3'b101:
            begin
                ROW = 8'b1111_1011;
                COL = 8'b0111_1110;
            end
            3'b110:
            begin
                ROW = 8'b1111_1101;
                COL = 8'b0111_1110;
            end
            3'b111:
            begin
                ROW = 8'b1111_1110;
                COL = 8'b0000_0000;
            end
            endcase
        end
    endcase
    end
end


always@(*)
    begin
        case(mode)
        2'b00:
        {colr,colg}={8'b00000000,8'b00000000};
        2'b01:
        {colr,colg}={8'b00000000,col};
        2'b10:
        {colr,colg}={col,col};
        2'b11:
        {colr,colg}={col,8'b00000000};
        endcase
    end

endmodule
