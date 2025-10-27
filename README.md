# UVM-Based Verification of an SPI Slave with Single-Port RAM

This repository contains a comprehensive functional verification project for an **SPI slave** module interfaced with a **single-port RAM**. The entire verification environment is built from the ground up using the **Universal Verification Methodology (UVM)** framework.

The project was developed by **Farah Haitham** and **Mohammed Yasser**.

---

## 💡 Project Overview

The primary goal of this project is to perform robust functional verification of the SPI-RAM system. The environment is structured to be modular, scalable, and reusable, adhering to best practices in ASIC/FPGA verification.

The verification process is divided into three main stages, each having a complete UVM environment:

1.  **RAM Verification:** A complete, standalone UVM environment to verify the **Single-Port RAM** module in isolation.
2.  **SPI Slave Verification:** A complete, standalone UVM environment to verify the **SPI Slave** module in isolation.
3.  **SPI Wrapper Verification (Top-Level):** A top-level UVM environment that integrates the SPI Slave and the RAM (as a single DUT, the `SPI_wrapper`). This environment reuses the UVM components from the RAM and SPI environments, setting their agents to **`UVM_PASSIVE`** mode to monitor the internal interfaces.

---

## 🏛️ UVM Environment Architecture
Below is the overall UVM environment architecture for the top-level test (`WRAPPER_test`):  
<img width="16384" height="12506" alt="SPIUVM drawio" src="https://github.com/user-attachments/assets/ff7847e5-1547-46b1-8060-1b10d18d133e" />

The top-level testbench (`WRAPPER_top`) instantiates the DUT (`WRAPPER`) and a golden reference model (`WRAPPER_ref`). The architecture is set up to allow both external control and internal interface monitoring:

### Interfaces

The testbench uses three main interfaces configured via the `uvm_config_db`:

* `WRAPPER_IF` (**Active**): Connects to the external SPI bus driver and monitor.
* `RAM_IF` (**Passive**): Monitors the internal interface between the SPI Slave and the RAM.
* `SPI_slave_if` (**Passive**): Monitors the internal signals of the SPI Slave.

### Key Components

The UVM environment (`WRAPPER_env`) is composed of:

* **Agents:** Separate agents for the Wrapper (**Active**), RAM (**Passive**), and SPI Slave (**Passive**).
* **Scoreboard:** A `WRAPPER_scoreboard` compares transactions captured from the DUT's **`MISO`** pin against the **`MISO_ref`** pin from the golden model.
* **Coverage:** A `WRAPPER_coverage` collector samples transactions to measure functional coverage goals.
* **Sequences:** The test (`WRAPPER_test`) executes multiple sequences to validate functionality, including:
    * `WRAPPER_reset_seq`
    * `WRAPPER_write_only_seq`
    * `WRAPPER_read_only_seq`
    * `WRAPPER_write_read_seq` (Read/Write combined operations)

---

## 📂 Repository Structure

The project structure is organized for clear separation of design, testbench, and simulation files.
``` bash
UVM-Based-Verification-of-SPI-slave-with-single-port-RAM/
├── doc/
│   ├── ram/
│   │   ├── CoverageReports/
│   │   │   └── RAM_cvr.txt
│   │   └── Plan/
│   │       └── RAM.xlsx
│   ├── report.pdf
│   ├── slave/
│   │   ├── CoverageReports/
│   │   │   └── SLAVE_cvr.txt
│   │   └── Plan/
│   │       ├── SLAVE_ASSERTIONS.pdf
│   │       └── SLAVE_VP.pdf
│   └── wrapper/
│       ├── CoverageReports/
│       │   └── WRAPPER_cvr.txt
│       └── Plan/
│           └── WRAPPER.xlsx
├── README.md
├── rtl/
│   ├── ram/
│   │   ├── DesignBeforeChanges/
│   │   │   └── RAM.v
│   │   ├── RAM_ref.v
│   │   └── RAM.v
│   ├── slave/
│   │   ├── DesignBeforeChanges/
│   │   │   └── SPI_slave.v
│   │   ├── SPI_slave_golden_model.v
│   │   └── SPI_slave.sv
│   └── wrapper/
│       ├── SPI_wrapper_ref.v
│       └── SPI_wrapper.v
├── sim/
│   ├── ram/
│   │   ├── mem.dat
│   │   ├── run_ram.do
│   │   └── src_files.list
│   ├── slave/
│   │   ├── run_spi.do
│   │   └── src_list.list
│   └── wrapper/
│       ├── run.do
│       └── src_files.list
└── tb/
    ├── ram/
    │   ├── RAM_agent.sv
    │   ├── RAM_config.sv
    │   ├── RAM_coverage.sv
    │   ├── RAM_driver.sv
    │   ├── RAM_env.sv
    │   ├── RAM_if.sv
    │   ├── RAM_monitor.sv
    │   ├── RAM_scoreboard.sv
    │   ├── RAM_seq_item.sv
    │   ├── RAM_sequence.sv
    │   ├── RAM_sequencer.sv
    │   ├── RAM_sva.sv
    │   ├── RAM_test.sv
    │   ├── RAM_top.sv
    │   └── shared_pkg.sv
    ├── shared_pkg.sv
    ├── slave/
    │   ├── SPI_slave_agent.sv
    │   ├── SPI_slave_config.sv
    │   ├── SPI_slave_coverage.sv
    │   ├── SPI_slave_driver.sv
    │   ├── SPI_slave_env.sv
    │   ├── SPI_slave_if.sv
    │   ├── SPI_slave_main_sequence.sv
    │   ├── SPI_slave_monitor.sv
    │   ├── SPI_slave_reset_sequence.sv
    │   ├── SPI_slave_scoreboard.sv
    │   ├── SPI_slave_seq_item.sv
    │   ├── SPI_slave_sequencer.sv
    │   ├── SPI_slave_test.sv
    │   └── SPI_slave_top.sv
    └── wrapper/
        ├── WRAPPER_agent.sv
        ├── WRAPPER_config.sv
        ├── WRAPPER_coverage.sv
        ├── WRAPPER_driver.sv
        ├── WRAPPER_env.sv
        ├── WRAPPER_if.sv
        ├── WRAPPER_monitor.sv
        ├── WRAPPER_scoreboard.sv
        ├── WRAPPER_seq_item__.sv
        ├── WRAPPER_seq_item.sv
        ├── WRAPPER_sequence.sv
        ├── WRAPPER_sequencer.sv
        ├── WRAPPER_sva.sv
        ├── WRAPPER_test.sv
        └── WRAPPER_top.sv
```
## 🚀 How to Run

This project is designed to be run using a standard IEEE 1800-2017 compliant simulator.

### Prerequisites

* Ensure you have **ModelSim/QuestaSim** or another compatible Verilog/SystemVerilog simulator installed.

### Execution Steps

1.  **Navigate** to the `sim/` directory:
    ```bash
    cd sim/
    ```

2.  **Run the main simulation** by executing the `.do` script from the simulator's command line (e.g., in a terminal where your simulator is configured):
    ```bash
    do run.do
    ```

### `run.do` Script Functionality

The main simulation script (`run.do`) automatically handles the complete build and run process:

1.  **Library Setup:** Creates a `work` library.
2.  **Compilation:** Compiles all Verilog and SystemVerilog files listed in `src_files.list` (with coverage enabled).
3.  **Simulation Load:** Loads the simulation (`vsim`) targeting the `WRAPPER_top` module, initializing the UVM framework.
4.  **Wave Setup:** Adds relevant signals to the wave window for debugging.
5.  **Execution:** Runs the simulation to completion (`run -all`).
