---
layout: default
title: The Age of Agentic Research
---

[home](/)

## The Age of Agentic Research

There is a striking similarity between what is happening today with agents and the deep learning revolution from a decade ago.

Back in 2015, deep learning was the new shiny thing. ImageNet came out in 2009, followed by AlexNet in 2012. Yet, specialists kept looking at this as hype for quite a few years. Fast forward a few years later, and deep learning had taken over the world.

A fundamental reason for this push back was that the machine was taking over a critical role of those specialists, thereby challenging their place in the ecosystem. Before deep learning, specialists hand-crafted features manually. Deep learning changed all of that, finding patterns in the data automatically.

Today, the new wave of agents yields a similar pattern, challenging the place of specialists at a new level of abstraction: now, agents can find new research ideas, implement a new solution and analyze the results on their own.

To understand what agents are, it helps to think in terms of chapters. Chapter 1 was pre-training (GPT 1-2). These models were purely auto-regressive. They generated semantically correct but meaningless sequences of data. It was easy, and understandable back then, to dismiss them as a useless toy. But Chapter 1 was about capability: it proved the scaling law.

Chapter 2 is about alignment/utility, specifically through post-training (GPT 3-4). The models are now grounded into the reality of the world using RLHF. The models are still brittle because this is done on short horizons, but the mistake would be to wait for these systems to be perfect to consider them as viable. 

First, because the world is elastic: new technology finds its place in the world by shaping the ecosystem around it. With deep learning, we got away with non-explainable models (it took a while for the world to recognize that aspirin and heavier-than-air flight are also less explained than we think).

Second, because the technology progresses, and fast. Big labs are training models on longer and longer horizons, which will make them more and more capable, in particular in environments that are verifiable, i.e. where the agent has direct access to an experimental setup to validate/disprove its ideas. Self-play is an extreme example of this, hence the success of AlphaZero. But coding and computer systems provide, in general, verifiable environments.

Chapter 3 is now starting, and much like deep learning, the revolution is at least as much in the infrastructure than in the models themselves. Sure, new "thinking" models are coming out. But more importantly, the harness around the new technology is being built. 

Riding this new wave requires a good understanding of what the technology can do. Agents are not fully autonomous, "skynet"-like technology. At least not for quite some time. You still need to tell them what problem to solve, and how you'd like to approach it. But once you've figured out these two important questions, agents become tremendously powerful. 

Agents are distinct from the previous revolution in three ways: (1) they can iterate autonomously (2) they read and write the real world (3) they can work collaboratively. The last point is critical: because the solution space is non-convex, mixing various agents together yields an outcome that is vastly better than what a single agent could achieve.

All of this is a step change from deep learning, where the specialist has to manually curate the dataset and the model architecture themselves. Agents are not just oracles. They operate with a goal. They are probes in the solution space. 

The recent release of [autoresearch](https://github.com/karpathy/autoresearch) by Andrej Karpathy might seem like a toy, but it isn't. We have now entered the world of autonomous research. It is nascent, but it is out there. The fact that an agent was able to improve the main metric autonomously in a week, starting from an arguably strong baseline, tells a clear story: if world-class researchers miss major improvements on a toy codebase, what else are we missing?

For product-centric companies, the opportunity is in reinforcing their current moats (proprietary data, customer base, domain expertise), starting on the edges of the product portfolio, rather than a complete overhaul of their legacy stack. 

The best option consists in working on a few atomic problems, building confidence and a good understanding of the tooling, and then expanding into the product inside out. Getting hands-on with toy problems is likely optimal. Whichever way you choose, not trying anything is likely the worse option.

[Tweet](https://twitter.com/share?ref_src=twsrc%5Etfw)
