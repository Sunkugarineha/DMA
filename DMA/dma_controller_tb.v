// ============================================================
// DMA Controller Testbench
// ============================================================

`timescale 1ns/1ps

module dma_controller_tb;

    reg clk;
    reg reset;
    reg start;

    reg [7:0] source_data;

    wire [7:0] source_addr;
    wire [7:0] dest_addr;
    wire [7:0] data_out;

    wire busy;
    wire done;
    wire write_enable;

    // Instantiate DMA Controller
    dma_controller uut (
        .clk(clk),
        .reset(reset),
        .start(start),
        .source_data(source_data),
        .source_addr(source_addr),
        .dest_addr(dest_addr),
        .data_out(data_out),
        .busy(busy),
        .done(done),
        .write_enable(write_enable)
    );

    // Clock generation
    always #5 clk = ~clk;

    // Waveform generation
    initial begin
        $dumpfile("dma_controller.vcd");
        $dumpvars(0, dma_controller_tb);
    end

    // Source memory data
    always @(*) begin
        case (source_addr)
            8'd0: source_data = 8'hA1;
            8'd1: source_data = 8'hB2;
            8'd2: source_data = 8'hC3;
            8'd3: source_data = 8'hD4;
            8'd4: source_data = 8'hE5;
            8'd5: source_data = 8'hF6;
            8'd6: source_data = 8'h17;
            8'd7: source_data = 8'h28;
            default: source_data = 8'h00;
        endcase
    end

    // Test sequence
    initial begin

        clk = 0;
        reset = 1;
        start = 0;

        // Reset
        #10;
        reset = 0;

        // Start DMA transfer
        #10;
        start = 1;

        #10;
        start = 0;

        // Wait for transfer
        #100;

        $finish;

    end

    // Display simulation results
    initial begin
        $monitor(
            "Time=%0t | Start=%b | Busy=%b | Source=%d | Destination=%d | Data=%h | Write=%b | Done=%b",
            $time,
            start,
            busy,
            source_addr,
            dest_addr,
            data_out,
            write_enable,
            done
        );
    end

endmodule