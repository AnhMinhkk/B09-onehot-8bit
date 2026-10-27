module b09_tb;
    logic [7:0] onehot_in;
    logic [2:0] binary_in;
    logic direction;
    logic [7:0] result, result_ref;
    logic valid, valid_ref;

    b09_onehot_binary dut(
        .onehot_in(onehot_in),
        .binary_in(binary_in),
        .direction(direction),
        .result(result),
        .valid(valid)
    );

    b09_reference ref_i(
        .onehot_in(onehot_in),
        .binary_in(binary_in),
        .direction(direction),
        .result_ref(result_ref),
        .valid_ref(valid_ref)
    );

    function automatic [7:0] onehot(input int k);
        onehot = 8'b0;
        onehot[k] = 1'b1;
    endfunction

    function automatic bit valid_oh(input logic [7:0] x);
        valid_oh = (x != 8'b0) && ((x & (x-1'b1)) == 8'b0);
    endfunction

    task automatic check_oh(input logic [7:0] x);
        logic [7:0] e;
        logic ev;
        begin
            onehot_in=x; binary_in=3'b0; direction=1'b0; #1;
            ev=valid_oh(x);
            e=8'b0;
            if (ev) begin
                for (int i=0;i<8;i++)
                    if (x[i]) e[2:0]=i[2:0];
            end
            assert(result===e)
                else $fatal(1,"B09 OH2BIN mismatch x=%b got=%b exp=%b",x,result,e);
            assert(valid===ev)
                else $fatal(1,"B09 valid mismatch x=%b got=%b exp=%b",x,valid,ev);
            assert(result_ref===e);
            assert(valid_ref===ev);
        end
    endtask

    task automatic check_bin(input logic [2:0] k);
        logic [7:0] e;
        begin
            onehot_in=8'b0; binary_in=k; direction=1'b1; #1;
            e=onehot(k);
            assert(result===e)
                else $fatal(1,"B09 BIN2OH mismatch k=%0d got=%b exp=%b",k,result,e);
            assert(valid===1'b1);
            assert(result_ref===e);
            assert(valid_ref===1'b1);
        end
    endtask

    initial begin
        $dumpfile("waveform.vcd");
        $dumpvars(0, b09_tb);

        for (int k=0;k<8;k++)
            check_oh(onehot(k));

        check_oh(8'b00000000);
        check_oh(8'b00000011);
        check_oh(8'b00000101);
        check_oh(8'b11111111);

        for (int k=0;k<8;k++)
            check_bin(k[2:0]);

        for (int unsigned x=0;x<256;x++)
            check_oh(x[7:0]);

        check_oh(8'b10000000);
        check_oh(8'b01010101);
        check_bin(3'b000);
        check_bin(3'b111);

        $display("B09 exhaustive one-hot<->binary validation PASS");
        $finish;
    end
endmodule
