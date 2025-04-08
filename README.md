# advanced_domino
This repository shows how to solve a Constraint Optimization Problem using Minizinc and ASP 

# Advanced Domino Placement — Constraint Optimization Problem (COP)
# advanced_domino

This repository shows how to solve a **Constraint Optimization Problem** using **MiniZinc** and **ASP (Answer Set Programming)**.

---

# 🧩 Advanced Domino Placement — Constraint Optimization Problem (COP)

## Problem Overview

This project addresses a **Constraint Optimization Problem (COP)** inspired by a more complex version of the classic **domino game**.

### You are given:

- A square board of size **n × n**
- A set of **tiles**, each described by:
  - 3 to 4 cells,
  - Fixed shapes (linear, L-shaped, or 2×2),
  - Cell values from **0 to 6**

### 🎯 Objective:

Place **as many tiles as possible** on the board while satisfying the following constraints:

- ✅ **Connectivity**: All placed tiles must form a **single connected component**
- 🟰 **Value Matching**: Adjacent cells from different tiles must have the **same value**
- 🧱 **Bounded Placement**: Tiles must be placed **entirely within** the grid limits
- ⛔ **No Overlap**: A cell can be used by **only one tile**
- 🔗 **Adjacency Rule**: Each tile (except the first) must be adjacent to **at least one previously placed tile**

---

## 🔧 Implementations

This problem has been modeled and solved using **two declarative approaches**:

### 🟨 MiniZinc

- Uses a constraint modeling approach with **constraint satisfaction and optimization**
- Encodes all placement rules, adjacency conditions, and connectivity using **explicit constraints**
- Ensures:
  - Correct tile positioning
  - Mutual cell value consistency
  - One connected group
  - No overlaps
- Supports grid visualization and is suitable for **detailed debugging and small/medium inputs**

#### 🔍 Highlights:

- Declarative modeling with rich constraint support
- Connected components propagation is implemented via **auxiliary boolean variables**
- Automatically calculates how many tiles were successfully placed
- Objective function:

```minizinc
solve maximize sum(t in 1..tile_number)(tile_placed[t]);
```

### 🟥 **ASP (Answer Set Programming with Clingo)**

- Implements the same logic using **Clingo**, a **logic programming solver** for ASP
- Encodes rules such as:
  - **Tile selection**
  - **Placement and overlap checks**
  - **Value matching** between adjacent cells
  - **Connectivity** via adjacency chains

### 🧠 **Logic Overview**

- `**adjacent/4**`: defines **neighbor relations**
- `**positioned/4**`: represents **tile placement**
- `**connected/1**` and `**reachable/2**`: enforce **connectivity**
- **Optimization goal**: maximize number of `**use_tile/1**`

---

## 📄 **Documentation**

Both **MiniZinc** and **ASP** versions are **extensively commented** and designed for **clarity and educational purposes**.

- The **MiniZinc model** explains **constraint propagation**, **decision variables**, and **logical flow**
- The **ASP code** includes definitions for **grid adjacency**, **connectivity logic**, and use of **Clingo’s optimization features**

📘 For a complete breakdown of **modeling techniques**, **test cases**, and **benchmarks**, please see the **[Project Report](./report.pdf)**

---

## 📁 **Project Structure**

```
advanced_domino/
├── minizinc/
│   ├── model.mzn
│   ├── easy_input.dzn
│   └── ...
├── asp/
│   ├── completed_code.lp
│   ├── easy_input_1.lp
│   └── ...
├── report.pdf
└── README.md
```


---

## 🧪 **Testing & Results**

Both implementations have been tested across **multiple input difficulty levels**:

- ✅ **Easy**: Simple placement cases  
- ⚖️ **Medium**: Balanced constraints and tile density  
- 🔥 **Hard**: Maximum board usage and tile interaction

### ⏱️ **Performance Summary**

| **Difficulty** | **MiniZinc Time** | **ASP Time** | **Max Tiles Placed** |
|----------------|-------------------|--------------|-----------------------|
| **Easy_1**     | ~3 sec            | ~50 ms       | ✅                    |
| **Medium_2**   | ~25 sec           | ~180 ms      | ✅                    |
| **Hard_3**     | >50 mins 🐌       | ~60 ms ⚡     | ✅                    |

> ⚠️ **MiniZinc** is better for **small to medium problems** with **detailed debugging**  
> 🏎️ **ASP** is better for **large-scale inputs** and **faster optimizations**

---

## 🚀 **How to Run**

### 🟨 **MiniZinc**

1. **Download and open** the [**MiniZinc IDE**](https://www.minizinc.org/software.html)
2. **Load** the `.mzn` model and an input `.dzn` file
3. **Run the solver** and **view results** in the output window

### 🟥 **ASP (Clingo)**

1. **Install** [**Clingo**](https://potassco.org/clingo/)
2. **Run the program**:

```bash
clingo completed_code.lp your_input.lp --stats
```
Replace your_input.lp with your preferred test input (e.g., easy_input_1.lp)

## 📬 Contributions & Feedback
If you have ideas, improvements, or feedback, feel free to open an issue or contribute directly.
This project is meant as an educational showcase
