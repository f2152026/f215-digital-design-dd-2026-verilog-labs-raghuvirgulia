module tb;

 reg t_op;
 reg [3:0] t_a;
 reg [3:0] t_b;
 wire [3:0] t_res;

 reg [3:0] exp_res;
 integer errors=0;
 integer i, j, op;
 string vcd_file;

 alu DUT (
    .op(t_op),
    .a(t_a),
    .b(t_b),
    .result(t_res)
 );

 initial begin
    if ($value$plusargs("vcd=%s", vcd_file)) begin
      $dumpfile(vcd_file);
      $dumpvars(0, DUT);
    end
  end

initial begin
    for(op=0;op<2;op=op+1) begin
        for(i=0;i<16;i=i+1) begin
            for(j=0;j<16;j=j+1) begin
                t_op=op[0];  //op is 1 bit as integer vars are 32 bits wide in verilog
                t_a= i[3:0];
                t_b=j[3:0];

                exp_res= (t_op == 1'b0) ? (t_a+t_b) : (t_a - t_b);

                #5; //allow logic propagation

                if (t_res !== exp_res) begin
                    $display("FAIL at %0t: op=%b a=%d b=%d | got result=%d, expected result=%d",
                     $time, t_op, t_a, t_b, t_res, exp_res);
            errors = errors + 1;
          end
        end
      end
    end

    if(errors==0)
    $display("PASS: All ALU test cases passed!");
    else
      $display("FAIL: %0d total mismatches found.", errors);

    $finish;
  end

endmodule