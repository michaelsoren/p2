Project by: Michael LeMay
On: 3/8/19

As far as I am aware, the project works perfectly. I did my best to make
my work cleaner, though there was inevitably a decent amount of repetition
in the assembly I produced.

I did a bit more checking than requested by the writeup, and I am pretty sure
my implementation is robust. But some of the things I did to get the code to
work were a bit kludgy. Specifically, I had to do some less than optimal things
to deal with procedures taking in two different big ints (logically) that were
stored at the same address. So if you see some odd copying and temporary
bigints being used, I did that in order to deal with this aliasing problem.

Running to 550 still takes a while (upwards of 4 hours on my machine). I was
not sure whether I should be running mersenne scan to 550 or not, the writeup
was not really clear on that.
