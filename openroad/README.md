# OpenROAD Flow Scripts

The physical-design top is `cpu_core`. The `cpu_top` module remains a
simulation-only wrapper containing the demonstration memories.

From a Linux, WSL, or Docker OpenROAD Flow Scripts environment:

```bash
cd /path/to/riscv-rv32i-processor
make --file=/path/to/OpenROAD-flow-scripts/flow/Makefile \
  DESIGN_CONFIG=$PWD/openroad/config.mk
```

The starter configuration targets `sky130hd`, a 50 MHz clock, and 35% core
utilization. Review synthesis and timing reports before tightening them.

The instruction and data buses are external by design. Connect them to
technology memory macros or a surrounding SoC during integration.
