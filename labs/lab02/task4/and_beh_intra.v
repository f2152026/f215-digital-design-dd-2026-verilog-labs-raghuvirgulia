module and_beh_intra (
  input      a,
  input      b,
  output reg y
);
  always @(*) begin
    y = #1 a & b; // Evaluates instantly, delays writing to y
  end
endmodule