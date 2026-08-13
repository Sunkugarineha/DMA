// ============================================================
// DMA Controller
// Verilog HDL
//
// Simple DMA controller that transfers data from source memory
// to destination memory.
// ============================================================

module dma_controller (
    input  wire       clk,
    input  wire       reset,
    input  wire       start,

    input  wire [7:0] source_data,

    output reg  [7:0] source_addr,
    output reg  [7:0] dest_addr,
    output reg  [7:0] data_out,

    output reg        busy,
    output reg        done,
    output reg        write_enable
);

    parameter TRANSFER_SIZE = 8;

    reg [3:0] count;

    always @(posedge clk) begin

        if (reset) begin
            source_addr  <= 8'd0;
            dest_addr    <= 8'd0;
            data_out     <= 8'd0;
            count        <= 4'd0;
            busy         <= 1'b0;
            done         <= 1'b0;
            write_enable <= 1'b0;
        end

        else begin

            // Start DMA transfer
            if (start && !busy) begin
                busy         <= 1'b1;
                done         <= 1'b0;
                write_enable <= 1'b0;
                count        <= 4'd0;
                source_addr  <= 8'd0;
                dest_addr    <= 8'd128;
            end

            // DMA transfer in progress
            else if (busy) begin

                data_out     <= source_data;
                write_enable <= 1'b1;

                source_addr  <= source_addr + 1'b1;
                dest_addr    <= dest_addr + 1'b1;

                if (count == TRANSFER_SIZE - 1) begin
                    busy         <= 1'b0;
                    done         <= 1'b1;
                    write_enable <= 1'b0;
                end
                else begin
                    count <= count + 1'b1;
                end
            end

            else begin
                write_enable <= 1'b0;
                done         <= 1'b0;
            end

        end
    end

endmodule