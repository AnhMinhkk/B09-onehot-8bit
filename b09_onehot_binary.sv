module b09_onehot_binary (
    input  logic [7:0] onehot_in,
    input  logic [2:0] binary_in,
    input  logic       direction,
    output logic [7:0] result,
    output logic       valid
);
    always_comb begin
        result = 8'b0;
        valid  = 1'b0;

        if (!direction) begin
            valid = (onehot_in != 8'b0) && ((onehot_in & (onehot_in - 1'b1)) == 8'b0);
            if (valid) begin
                for (int i = 0; i < 8; i++)
                    if (onehot_in[i])
                        result[2:0] = i[2:0];
            end
        end else begin
            result[binary_in] = 1'b1;
            valid = 1'b1;
        end
    end
endmodule
