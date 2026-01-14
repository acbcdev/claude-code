---
name: Python Code Style Reference
description: Language-specific style guidelines for Python projects.
---

# Python Style Guide

Reference: [PEP 8](https://pep8.org/) and [PEP 20 - Zen of Python](https://www.python.org/dev/peps/pep-0020/)

## Naming Conventions

- **Use `snake_case`** for functions, variables, constants
- **Use `PascalCase`** for classes
- **Prefix booleans** with `is_`, `has_`, `can_`, `should_`, `does_`
- **Use `UPPER_CASE`** for module-level constants
- **DO NOT use camelCase** - not Pythonic

```python
def calculate_total(items):      # Good: snake_case
    pass

user_name = "Alice"              # Good: snake_case
is_active = True                 # Good: boolean prefix
MAX_RETRIES = 3                  # Good: constant

class User:                       # Good: PascalCase
    pass

def calculateTotal():            # Bad: camelCase
    pass
```

## Pythonic Idioms

- **PREFER comprehensions** - `[x*2 for x in list]`
- **PREFER EAFP over LBYK** - use try/except instead of checking conditions
- **Use context managers** - `with open(file) as f:`
- **Use f-strings** - `f"Hello, {name}!"`
- **DO NOT use string concatenation** with `+`

```python
# Good: comprehensions
doubled = [n * 2 for n in numbers]
evens = [n for n in numbers if n % 2 == 0]
inverted = {v: k for k, v in data.items()}

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

# Good: context manager
with open('data.txt') as f:
    content = f.read()

# Good: f-strings
greeting = f"Hello, {name}!"
message = f"Price: ${price:.2f}"

# Bad: string concatenation
greeting = "Hello, " + name + "!"

# OK: .get() for simple cases
value = data.get('key', 'default')
```

## Context Managers

- **Use `with` statements** for automatic cleanup
- **Use custom context managers** for setup/teardown logic
- **DO NOT manually close resources** - error-prone

```python
# Good: automatic cleanup
with open('data.txt') as f:
    content = f.read()

# Good: multiple resources
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

# Bad: manual cleanup
f = open('data.txt')
content = f.read()
f.close()  # might not run if exception occurs
```

## Type Hints

- **Add type hints** for clarity and static analysis
- **Annotate function parameters and returns**
- **Use specific types**, not generic containers
- **PREFER `|` for unions** (Python 3.10+)
- **DO NOT use `any`** - use specific types or `unknown`

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

# Good: union types (Python 3.10+)
def process(value: int | str) -> None:
    pass

# Pre-3.10: use Union
from typing import Union
def process(value: Union[int, str]) -> None:
    pass

# Good: Protocol for interfaces (no inheritance needed)
from typing import Protocol

class Drawable(Protocol):
    def draw(self) -> None: ...

def render(shape: Drawable) -> None:
    shape.draw()
```

## Exception Handling

- **Catch specific exceptions**, not broad `Exception`
- **DO NOT catch `BaseException`** - catches KeyboardInterrupt, SystemExit
- **Define custom exceptions** for your domain
- **DO NOT silently swallow errors** - log or rethrow
- **Only catch errors you can handle** - let others propagate

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

# Good: custom exceptions
class ValidationError(Exception):
    """Data validation failed."""
    pass

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
    pass

class NotFoundError(ApiError):
    pass

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

# Bad: silent errors
def process_item(item):
    try:
        return transform(item)
    except Exception:
        pass  # what went wrong?
```

## Code Organization

- **Module docstring at top** explaining purpose
- **Organize imports:** stdlib, third-party, local
- **DO NOT use wildcard imports** - unclear what's available
- **Group related functions and classes**

```python
"""
User management module.

Provides functions for user CRUD operations and authentication.
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
from myapp.utils import *  # unclear
```

## Anti-Patterns to Avoid

- **Mutable default arguments** - persist across calls
- **Side effects in properties** - use explicit methods
- **List comprehensions too complex** - use loops for readability
- **Magic numbers/strings** - extract to named constants

```python
# Bad: mutable default
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

# Bad: nested comprehension (hard to read)
nested = [[j * 2 for j in range(i)] for i in range(5)]

# Good: use loop for clarity
nested = []
for i in range(5):
    nested.append([j * 2 for j in range(i)])

# Bad: magic values
REDIS_HOST = "localhost"
REDIS_PORT = 6379

def connect_redis():
    return redis.Redis(host="localhost", port=6379)  # Bad: magic values

# Good: named constants
REDIS_HOST = "localhost"
REDIS_PORT = 6379
def connect_redis():
    return redis.Redis(host=REDIS_HOST, port=REDIS_PORT)
```

## Quick Reference

- Use `snake_case` for functions/variables, `PascalCase` for classes
- Prefer comprehensions, EAFP, context managers, f-strings
- Add type hints for clarity
- Catch specific exceptions; no silent failures
- Avoid mutable defaults, side effects in properties, wildcard imports
- Extract magic values to named constants
- Follow PEP 8 and Zen of Python
