# ArtistMatch

## Installing Elixir

To install Elixir on your local machine, follow the [official docs](https://elixir-lang.org/install.html)

### tl;dr

On MacOS:
```
brew install elixir
```

NOTE: you may need to refresh your shell session so that the `mix` command is in your PATH


## Running the Program
1. `git clone https://github.com/dillonius01/artist_match`
1. `cd artist_match`
1. `mix do deps.get, compile`
1. `mix escript.build`
1. `./artist_match`

The output is written to `results.txt`. This is configurable in `config/config.exs`, as is the 
path of the input file.

You may delete `results.txt` and re-run the program to re-generate the results.

## Running Tests
```
mix test
```

## Runtime Performance

#### Length of Input File, n
This program streams the input file one line at a time.
Therefore, its Big-O is `O(n * per-line-performance)` where `n` is the number of lines in the file.

#### Length of Artists per Line, m
To generate all two-artist permutations per line, the `generate_permuations` performs a nested
loop to examine each pair. However, the inner loop shrinks as the outer iteration continues.
For example, if there are 5 artists on a line, the first pass we generate pairs at the following 
indecies:
```
[
  [0,1],
  [0,2],
  [0,3],
  [0,4]
]
```

But by the second outer iteration, we only generate the following pairs:

```
[
  [1,2],
  [1,3],
  [1,4]
]
```

Thus, our Big-O per line is `O(m * ln(m))` where `m` is the length of the line.

#### Summary
Given length of file `n` and length of line `m`, the runtime performance is:
`O(n * m * ln(m))`


## Optimizations
#### Generating Permutations
There is a naive implementation of `generate_permutations` whose runtime is
`O(m^2)` where `m` is the length of a given line of input.
However, this program implements the more optimized version.

#### Tracking Results
When accumulating the found pairs, we could only track the matched artists
and not check for which pairs have exceeded the threshold needed to be written
to the result set.

However, this would require a second iteration across ALL of the found pairs.

Therefore, we also maintain a `result_set` list to keep track of which pairs we
will eventually write to output.