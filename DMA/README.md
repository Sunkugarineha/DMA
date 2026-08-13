# 💾 DMA Controller Using Verilog HDL

## 📌 Project Description

This project implements a simple **DMA (Direct Memory Access) Controller** using Verilog HDL.

DMA allows data to be transferred between memory locations without requiring the CPU to handle every individual data transfer.

The controller transfers a fixed number of data bytes from a source address to a destination address.

---

## 🎯 Objectives

The objectives of this project are:

- Understand the concept of Direct Memory Access.
- Design a simple DMA controller using Verilog HDL.
- Generate source and destination addresses.
- Transfer data from source to destination.
- Implement DMA start and completion signals.
- Create a Verilog testbench.
- Simulate the DMA controller.
- Analyze the waveform using GTKWave.

---

## 🛠️ Tools Used

- Verilog HDL
- Icarus Verilog
- GTKWave
- GitHub

---

## 📂 Project Structure

```text
dma-controller-verilog/
│
├── README.md
├── dma_controller.v
├── dma_controller_tb.v
└── simulation/
    └── dma_waveform.png
```

---

## 📖 What is DMA?

**DMA stands for Direct Memory Access.**

DMA is a technique that allows data to be transferred between memory and peripherals, or between memory locations, without continuous CPU involvement.

A DMA controller manages:

- Source address
- Destination address
- Transfer count
- Data transfer
- Transfer status

---

## ⚙️ DMA Controller Operation

The controller has three main stages:

### 1. Idle

Initially:

```text
BUSY = 0
DONE = 0
```

The controller waits for the `start` signal.

### 2. Transfer

When:

```text
START = 1
```

the DMA transfer begins.

The controller:

- Reads data from the source.
- Places the data on `data_out`.
- Generates a write enable signal.
- Increments the source address.
- Increments the destination address.
- Decrements/increments the transfer counter.

### 3. Complete

After transferring 8 bytes:

```text
BUSY = 0
DONE = 1
```

The DMA transfer is complete.

---

## 🔌 Inputs

| Signal | Width | Description |
|--------|-------|-------------|
| `clk` | 1 bit | System clock |
| `reset` | 1 bit | Reset signal |
| `start` | 1 bit | Starts DMA transfer |
| `source_data` | 8 bits | Data from source memory |

---

## 📤 Outputs

| Signal | Width | Description |
|--------|-------|-------------|
| `source_addr` | 8 bits | Source memory address |
| `dest_addr` | 8 bits | Destination memory address |
| `data_out` | 8 bits | Transferred data |
| `busy` | 1 bit | DMA transfer in progress |
| `done` | 1 bit | DMA transfer completed |
| `write_enable` | 1 bit | Destination write control |

---

## 🔄 Example Transfer

The project transfers 8 bytes.

### Source

```text
Address   Data
-------   ----
0         A1
1         B2
2         C3
3         D4
4         E5
5         F6
6         17
7         28
```

### Destination

```text
Address   Data
-------   ----
128       A1
129       B2
130       C3
131       D4
132       E5
133       F6
134       17
135       28
```

---

## 📊 DMA Transfer Sequence

```text
START
  |
  ↓
DMA BUSY
  |
  ↓
Read Source Data
  |
  ↓
Write Destination Data
  |
  ↓
Increment Addresses
  |
  ↓
Transfer Count Complete
  |
  ↓
DONE
```

---

## 💻 Verilog Design

```verilog
module dma_controller (
    input wire clk,
    input wire reset,
    input wire start,
    input wire [7:0] source_data,

    output reg [7:0] source_addr,
    output reg [7:0] dest_addr,
    output reg [7:0] data_out,

    output reg busy,
    output reg done,
    output reg write_enable
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

            if (start && !busy) begin
                busy         <= 1'b1;
                done         <= 1'b0;
                write_enable <= 1'b0;
                count        <= 4'd0;
                source_addr  <= 8'd0;
                dest_addr    <= 8'd128;
            end

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
```

---

## 🧪 Testbench

The testbench performs the following operations:

1. Reset the DMA controller.
2. Generate the clock.
3. Apply the start signal.
4. Provide source memory data.
5. Monitor source address.
6. Monitor destination address.
7. Monitor transferred data.
8. Check the busy signal.
9. Check the done signal.
10. Generate a VCD waveform.

---

## ▶️ Simulation Using Icarus Verilog

### Step 1: Compile

```bash
iverilog -o dma_sim dma_controller.v dma_controller_tb.v
```

### Step 2: Run

```bash
vvp dma_sim
```

---

## 📊 Expected Output

The simulation will produce output similar to:

```text
Time=0   | Start=0 | Busy=0 | Source=0 | Destination=0   | Data=00 | Write=0 | Done=0
Time=20  | Start=1 | Busy=1 | Source=0 | Destination=128 | Data=00 | Write=0 | Done=0
Time=25  | Start=0 | Busy=1 | Source=1 | Destination=129 | Data=A1 | Write=1 | Done=0
Time=35  | Start=0 | Busy=1 | Source=2 | Destination=130 | Data=B2 | Write=1 | Done=0
Time=45  | Start=0 | Busy=1 | Source=3 | Destination=131 | Data=C3 | Write=1 | Done=0
...
Time=95  | Start=0 | Busy=0 | Source=8 | Destination=136 | Data=28 | Write=0 | Done=1
```

The exact timestamps may vary depending on the simulator.

---

## 📈 Waveform Simulation

The testbench automatically generates:

```text
dma_controller.vcd
```

Open the waveform using GTKWave:

```bash
gtkwave dma_controller.vcd
```

Add the following signals:

```text
clk
reset
start
source_addr
dest_addr
source_data
data_out
busy
write_enable
done
```

---

## 📸 Simulation Result

Take a screenshot of the GTKWave waveform and save it as:

```text
simulation/dma_waveform.png
```

Add the screenshot to your README:

```markdown
![DMA Controller Simulation](simulation/dma_waveform.png)
```

---

## ✅ Result

The DMA Controller was successfully designed and simulated using Verilog HDL.

The controller successfully:

- Accepts a DMA start request.
- Generates source addresses.
- Generates destination addresses.
- Transfers source data to the output.
- Generates write enable.
- Indicates transfer activity using `busy`.
- Indicates completion using `done`.

---

## 📚 Learning Outcomes

After completing this project, you will understand:

- Direct Memory Access
- DMA controllers
- Memory addressing
- Data transfer
- Counters
- Control signals
- Sequential logic
- Verilog HDL
- Testbench design
- Icarus Verilog simulation
- GTKWave waveform analysis
- GitHub project organization

---

## 👩‍💻 Author

**Satya Nandini**

GitHub Repository:

`dma-controller-verilog`