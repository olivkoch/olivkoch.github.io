---
layout: default
title: Building a recommendation engine from scratch
---

[home](/)

## Building a recommendation engine from scratch

This article a step-by-step guide to help you build a recommendation engine from scratch, with a few neat tricks that I learned during my six years at Criteo.

I assume that you have data and would like to see results quickly. In particular, I assume that you have:

A catalog of products

A set of users

Interactions between products and users (e.g. clicks, conversions, likes, etc.)

You could throw the latest deep learning algorithm at it, but:

You would not be able to explain why the recommendation engine did what it did (sure, you shouldn't care about explainability in the end, but only in the end)

You would not be able to explain to your CTO or investors how it fares compared to much simpler algorithms, and that sucks

So let me guide you through the steps you should take.

## Stage 1: No recommendation (most popular products)

The most popular products are popular for a reason. Show them. It's only a few lines of code!

Let me share a dirty little secret from the recommendation community: this algorithm fares quite decently. The rest of your recommendation life will be about trying to beat the hell out of it.

## Stage 2: Historical products

Most people will tell you that they hate being shown products they've already seen before, but data will beg to differ. People click/convert on products they've seen before. Show (some of) them.

## Stage 3: Co-occurrence by pairs (aka cheap matrix factorization)

In this approach, you maintain a counter per pair of products that co-occurred in the timeline of users (i.e. pairs of products that people tend to look at together). This gives you a dictionary of most-co-viewed products for each product. Then, for each user, take their history and look up the top-k candidates for each of these historical products.

This leaves you with a bunch of candidates that you can filter/sort based on popularity or using an ML model trained to optimize for your final metric (clicks, sales, views, etc.)

## Stage 4: actual matrix factorization

Matrix factorization is now readily available in open-source, at scale. Pick the library that's appropriate for your use case. This approach should yield similar results than Stage 3 and should be even easier to implement, but has the downside of being less interpretable. I recommend building Stage 3 as a reference for Stage 4.

## Stage 5: deep learning, finally!

At this point, you're ready to impress your CTO with the latest deep learning technology. Take a look at the benchmark and play with a bunch of methods. I will hardly resist a self-promotion plug for LED, a lightweight auto-encoder that we developed at Criteo in 2020. The code is on github under the Apache 2.0 license, and it still ranks quite well on the leaderboard as I am writing this article. If you care about efficiency at scale, this algorithm should be of interest to you.

Now that you've gotten the ingredients, here are the tricks for a good recipe.

**The trick is in the mix.** Your best recommendation engine won't be a single algorithm, but a bunch of them. For that reason, you should build an architecture that lets you fuse a bunch of algorithms together using a last-stage machine learning model. This approach has the additional benefit of modularity, letting you experiment with a new source in a smooth way (you will need to give it a reasonable share of traffic for the last-stage learner to give it a shot, though).

**Collaborative filtering dwarfs metadata.** Notice that none of the algorithms mentioned above use products' or users' metadata. This is because collaborative filtering incorporates most of the signal in recommendation. Signals such as "people like you also like..." or "people who liked this product also liked this one" are incredibly powerful. Amazon did not become a trillion-dollar company for no reason.

**Recommendation is hard.** Companies such as Amazon and Meta spent the last ten years fine-tuning their algorithms and still haven't called it a day. This is because a recommendation engine is about understanding the human mind, with all its complexities and weird aspects. Take it step by step, be humble, start simple first, assume nothing (except that your code has a bug) and do not expect day-one revolutions every day. Recommendation is psychology-complete.

**You improve what you measure.** If you put an AB test framework in place (good idea!), be conscious that now, all your product changes will be guided by it. Be careful about what metric you optimize for, and keep an eye on the long-term evolution of your performance.

**Make sure you always improve.** If you keep changing your model all the time, you might find yourself in a situation where you are unsure that you actually improved from a while ago. The best way out of this is "baseline AB testing", where you dedicate a small portion of your traffic (say, 5%) to a basic algorithm (e.g. most-popular products), then constantly measure the uplift between the test and control population. This uplift should never decrease. This means, of course, that now you can only experiment with the remaining 95% (i.e. a typical setup is A = 5% baseline, B = 50% production, C = 45% new-super-cool-algorithm). B-A should always increase over time (this is long-term monitoring), while C-B should be positive before a rollout (this is a short-term rollout criteria).

**Assume your code is wrong.** Always A/B test infrastructure work (i.e. if no algorithm changed). The test should be neutral. Yes, I said neutral, not positive, come on! (unless you really have a reason to believe so)

**Don't learn your website navigation.** This seems like an obvious one, but the methods 3, 4 and 5 mentioned above learn from co-events in your historical data. This data may be biased by the navigation of your website, so if you try to learn from that and feed your recommendation engine into your website navigation engine, well, ... things might happen that were not supposed to happen!

**Learn from the best.** If you want to be serious about recommendation, there is a super-cool and growing community out there that would love to hear from you. Go to RecSys!

And with that, I wish you a great adventure in reco-land!

[Tweet](https://twitter.com/share?ref_src=twsrc%5Etfw)
