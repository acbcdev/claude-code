---
name: Python Code Style Reference
description: Language-specific style guidelines, patterns, and Pythonic best practices for Python projects.
---

# Python Style Guide

This guide complements the main code-style skill with Python-specific patterns, Pythonic idioms, and conventions. Follow these guidelines alongside the universal principles in the main skill.

Reference: [PEP 8 - Style Guide for Python Code](https://pep8.org/) and [PEP 20 - The Zen of Python](https://www.python.org/dev/peps/pep-0020/)

---

## Naming Conventions

Python uses `snake_case` for functions/variables, `PascalCase` for classes.

```python
def calculate_total(items):      # Good: snake_case
    return sum(item.price for item in items)

user_name = "Alice"              # Good: snake_case
is_active = True                 # Good: boolean prefix
max_retries = 3

MAX_RETRIES = 3                  # Good: constant
API_TIMEOUT_SECONDS = 30         # Good: constant

def _internal_helper():          # Good: private convention
    pass

class User:
    def __init__(self):
        self.__password = None   # Good: name mangling

# Bad: camelCase (not Pythonic)
def calculateTotal(items): pass
userName = "Alice"
valid = True                     # Bad: unclear intent

# Boolean prefixes: is_, has_, can_, should_, does_
```

---

## Pythonic Idioms

### Comprehensions Over Loops

```python
doubled = [n * 2 for n in numbers]           # Good: list
evens = [n for n in numbers if n % 2 == 0]  # Good: list with filter
inverted = {v: k for k, v in data.items()}   # Good: dict
unique_squares = {n * n for n in numbers}    # Good: set

# OK: for loop when comprehension is complex
results = []
for item in items:
    if should_process(item):
        processed = expensive_transform(item)
        if processed:
            results.append(processed)

# Bad: nested comprehension (hard to read)
nested = [[j * 2 for j in range(i)] for i in range(5)]

# Better: use loop for clarity
nested = []
for i in range(5):
    nested.append([j * 2 for j in range(i)])
```

### EAFP Over LBYK

Use try/except instead of checking conditions (Easier to Ask for Forgiveness than Permission).

```python
# Good: EAFP
try:
    value = data['key']
except KeyError:
    value = None

# Bad: LBYK
if 'key' in data:
    value = data['key']
else:
    value = None

# Good: EAFP for operations
try:
    result = int(user_input)
except ValueError:
    result = 0

# Good: Use .get() for simple cases
value = data.get('key', 'default')
```

### Context Managers (`with` Statements)

```python
# Good: automatic cleanup
with open('data.txt') as f:
    content = f.read()

# Good: multiple context managers
with open('input.txt') as src, open('output.txt', 'w') as dst:
    for line in src:
        dst.write(line.upper())

# Good: custom context manager
from contextlib import contextmanager

@contextmanager
def timer(name):
    start = time.time()
    try:
        yield
    finally:
        elapsed = time.time() - start
        print(f"{name} took {elapsed:.2f}s")

with timer("operation"):
    expensive_computation()

# Bad: manual cleanup (error-prone)
f = open('data.txt')
content = f.read()
f.close()  # might not run if exception occurs
```

### f-Strings

```python
# Good: f-strings
greeting = f"Hello, {name}!"
message = f"{name} is {age} years old"

# Good: f-string expressions and formatting
message = f"Price: ${price:.2f}"
message = f"Total items: {len(items)}"

# OK: .format() for older Python
message = "Hello, {}!".format(name)

# Bad: concatenation or % formatting
message = "Hello, " + name + "!"
message = "Hello, %s!" % name
```

### Magic Strings/Numbers

```python
# Good: named constants
REDIS_HOST = "localhost"
REDIS_PORT = 6379
MAX_CONNECTIONS = 10
CACHE_TTL_SECONDS = 3600

def connect_redis():
    return redis.Redis(host=REDIS_HOST, port=REDIS_PORT)

# Bad: magic values
def connect_redis():
    return redis.Redis(host="localhost", port=6379)

def cache_result(key, value):
    cache.set(key, value, 3600)  # unclear
```

---

## Type Hints and Annotations

### Type Hints

```python
# Good: function hints
def calculate_total(items: list[float]) -> float:
    return sum(items)

def find_user(user_id: int) -> Optional[User]:
    return users.get(user_id)

# Good: complex types
def process_data(data: dict[str, list[int]]) -> None:
    for key, values in data.items():
        total = sum(values)

# Good: variable hints
count: int = 0
user_names: list[str] = []

# Python 3.10+: union types
def process(value: int | str) -> None:
    pass

# Pre-3.10: use Union from typing
from typing import Union
def process(value: Union[int, str]) -> None:
    pass
```

### Protocol for Structural Typing

```python
from typing import Protocol

# Good: Protocol defines interface
class Drawable(Protocol):
    def draw(self) -> None: ...

def render(shape: Drawable) -> None:
    shape.draw()

# Works with any class that has draw()
class Circle:
    def draw(self):
        print("Drawing circle")

class Square:
    def draw(self):
        print("Drawing square")

render(Circle())   # Works without inheritance
render(Square())
```

---

## Exception Handling

### Specific Exception Handling

```python
# Good: specific exceptions
def parse_config(filepath):
    try:
        with open(filepath) as f:
            return json.load(f)
    except FileNotFoundError:
        print(f"File not found: {filepath}")
        return {}
    except json.JSONDecodeError as e:
        print(f"Invalid JSON: {e}")
        return {}

# Good: re-raise if you can't handle
def fetch_user(user_id):
    try:
        return api.get(f"/users/{user_id}")
    except ConnectionError:
        retry_logic()
    # ValueError propagates

# Bad: catch-all
try:
    result = some_operation()
except Exception:
    return None  # hides errors

# Bad: catch BaseException
try:
    operation()
except BaseException:  # catches KeyboardInterrupt!
    pass
```

### Custom Exceptions

```python
# Good: custom exceptions
class ValidationError(Exception):
    """Data validation failed."""
    pass

class UserNotFoundError(Exception):
    """User not found."""
    pass

# Good: use specifically
def get_user(user_id):
    if not user_id:
        raise ValidationError("user_id required")

    user = db.find(user_id)
    if not user:
        raise UserNotFoundError(f"User {user_id} not found")
    return user

# Good: exception hierarchy
class ApiError(Exception):
    """Base for API errors."""
    pass

class BadRequestError(ApiError):
    """400 Bad Request."""
    pass

class NotFoundError(ApiError):
    """404 Not Found."""
    pass
```

---

## Code Organization

### Code Organization

```python
# Good: module docstring
"""
User management module.

Provides functions for creating, updating, deleting users,
and user authentication.
"""

import os
import sys
from typing import Dict, List, Optional
from datetime import datetime

import requests
from sqlalchemy import create_engine

from myapp.models import User
from myapp.utils import validate_email

# Bad: wildcard imports
from myapp.utils import *  # unclear what's imported
```

---

## Common Pitfalls

### Mutable Default Arguments

```python
# Bad: mutable default persists across calls
def add_user(name, user_list=[]):
    user_list.append(name)
    return user_list

result1 = add_user("Alice")  # ["Alice"]
result2 = add_user("Bob")    # ["Alice", "Bob"] - SURPRISE!

# Good: use None as default
def add_user(name, user_list=None):
    if user_list is None:
        user_list = []
    user_list.append(name)
    return user_list
```

### Side Effects in Properties

```python
# Bad: property with side effect
class User:
    @property
    def data(self):
        self.log_access()  # side effect in getter!
        return self._data

# Good: explicit method
class User:
    @property
    def data(self):
        return self._data

    def get_data_with_logging(self):
        self.log_access()
        return self._data
```

### Silent Failures

```python
# Bad: silent
def process_item(item):
    try:
        return transform(item)
    except Exception:
        pass  # what went wrong?

# Good: log or handle
def process_item(item):
    try:
        return transform(item)
    except ValueError as e:
        logger.warning(f"Invalid: {e}")
        return None
    except Exception as e:
        logger.error(f"Error: {e}")
        raise
```

### `__slots__` for Performance

```python
# Good: __slots__ reduces memory in tight loops
class Point:
    __slots__ = ['x', 'y']

    def __init__(self, x, y):
        self.x = x
        self.y = y

# Less efficient: dynamic __dict__ (default)
class Point:
    def __init__(self, x, y):
        self.x = x
        self.y = y
```

---

## Summary

Pythonic code is readable, explicit, and idiomatic:
- Use comprehensions, context managers, EAFP
- Add type hints for clarity
- Follow PEP 8 and PEP 20
- Small, focused functions
