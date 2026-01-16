---
layout: default
title: Lightweight Representation Learning For Efficient And Scalable Recommendation
---

[home](/)

## Benchmarking inference time for tiny recursive models
   
TRM have achieved impressive results on various puzzle benchmarks but come with a significant compute footprint. This is a series of two posts that cover the topic, from the inference and training standpoint.

This post focuses on the inference time. Here is the link to the [training one](trm-training-benchmark.html).

TRM is compute-intensive by design since it iterates multiple times over the same data (both a training time and inference time) and uses attention over the entire input (no pooling or patching). 
    As such, TRM is significantly more expensive than computer vision baselines and is not expected to be a competitive alternative. TRM is more useful for tasks that require reasoning (puzzle, math, planning).

TRM benefits from FlashAttentation natively on Ampere GPUs (through `torch.nn.functional.scaled_dot_product_attention`). We expect inference time to grow quadratically with the input size with float32, but less so for with bfloat16.

### Setup

We use two types of baselines:
- discriminative models (e.g. resnet)
- generative models (e.g. diffusers)

Here is our setup:

- We select various model architectures
- For each, we run inference a number of times (after some warmup)
- We report the average throughput
- We enable compilation by default (mode=default for TRM due to graph breaks, reduce-overhead for all other models)
- We run the benchmark with both torch.float32 vs torch.bfloat16. This makes a big difference as bfloat16 enables flash attention with torch>=2.0

Link to the [source code](https://github.com/olivkoch/nano-trm/blob/main/tests/src/nn/benchmarks/benchmark_trm_inference.py)

TRM has several hyper-parameters that have significant influence on its reasoning capacity but also compute requirements. Specifically, H_cycles, L_cycles, num_layers and the number of supervision loops.
We therefore benchmark three flavors of TRM (light, medium and heavy) capturing a large spectrum of complexity:
- TRM-Light: N_supervision_val=2, num_layers=1, H_cycles=1, L_cycles=1, hidden_size=128, num_heads=4
- TRM-Medium: N_supervision_val=4, num_layers=2, H_cycles=2, L_cycles=2, hidden_size=256, num_heads=8
- TRM-Heavy: N_supervision_val=16, num_layers=4, H_cycles=3, L_cycles=6, hidden_size=512, num_heads=8


We run the benchmark on increasing input size (from 32x32 to 128x128). Each step doubles the surface of the image (i.e. the image width/height is multiplied by sqrt(2)).
We use a constant batch size of 32. While bigger batches might lead to faster inference, bigger batches lead to OOMs or long computing times for some models. The benchmark is run on an A100 SXM4 40GB.

### Results

The raw results are linked here:

Discriminative models are orders of magnitude faster than TRM. This is not surprising because they embed significant optimizations/inductive bias (pooling, patching) that TRM does not have. It makes little sense to try to use a TRM for a pure discrimination task.

<center>
  <img src="img/trm_benchmark_inference_speed_1.png" alt="">
</center>

| Input Size | ResNet18 (Discriminative) | TRM-Medium (Reasoning) | DiT-Medium (Generative) | Speedup (ResNet vs TRM) |
| :--- | :--- | :--- | :--- | :--- |
| **32x32** | 66,941 img/s | 2,690 img/s | 1,255 img/s | **25x** |
| **46x46** | 37,767 img/s | 1,133 img/s | 517 img/s | **33x** |
| **64x64** | 33,616 img/s | 435 img/s | 223 img/s | **77x** |
| **90x90** | 33,227 img/s | 125 img/s | 75 img/s | **265x** |
| **128x128** | 23,934 img/s | 35.6 img/s | 23.4 img/s | **672x** |

- Because a TRM is a lot slower than a discriminative model, it'd better deliver outstanding upsides on the performance side to be worth it! Even "general" benchmarks such as ARC-AGI2 seem not to resist to the vision transfomer (ARC is a vision problem). [1]
- BFloat16 is a "Free Lunch" for Transformers (7x–9x Speedup) It not only makes inference much faster but enables non-quadratic complexity
- A medium TRM is in the ballpark of a diffusion transformer. A lighter one is much faster, while a heavier one is much slower.

[1] Everything is obvious in the hindsight, but it is not too surprising that a vision transformer does well on ARC-AGI2 given that this model has been pre-trained on a vast amount of data/problems that could overlap with ARC AGI tasks. The past decade(s) show that for any given problem, a sufficiently well pretrained model outperforms any alternative (essentially, the bitter lesson). Intuitively, thinking models that are trained from scratch should shine in areas where robustness, not just raw performance, matters.


