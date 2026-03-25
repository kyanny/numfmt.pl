# numfmt.pl
less versatile than the original [`numfmt(1)`](https://manpages.debian.org/testing/coreutils/numfmt.1.en.html), by design.

## Usage
```
Usage: numfmt.pl <number>[unit] ...
  numfmt.pl 1000000      show all SI and binary unit conversions
  numfmt.pl 10GB         to bytes  (uppercase letter = binary, base-1024)
  numfmt.pl 10gb         to bytes  (lowercase letter = SI, base-1000)
  numfmt.pl 26GiB        to bytes  (iB/ib suffix = binary, base-1024)
  echo 1073741824 | numfmt.pl
```

## Examples
```
% numfmt.pl 1000000
1,000,000 bytes

SI (base-1000):
  kB:   1,000
  MB:   1
  GB:   0.001
  TB:   1e-06

Binary (base-1024):
  KiB:  976.5625
  MiB:  0.95367432
  GiB:  0.00093132257
  TiB:  9.094947e-07
```

```
% numfmt.pl 10GB
10 GB = 10737418240 bytes  (binary, base-1024)
10 GB = 10,737,418,240 bytes  (binary, base-1024)
```

```
% numfmt.pl 10gb
10 gb = 10000000000 bytes  (SI, base-1000)
10 gb = 10,000,000,000 bytes  (SI, base-1000)
```

```
% numfmt.pl 26GiB
26 GiB = 27917287424 bytes  (binary, base-1024)
26 GiB = 27,917,287,424 bytes  (binary, base-1024)
```

### Accepts multiple arguments

```
% numfmt.pl 3gb 30GB
3 gb = 3000000000 bytes  (SI, base-1000)
3 gb = 3,000,000,000 bytes  (SI, base-1000)

----------------------------------------
30 GB = 32212254720 bytes  (binary, base-1024)
30 GB = 32,212,254,720 bytes  (binary, base-1024)
```

### STDIN supported

```
% echo 1073741824 | numfmt.pl
1,073,741,824 bytes

SI (base-1000):
  kB:   1073741.8
  MB:   1073.7418
  GB:   1.0737418
  TB:   0.0010737418

Binary (base-1024):
  KiB:  1,048,576
  MiB:  1,024
  GiB:  1
```

