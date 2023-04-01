module seg_counter
(
    //输入端口 
    input clk_1Khz,
    input rst,
    input  disp_data_6,
    input  disp_data_7,
    input  disp_data_4,//输出端口

    
    output reg [7:0] seg_data,//数码管段选
    output reg [7:0] seg_en//数码管位选
);


    always@(posedge clk_1Khz or negedge rst)//数码管动态显示，根据题目要求，数码管中6管7管4管轮流显示
    begin
            case(seg_en)
                8'b10111111:seg_en<=8'b01111111;
                8'b01111111:seg_en<=8'b11110111;
                8'b11110111:seg_en<=8'b10111111;//数码管位选随时钟频率，轮流扫描显示
            endcase
    end

    always@(posedge clk_1Khz or posedge rst)
    begin
        if(rst)
            seg_data<=8'b00000000;
        else
            begin
                case(seg_en)
                    8'b10111111://DISP6的输出
                        begin
                            case(disp_data_6)
                                3'b0000:seg_data<=8'b00111111;
                                3'b0001:seg_data<=8'b00000110;
                                3'b0010:seg_data<=8'b01011011;
                                3'b0011:seg_data<=8'b01001111;
                                3'b0100:seg_data<=8'b01100110;
                                3'b0101:seg_data<=8'b01101101;
                                3'b0110:seg_data<=8'b01111101;
                                3'b0111:seg_data<=8'b00000111;
                                3'b1000:seg_data<=8'b01111111;
                                3'b1001:seg_data<=8'b01101111;
                                default:seg_data<=8'b0000000;//数码管管脚分配，下同
                            endcase
                        end
                    8'b01111111://DISP7的输出
                        begin
                            case(disp_data_7)
                                3'b0000:seg_data<=8'b00111111;
                                3'b0001:seg_data<=8'b00000110;
                                3'b0010:seg_data<=8'b01011011;
                                3'b0011:seg_data<=8'b01001111;
                                3'b0100:seg_data<=8'b01100110;
                                3'b0101:seg_data<=8'b01101101;
                                3'b0110:seg_data<=8'b01111101;
                                3'b0111:seg_data<=8'b00000111;
                                3'b1000:seg_data<=8'b01111111;
                                3'b1001:seg_data<=8'b01101111;
                                default:seg_data<=8'b0000000;//数码管管脚分配，下同
                            endcase
                        end
                    8'b11110111://DISP4的输出
                        begin
                            case(disp_data_4)
                                3'b0000:seg_data<=8'b00111111;
                                3'b0001:seg_data<=8'b00000110;
                                3'b0010:seg_data<=8'b01011011;
                                3'b0011:seg_data<=8'b01001111;
                                3'b0100:seg_data<=8'b01100110;
                                3'b0101:seg_data<=8'b01101101;
                                3'b0110:seg_data<=8'b01111101;
                                3'b0111:seg_data<=8'b00000111;
                                3'b1000:seg_data<=8'b01111111;
                                3'b1001:seg_data<=8'b01101111;
                                default:seg_data<=8'b0000000;//数码管管脚分配，下同
                            endcase
                        end
                endcase
                //XXX 此处出现大量重复代码，有待优化
            end
    end
endmodule