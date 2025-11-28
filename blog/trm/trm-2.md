TRM vs Sudoku

We disable puzzle emeddings for this experiment. We use 50K training samples and 5K validation samples. We ensure no leakage with unique samples across the train and val datasets.

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

  | Name            | Type            | Params | Mode 
------------------------------------------------------------
0 | input_embedding | CastedEmbedding | 2.3 K  | train
1 | pos_embedding   | RotaryEmbedding | 0      | train
2 | lenet           | ReasoningModule | 655 K  | train
3 | lm_head         | CastedLinear    | 2.3 K  | train
4 | q_head          | CastedLinear    | 514    | train
------------------------------------------------------------
660 K     Trainable params

[training plots](pics/train-sudoku-1.png)
[validation plots](pics/validation-sudoku-1.png)
