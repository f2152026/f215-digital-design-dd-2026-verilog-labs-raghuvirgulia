module tb;

//signals to drive DUT
reg [1:0] t_a;
reg [1:0] t_b;
wire t_gt;
wire t_lt;
wire t_eq;

//expected signals calculated inside testbench
reg exp_gt;
reg exp_lt;
reg exp_eq;

integer errors=0;
integer i, j;
string vcd_file;

comp2 DUT (
    .A(t_a),
    .B(t_b),
    .GT(t_gt),
    .LT(t_lt),
    .EQ(t_eq)
);

initial begin
    if ($value$plusargs("vcd=%s", vcd_file)) begin
      $dumpfile(vcd_file);
      $dumpvars(0, DUT);
    end
  end

  initial begin
    for(i=0;i<4;i=i+1) begin
        for(j=0;j<4;j=j+1) begin
            t_a=i[1:0];
            t_b=j[1:0];

            exp_gt = (t_a>t_b);
            exp_lt = (t_a <t_b);
            exp_eq = (t_a == t_b);

            #5;//output stabilisation

            if({t_gt, t_lt, t_eq} !== {exp_gt,exp_lt,exp_eq})begin
                $display("FAIL at time %0t: A=%b B=%b got GT=%b LT=%b EQ=%b expected GT=%b LT=%b EQ=%b",
                   $time, t_a, t_b, t_gt, t_lt, t_eq, exp_gt, exp_lt, exp_eq);
                 errors=errors+1;
            end
        end
    end

    if(errors==0)begin
        $display("PASS: All 16 combinations passed successfully!");
    end else begin
      $display("FAIL: %0d out of 16 tests failed.", errors);
    end

    $finish;
  end

endmodule              