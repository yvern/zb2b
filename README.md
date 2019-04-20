# zb2b
A cli/interactive number base converter. A toy made while learning Zig.

[Zig](https://ziglang.org) is quite lower-level than languages I am used to, but it still felt quite simple most of the time.

There are 2 usage modes:
* Direct/cli mode, where you expect to convert only one value, as in `echo 1001 | ./zb2b 2 10`, which outputs `9`.
* Interactive mode, where you can keep converting values, as in
  ```bash
  $ ./zb2b 10 2
  $ 33
  = 100001
  $ 99
  = 1100011
  $
  = bye bye!
  ```
  
