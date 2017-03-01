/*
--创建日期   : 2015-06-15
--目标芯片   : EP4CE22F17C8
--时钟选择   : pxlClk<=165MHz
--演示说明   : rst全局复位低有效，h/vsync为同步信号输入，de为像素有效输入，
              h/vsync_o为校正后同步信号输出（低有效），de为像素有效输出 
*/
module syncCorrector(
  input wire pxlClk,
  input wire rst,
  
  input wire vsync,
  input wire hsync,
  input wire de,
  
  output wire vsync_o,
  output wire hsync_o,
  output wire de_o
);

wire normalVsync, normalHsync;

syncPolDecter hdect (
  .pxlClk(pxlClk),
  .rst(rst),
  
  .sync(hsync),
  .normalSync(normalHsync)
);

syncPolDecter vdect (
  .pxlClk(pxlClk),
  .rst(rst),
  
  .sync(vsync),
  .normalSync(normalVsync)
);

assign de_o = de && hsync_o && vsync_o;
assign hsync_o = normalHsync == hsync;
assign vsync_o = normalVsync == vsync;

/*
always @(posedge pxlClk or negedge rst) begin
  if(!rst)begin
    normalHsync <= 1'b1;
    normalVsync <= 1'b1;
  end else begin
    if (de) begin
      normalHsync <= hsync;
      normalVsync <= vsync;
    end
  end
end
*/

endmodule

module syncPolDecter(
  input wire pxlClk,
  input wire rst,
  
  input wire sync,
  
  output reg normalSync

);

reg [24:0] lowCount;
reg [24:0] highCount;
reg sync_d1;

always @(posedge pxlClk or negedge rst) begin
  if(!rst) begin
    sync_d1 <= 1'b0;
  end else begin
    sync_d1 <= sync;
  end
end


always @(posedge pxlClk or negedge rst) begin

  if(!rst) begin
    lowCount <= 24'd0;
    highCount <= 24'd0;
    normalSync <= 1'b1;
  end else begin
    if(sync) begin
      if(!sync_d1) begin
        normalSync <= highCount > lowCount;
        lowCount <= 24'd0;
        highCount <= 24'd0;
      end else begin 
        highCount <= highCount + 1;
      end
    end else begin 
      if(sync_d1) begin
        lowCount <= 24'd0;
      end else begin
        lowCount <= lowCount + 1;
      end
    end
  end

end


endmodule