# Python Programming

## Part 1 - Python Programming

### Slicing Sequences

Slicing works with any class that defines `__getitem__`, incl. built-in types `list, tuple, str, bytes`.

```python
somelist[start:end:stride]
```

### Exception Handling

Take advantage of each block:

```python
try:
    # Do something
except SomeException as e:
    # Handle exception
else:
    # Runs when there are no exceptions
finally:
    # Always runs, after except or else
```

### Comprehensions and Generators

- Use list comprehensions instead of `map, filter`
- Avoid more than two expressions in list comprehensions
- Consider generator expressions (lazy evaluation) for large comprehensions

```python
import random

with open("/tmp/file.txt", "w") as f:
    for _ in range(10):
        f.write("a" * random.randint(0, 100))
        f.write("\n")

print([len(x) for x in open("/tmp/file.txt")])

if = (len(x) for x in open("/tmp/file.txt")) 
print(next(value))
print(next(value))

>> [90, 49, 51, 33, 57, 78, 96, 56, 40, 1]
>> 90
>> 49
```

- Similarly, consider returning generators instead of returning sequences: For huge lists, the process might run out of memory and crash

```python
from typing import Generator

def index_words(text: str) -> Generator[int, None, None]:
    if text:
        yield 0
    for index, letter in enumerate(text):
        if letter == " ":
            yield index + 1

it = index_words("Some text")
print(next(it))
print(next(it))

>> 0
>> 5
```

Note an iterator can be exhausted only once - also when calling `list` on it.

```python
from typing import Iterator

def normalise(numbers: Iterable[int]) -> List[float]:
    if iter(numbers) is iter(numbers):
        raise TypeError("Must supply a container")

    total = sum(numbers)

    return [100 * value / total for value in numbers]

visits = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
it = iter(visits)
print(normalise(it))

>> TypeError: Must supply a container
```

### Functions

For optional arguments, use keyword-only arguments (`*`) with default values!

## Part 2 - Memory Allocation & Performance

Profile before optimising!

```python
profiler = Profile()
profiler.runcall(lambda: insertion_sort(data))

stats = Stats(profiler)
stats.strip_dirs()
stats.sort_stats("cumulative")
stats.print_stats()
```

Memory profiling is important because

- Python uses reference counting for garbage collection
- a cycle detector for looping references
- in practice it is hard to figure out why references are held

```python
import tracemalloc

tracemalloc.start(10)

time1 = tracemalloc.take_snapshot()

import waste_memory

x = waste_memory.run()

time2 = tracemalloc.take_snapshot()

stats = time2.compare_to(time1, "lineno")
for stat in stats[:3]:
    print(stats)
```

## Part 3 - Parallelism & Concurrency

Use a subprocess to manage child processes.

Use threads for blocking I/O.

Use Lock to prevent data races in threads.

Use Queue to coordinate between threads.

Multiprocessing:

- Isolated - for functions that don't share state
- High leverage - small amounts of data that require a large amount of computation
