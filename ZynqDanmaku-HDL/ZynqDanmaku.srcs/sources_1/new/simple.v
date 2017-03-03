/*
--创建日期   : 2015-05-05
--目标芯片   : EP4CE22F17C8
--时钟选择   : pxlClk<=165MHz
--演示说明   : rst全局复位低有效，
              h/vcnt为当前像素位置输出，h/vsize为图像尺寸输出，
              pixel_*_out为像素输出
*/
module simple(
  input wire pxlClk,
  input wire rst,
  input wire[11:0] hcnt,
  input wire[11:0] vcnt,
  input wire[11:0] hsize,
  input wire[11:0] vsize,
  
  output wire[7:0] pixel_r_out,
  output wire[7:0] pixel_g_out,
  output wire[7:0] pixel_b_out,
  output wire[7:0] pixel_a_out,
  
  input wire pause
);

reg[32:0] counter;
wire[1:0] picNum;
wire[7:0] realAlpha;
reg[1:0] pause_reg;

always @(posedge pxlClk or negedge rst) begin
  if(!rst) begin
    counter <= 0;
	 pause_reg <= 2'b0;
  end else begin
	 pause_reg <= {pause_reg[0], pause};
    counter <= counter + pause_reg[1];
  end
end

assign picNum = counter[28:27];

assign pixel_a_out = realAlpha;
assign {pixel_r_out, pixel_g_out, pixel_b_out, realAlpha} = 
  (picNum == 2'd0)?(
    (hcnt == 11'd400 || vcnt == 11'd300) ? 32'h00_00_00_ff : 32'h00_00_00_00
  ):((picNum == 2'd1)?(
    (hcnt == 11'd799 || vcnt == 11'd599) ? 32'h00_00_00_ff : 32'h00_00_00_00
  ):((picNum == 2'd2)?(
    (hcnt < 11'd600 && hcnt > 11'd200 && vcnt < 11'd 450 && vcnt > 11'd150) ? 32'h00_00_00_ff: 32'h00_00_00_00
  ):(
    ((hcnt[4] == 0 && vcnt[4] == 0) || (hcnt[4] == 1 && vcnt[4] == 1)) ? 32'h00_00_00_ff: 32'h00_00_00_00
  )));
  

endmodule