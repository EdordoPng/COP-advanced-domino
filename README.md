# advanced_domino
This repository shows how to solve a Constraint Optimization Problem using Minizinc and ASP 

# Advanced Domino Placement — Constraint Optimization Problem (COP)

## 🧩 Problem Overview

This project tackles a Constraint Optimization Problem (COP) inspired by an advanced version of the classic **domino game**.

You're given:

- A square grid (n x n),
- A set of tiles with predefined shapes (linear, L-shaped, or 2x2),
- Each tile consists of numbered cells (values from 0 to 6).

**Objective**: Place as many tiles as possible on the grid, satisfying these constraints:

- Tiles must be connected (i.e., no isolated groups).
- When tiles are adjacent, their touching cells must have the same value.
- Tiles cannot overlap and must stay within the grid boundaries.

---

## 🔧 Implementations

The COP has been solved using two different declarative programming paradigms:

### 🟨 MiniZinc

- Uses constraint modeling to explore possible tile placements.
- Ensures tile connectivity, cell adjacency conditions, and board limits.
- Optimization goal: maximize the number of correctly placed tiles.
- Includes grid visualization and testing with varying input complexities.

### 🟥 ASP (Answer Set Programming)

- Implemented with **Clingo** and written using logical rules and facts.
- Solves the same optimization problem, with faster performance on large inputs.
- Efficiently handles tile adjacency, mutual connection, and no-overlap constraints.
- Produces compact output showing which tiles were used and their placements.

---

## 📄 Documentation

Detailed explanation of the problem, modeling strategies, constraints, input/output format, and performance benchmarks can be found in the official [📘 Project Report](./report.pdf) (make sure to add your report path or rename accordingly).

---

## 📁 Project Structure

---

## 🧪 Testing & Results

The solution has been tested on input files of **easy**, **medium**, and **hard** difficulty levels.

⏱️ **Performance Summary**:
- **ASP** provides faster results on harder inputs (e.g., 60ms for `Hard_3` vs 50+ mins in MiniZinc).
- Both methods correctly maximize tile placement, within given constraints and timeouts.

---

## 🚀 How to Run

### MiniZinc

1. Open with [MiniZinc IDE](https://www.minizinc.org/software.html)
2. Choose a `.dzn` input file
3. Run and view the output in the IDE

### ASP (Clingo)

```bash
clingo main.lp input.lp
```
