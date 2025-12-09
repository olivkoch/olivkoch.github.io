RM vs Sudoku

Experiment plan
-- 
Benchmark against MLP and CNN
Evaluate Rope2D and SigReg
Evaluate kernel-based models

lam1 and lam2 -> sudoku extreme
lam4 -> sudoku 6x6
lam5 -> krm

The TRM paper shows results on Sudoku-Extreme. In the spirit of starting simple, we work with a Sudoku6x6. We show that this simpler configuration allows to learn plenty about TRM and its simplest alternative (MLP).

# The Sudoku 6x6 dataset

The total number of valid 6×6 Sudoku grids (with 2×3 boxes) is 28,200,960.

The full symmetry group for 6×6 Sudoku includes:

- Digit relabeling: 6! = 720
- Band permutation: 3! = 6
- Row swaps within bands: (2!)³ = 8
- Stack permutation: 2! = 2
- Column shuffles within stacks: (3!)² = 36

Full group size: 720 × 6 × 8 × 2 × 36 = 2,488,320
This means there are roughly 28,200,960 / 2,488,320 ≈ 11-12 equivalence classes of essentially different 6×6 Sudoku grids.

We define two dataset modes:
- Standard: a dataset skipping band and stack permutations. This restricts the dataset to a subspace of all possible grids.
- Full: we sample from all possible 6x6 grids.

We prevent leakage by ensuring puzzle uniqueness through hashing. We hash the puzzle solution, not the puzzle itself, to guarantee solution diversity, not just puzzle diversity.

Coverage comparison (standard vs full):

| Grid Size | Total Valid Solutions | Standard Mode | Full Mode |
|-----------|----------------------|---------------|-----------|
| 4×4 | 288 | 288 (100%) | 288 (100%) |
| 6×6 | 28,200,960 | ~207,360 (0.74%) | ~14,929,920 (53%) |
| 9×9 | ~6.67 × 10²¹ | ~17.4 billion | ~3 trillion |

We build the following datasets:
- Sudoku6x6-Standard-50K: 50K randomly sampled from the Standard mode
- Sudoku6x6-Full-50K: 50K randomly sampled from the Full mode
- Sudoku6x6-Hybrid-50K: 50K training samples from Standard, 10K validation samples from Full

# Experiment setup

We disable puzzle embeddings for all experiments. We run sweeps across the following hyper-parameters:
- For TRM: number of supervision steps, number of H cycles and L cycles, hidden size, num layers and learning rate
- For MLP: hidden size, num layers, ffn expansion, dropout, learning rate

To make the MLP baseline fair, we replicate the input_embedding and lm_head scheme of the TRM. We skip the Q-learning and replace the reasoning module with an MLP.

== Initial experiment

A sweep over the main hyperparams reveal that we can reach 95%+ accuracy on Sudoku 6x6 with
- N_supervision = 6 
- H_cycles = 3
- L_cycles = 1
- hidden_size = 256
- num_layers = 1
- num_heads = 8
- learning_rate = 2e-3

while the following setup leads to very poor performance:
- N_supervision = 2 
- H_cycles = 3
- L_cycles = 2
- hidden_size = 256
- num_layers = 1
- num_heads = 8
- learning_rate =8e-3

Therefore, on this problem at least, a high N_supervision helps but a high L_cycle does not.

The optimal model has 660K parameters.

```
  | Name            | Type            | Params | Mode 
------------------------------------------------------------
0 | input_embedding | CastedEmbedding | 2.3 K  | train
1 | pos_embedding   | RotaryEmbedding | 0      | train
2 | lenet           | ReasoningModule | 655 K  | train
3 | lm_head         | CastedLinear    | 2.3 K  | train
4 | q_head          | CastedLinear    | 514    | train
------------------------------------------------------------
660 K     Trainable params
```

In this setup, we are using 6 supervision steps during training and 16 supervision steps during validation.

[training plots](pics/train-sudoku-1.png)
[validation plots](pics/validation-sudoku-1.png)

Using 6 supervision steps for validation does not hurt performance
[validation plots](pics/validation-sudoku-1-2.png)

== Can we learn with much less data?

Here we train/eval with 5K/1K samples instead of 50K/5K. We get to ~70% exact accuracy on the validation set.
[validation plots](pics/validation-sudoku-1-2.png)

== Comparison with MLP

We build an MLP baseline and obtain the following results

- with 5K/1K dataset: validation exact accurcy:

= Experiments

Sudoku 6x6 medium 50K
Sudoku 9x9 medium 50K
Sudoku mixed 6x6 9x9 50K
Sudoku Extreme 10K

Methods
- CNN
- MLP
- TRM
- TRM-SigReg
- TRM-SigReg-Rope2D
