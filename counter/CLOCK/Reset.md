

---

### **Notes: Active Low Reset vs Active High Reset**

---

#### **1. Active Low Reset (!rst)**

- **Triggering Condition**: Reset occurs when `rst` is LOW (`rst = 0`).
- **Description**: The reset happens immediately when `rst` is LOW, regardless of the clock state. This is an **active-low** reset, meaning it activates when the signal is at a low voltage level.


1. **Reset Works Immediately**  
   - When `rst = 0` (LOW), the circuit resets **right away**—no need to wait for the clock.  

2. **Counting Happens on Clock Fall**  
   - When `rst = 1` (HIGH), the counter increases (`q + 1`) **only when the clock goes from HIGH → LOW** (`negedge clk`).  

3. **Reset Overrides Everything**  
   - If `rst = 0` **at any time**, the output (`q`) becomes `0` immediately—even if the clock is changing.  

4. **No Waiting for Reset**  
   - Unlike some reset types, this one **does not wait** for the clock—it resets **instantly** when `rst = 0`.  



##### **Truth Table for Active Low Reset**
| clk | rst | Description               | Output q       |
|-----|-----|---------------------------|----------------|
| 0   | 0   | Reset is LOW              | q = 0          |
| ↑1  | 0   | Rising edge, reset LOW    | q = 0          |
| 0   | ↑1  | Reset goes HIGH           | previous state |
| ↑1  | 1   | Rising edge, reset HIGH   | q = q + 1      |

##### **Verilog Code**
```verilog
module counter(q, clk, rst);
  output reg [7:0] q;
  input clk, rst;

  always @(posedge clk or negedge rst) begin
    if (!rst)
      q <= 8'b0;  // Active when rst=0
    else
      q <= q + 1;  // Normal operation
  end
endmodule
```

---

#### **2. Active High Reset (rst)**

- **Triggering Condition**: Reset occurs when `rst` is HIGH (`rst = 1`).
- **Description**: 

1. **Clock-Gated Evaluation**  
   The reset condition `if (rst)` is only checked when the clock rises (`posedge clk`). Even if `rst` becomes '1' earlier, the circuit ignores it until the next clock edge.

2. **No Immediate Trigger**  
   Unlike active-low reset that uses `negedge rst` to trigger instantly, active-high reset has no asynchronous pathway. It's completely dependent on the clock.

3. **Fixed 1-Cycle Latency**  
   When `rst` goes high:  
   - The change is detected immediately by hardware  
   - But the actual reset action waits for the next clock edge  
   - This creates a guaranteed 1-clock-cycle delay


  

**Key Takeaway**: The delay exists because active-high reset is just synchronous logic - it follows the clock's rhythm rather than breaking it.

##### **Truth Table for Active High Reset**
| clk | rst | Description               | Output q       |
|-----|-----|---------------------------|----------------|
| 0   | 1   | Reset is HIGH             | previous state |
| ↑1  | 1   | Rising edge, reset HIGH   | q = 0 (active) |
| 0   | ↓0  | Reset goes LOW            | previous state |
| ↑1  | 0   | Rising edge, reset LOW    | q = q + 1      |

##### **Verilog Code**
```verilog
module counter(q, clk, rst);
  output reg [7:0] q;
  input clk, rst;

  always @(posedge clk or posedge rst) begin
    if (rst)
      q <= 8'b0;  // Active when rst=1
    else
      q <= q + 1;  // Normal operation
  end
endmodule
```

---

#### **Key Notes:**

- **Reset Timing Behavior**:
  - **Active Low**: Reset is triggered immediately when `rst = 0` (no clock edge needed).
  - **Active High**: Reset happens at the rising edge of the clock when `rst = 1`.

- **Why Active Low is Preferred**:
  1. **Immediate Reset**: The system can reset without waiting for a clock edge, ensuring the system starts in a known state.
  2. **Better Noise Immunity**: Active-low signals are less susceptible to noise.
  3. **Common in FPGA/ASIC Designs**: Standard practice for hardware designs.
  4. **Button Behavior**: Physical reset buttons are typically active-low (connected to ground).

- **Conversion Tip**: 
  - To convert an **Active Low** reset to an **Active High** reset, swap `negedge rst` with `posedge rst` and `!rst` with `rst`.

---


