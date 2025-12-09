---
layout: default
title: "An introduction to [Less is More: Recursive Reasoning with Tiny Networks](https://arxiv.org/pdf/2510.04871)"
---

# The problem with LLMs


- LLMs generate answers auto-regressively, token by token
- One wrong token early in the sequence can cascade into a completely invalid solution
- Chain-of-Thought prompting and test-time compute help, but aren't enough
- Six years after ARC-AGI was introduced, even frontier models struggle:
	- Gemini 2.5 Pro: 4.9% on ARC-AGI-2 (with heavy test-time compute)
	- DeepSeek R1, o3-mini: 0% on Sudoku-Extreme

= Enter Recursive Reasoning

Core insight: instead of generating an answer in one pass, let the model iteratively refine its solution
Like a human solver who makes a guess, checks their work, fixes errors, and repeats
Earlier work (Hierarchical Reasoning Models / HRM) showed this could work:

55% on Sudoku-Extreme
40% on ARC-AGI-1
Only 27M parameters and ~1,000 training examples


But HRM came with baggage:

Complex biological justifications
Two separate networks operating at different "hierarchies"
Reliance on fixed-point theorems that didn't quite apply

TRM: Stripping Away the Complexity

One tiny network instead of two

HRM used separate "low-frequency" and "high-frequency" networks
TRM uses a single 2-layer transformer for everything


A cleaner conceptual model

x: the input question (e.g., the unsolved Sudoku)
y: the current proposed answer
z: a latent reasoning state (like internal scratch work)
No mysterious "hierarchical latent features"


Full backpropagation through recursions

HRM used a 1-step gradient approximation based on fixed-point theorems
TRM simply backpropagates through all recursion steps
Eliminates theoretical concerns about whether fixed points are actually reached


Simpler halting

HRM's adaptive computation required an extra forward pass
TRM uses straightforward binary cross-entropy loss to predict when the answer is correct
Cuts training costs in half

= Results

| Model | Params | Sudoku-Extreme | Maze-Hard | ARC-AGI-1 | ARC-AGI-2 |
|-------|--------|----------------|-----------|-----------|-----------|
| DeepSeek R1 | 671B | 0% | 0% | 15.8% | 1.3% |
| Claude 3.7 | — | 0% | 0% | 28.6% | 0.7% |
| o3-mini-high | — | 0% | 0% | 34.5% | 3.0% |
| Gemini 2.5 Pro | — | — | — | 37.0% | 4.9% |
| Grok-4-thinking | 1.7T | — | — | 66.7% | 16.0% |
| Bespoke (Grok-4) | 1.7T | — | — | 79.6% | 29.4% |
| HRM | 27M | 55.0% | 74.5% | 40.3% | 5.0% |
| **TRM** | **7M** | **87.4%** | **85.3%** | **44.6%** | **7.8%** |


