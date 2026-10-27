module b09_reference (
    input  logic [7:0] onehot_in,
    input  logic [2:0] binary_in,
    input  logic       direction,
    output logic [7:0] result_ref,
    output logic       valid_ref
);
    always_comb begin
        result_ref = 8'b0;
        valid_ref = 1'b0;

        if (!direction) begin
            valid_ref = (onehot_in != 8'b0) && ((onehot_in & (onehot_in - 1'b1)) == 8'b0);
            if (valid_ref) begin
                for (int i=0; i<8; i++)
                    if (onehot_in[i])
                        result_ref[2:0] = i[2:0];
            end
        end else begin
            result_ref[binary_in] = 1'b1;
            valid_ref = 1'b1;
        end
    end
endmodule
