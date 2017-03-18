/*
--创建日期   : 2015-05-05
--目标芯片   : EP4CE22F17C8
--时钟选择   : pxlClk<=165MHz
--演示说明   : rst全局复位低有效，
              h/vcnt为当前像素位置输出，h/vsize为图像尺寸输出，
              pixel_*_out为像素输出
*/
module simpleyuv(
  input wire pxlClk,
  input wire rst,
  input wire[11:0] hcnt,
  input wire[11:0] vcnt,
  input wire[11:0] hsize,
  input wire[11:0] vsize,
  
  output wire[15:0] data,
  
  input wire pause
);

reg[32:0] counter;
wire[1:0] picNum;
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

assign picNum = counter[29:27];

assign data = 
  (picNum == 3'd0)?(
    (hcnt[0]?(
      {hcnt[8:1], 8'd128}
    ):(
      {vcnt[8:1], 8'd128}
    ))
  ):((picNum == 3'd1)?(
    (hcnt[0]?(
      {8'd1 << hcnt[7:5], 8'd128}
    ):(
      {8'd1 << vcnt[7:5], 8'd128}
    ))
  ):((picNum == 3'd2)?(
    (hcnt[0]?(
      {8'd128, vcnt[8:1]}
    ):(
      {hcnt[8:1], vcnt[8:1]}
    ))
  ):((picNum == 3'd3)?(
    (hcnt[0]?(
      {8'd128, 8'd1 << vcnt[7:5]}
    ):(
      {8'd1 << hcnt[7:5], 8'd1 << vcnt[7:5]}
    ))
  ):((picNum == 3'd4)?(
    (hcnt[0]?(
      {vcnt[8:1], hcnt[8:1]}
    ):(
      {8'd128, hcnt[8:1]}
    ))
  ):((picNum == 3'd5)?(
    (hcnt[0]?(
      {8'd1 << vcnt[7:5], 8'd1 << hcnt[7:5]}
    ):(
      {8'd128, 8'd1 << hcnt[7:5]}
    ))
  ):(
    (hcnt[0]?(
      {hcnt[8:1], counter[27:20]}
    ):(
      {vcnt[8:1], counter[27:20]}
    ))
  ))))));
  

endmodule