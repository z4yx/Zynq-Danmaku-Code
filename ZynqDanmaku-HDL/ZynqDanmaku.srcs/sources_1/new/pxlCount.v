/*
--创建日期   : 2015-05-18
--目标芯片   : EP4CE22F17C8
--时钟选择   : odck<=165MHz
--演示说明   : rst全局复位低有效，odck为像素时钟，v/hsyncIn为同步信号输入，
              scdt为信号有效输入，deIn为数据有效信号输入，
              now*为当前像素位置输出，screen*为屏幕分辨率输出，ovf为计数器溢出指示
*/
module pxlCounter(
  input wire odck,
  input wire scdt,
  input wire vsyncIn,
  input wire hsyncIn,
  input wire deIn,
  input wire rst,

  output reg [15:0] nowX,
  output reg [15:0] nowY,
  output reg [31:0] nowPxl,

  output reg [15:0] screenX,
  output reg [15:0] screenY,
  output reg [31:0] screenPxl,
  
  output wire ovf
);

reg ovfX, ovfY;
reg thisOvfX, thisOvfY, thisOvfZ;
reg lastDe, lastVsync;

wire vsync, hsync, de;

syncCorrector corrector1(
  odck,
  rst,
  
  vsyncIn,
  hsyncIn,
  deIn,
  
  vsync,
  hsync,
  de
);

assign ovf = ovfX | ovfY;


always @(posedge odck or negedge rst) begin

  if (rst == 0) begin
    nowX <= 0;
    nowY <= 0;
    nowPxl <= 0;
    screenX <= 0;
    screenY <= 0;
    screenPxl <= 0;
    lastDe <= 0;
    ovfX <= 0;
    ovfY <= 0;
  end else if (scdt == 0) begin
    nowX <= 0;
    nowY <= 0;
    nowPxl <= 0;
    screenX <= 0;
    screenY <= 0;
    screenPxl <= 0;
    lastDe <= 0;
  end else begin
  
    lastVsync <= vsync;
    lastDe <= de;
    //for X counting
    if(de) begin
      nowX <= nowX + 1;
    end else begin
      if(lastDe)begin
        screenX <= nowX;
      end
      nowX <= 0;
    end
    
    //for Y counting
    
    if(!de) begin
      if(lastDe)begin
        nowY <= nowY + 1;
      end else if(!vsync) begin
        if(lastVsync) begin
          screenY  <= nowY;
        end
        nowY <= 0;
      end 
    end
    
    // for Pxl counting
    
    if(de) begin 
      nowPxl <= nowPxl + 1;
    end else begin
      if(!vsync) begin
        if(lastVsync) begin
          screenPxl <= nowPxl;
        end
        nowPxl <= 0;
      end
    end
  end

end



endmodule