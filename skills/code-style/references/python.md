---
name: Python Code Style Reference
description: Language-specific style guidelines, patterns, and Pythonic best practices for Python projects.
---

# Python Style Guide

This guide complements the main code-style skill with Python-specific patterns, Pythonic idioms, and conventions. Follow these guidelines alongside the universal principles in the main skill.

Reference: [PEP 8 - Style Guide for Python Code](https://pep8.org/) and [PEP 20 - The Zen of Python](https://www.python.org/dev/peps/pep-0020/)

---

## Naming Conventions

Python uses `snake_case` for functions, variables, and modules, and `PascalCase` for classes.

### Functions and Variables

Use `snake_case` with lowercase and underscores.

**Examples:**

```python
# Good: snake_case
def calculate_total(items):
    return sum(item.price for item in items)

user_name = "Alice"
is_active = True
max_retries = 3

# Bad: camelCase in Python
def calculateTotal(items):  # not Pythonic
    pass

userName = "Alice"  # not Pythonic

# Good: private/internal convention (single underscore)
def _internal_helper():
    """This function is intended for internal use only."""
    pass

# Good: magic/protected (double underscore, name mangling)
class User:
    def __init__(self):
        self.__password = None  # name mangling for true privacy
```

### Constants

Use `UPPER_CASE` with underscores for module-level constants.

**Examples:**

```python
# Good: constants
MAX_RETRIES = 3
API_TIMEOUT_SECONDS = 30
DATABASE_HOST = "localhost"
ALLOWED_FILE_TYPES = {"jpg", "png", "gif"}

# Good: inside functions/classes, treat as regular variables
def process_image():
    max_size = 5 * 1024 * 1024  # local constant
    return max_size
```

### Boolean Variables and Functions

Prefix with `is_`, `has_`, `can_`, `should_`, or `do_` to clarify they return booleans.

**Examples:**

```python
# Good: clear boolean intent
is_valid = True
has_permission = user.has_permission('delete')
can_delete = current_user.role == 'admin'
should_cache = response.status_code == 200
does_exist = os.path.exists(filepath)

# Bad: unclear
valid = True  # is it a status or a boolean?
permission = user.has_permission('delete')  # what is permission?
```

---

## Pythonic Idioms

### Prefer Comprehensions Over Loops

List, dict, and set comprehensions are more readable and efficient.

**Examples:**

```python
# Good: list comprehension
numbers = [1, 2, 3, 4, 5]
doubled = [n * 2 for n in numbers]
evens = [n for n in numbers if n % 2 == 0]

# Good: dict comprehension
data = {'a': 1, 'b': 2}
inverted = {v: k for k, v in data.items()}

# Good: set comprehension
unique_squares = {n * n for n in numbers}

# OK: for loop when comprehension is complex or unreadable
results = []
for item in items:
    if should_process(item):
        processed = expensive_transform(item)
        if processed:
            results.append(processed)

# Less Pythonic: nested list comprehension (hard to read)
nested = [[j * 2 for j in range(i)] for i in range(5)]

# Better: use a loop if nested comprehension is hard to understand
nested = []
for i in range(5):
    row = [j * 2 for j in range(i)]
    nested.append(row)
```

### EAFP Over LBYK (Look Before You Leap)

Python prefers "Easier to Ask for Forgiveness than Permission." Use try/except instead of checking conditions.

**Examples:**

```python
# Good: EAFP (Pythonic)
try:
    value = data['key']
except KeyError:
    value = None

# Less Pythonic: LBYK
if 'key' in data:
    value = data['key']
else:
    value = None

# Good: EAFP for operations
try:
    result = int(user_input)
except ValueError:
    print("Invalid input")
    result = 0

# Good: EAFP for attribute access
try:
    name = person.full_name
except AttributeError:
    name = f"{person.first_name} {person.last_name}"

# Exception to EAFP: multiple dictionary lookups
# Still EAFP but might use get() for brevity
value = data.get('key', 'default')

# Or explicit defaults
try:
    name = config['name']
except KeyError:
    name = 'Unknown'
```

### Use Context Managers (`with` Statements)

Context managers handle setup and cleanup automatically, especially for file/resource management.

**Examples:**

```python
# Good: context manager for files
with open('data.txt') as f:
    content = f.read()
# file is automatically closed

# Good: multiple context managers (Python 3.10+)
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

with timer("expensive operation"):
    expensive_computation()

# Bad: manual cleanup (error-prone)
f = open('data.txt')
content = f.read()
f.close()  # might not run if exception occurs
```

### Use f-Strings Over `.format()` and `%`

f-Strings are more readable and efficient (Python 3.6+).

**Examples:**

```python
# Good: f-strings
name = "Alice"
age = 30
greeting = f"Hello, {name}!"
message = f"{name} is {age} years old"

# Good: f-string expressions
price = 19.99
message = f"Price: ${price:.2f}"
items = [1, 2, 3]
message = f"Total items: {len(items)}"

# OK: .format() for older Python versions
message = "Hello, {}!".format(name)

# Bad: string concatenation
message = "Hello, " + name + "!"
message = "Price: $" + str(price)

# Bad: % formatting (older style)
message = "Hello, %s!" % name
```

### Avoid Magic Strings/Numbers

Extract configuration values to module-level constants.

**Examples:**

```python
# Good: named constants
REDIS_HOST = "localhost"
REDIS_PORT = 6379
MAX_CONNECTIONS = 10
CACHE_TTL_SECONDS = 3600

def connect_redis():
    return redis.Redis(host=REDIS_HOST, port=REDIS_PORT)

# Bad: magic values scattered
def connect_redis():
    return redis.Redis(host="localhost", port=6379)

def cache_result(key, value):
    cache.set(key, value, 3600)  # what is 3600?
```

---

## Type Hints and Annotations

### Use Type Hints

Type hints improve code clarity and enable static type checking with mypy.

**Examples:**

```python
# Good: function with type hints
def calculate_total(items: list[float]) -> float:
    return sum(items)

def greet(name: str) -> str:
    return f"Hello, {name}!"

# Good: complex types
from typing import Optional, Dict, List

def find_user(user_id: int) -> Optional[User]:
    """Returns user or None if not found."""
    return users.get(user_id)

def process_data(data: Dict[str, List[int]]) -> None:
    for key, values in data.items():
        total = sum(values)

# Good: type hints on variables
count: int = 0
user_names: list[str] = []
config: Dict[str, Any] = {}

# Python 3.10+ union types
def process(value: int | str) -> None:
    pass

# Pre-3.10 union types
from typing import Union
def process(value: Union[int, str]) -> None:
    pass

# OK: omit types for obvious cases if you prefer brevity
# But more complete type hints are better
```

### Use Protocol for Structural Typing

When you don't need inheritance, use Protocol to define interfaces.

**Examples:**

```python
from typing import Protocol

# Good: Protocol for interface
class Drawable(Protocol):
    def draw(self) -> None: ...

def render(shape: Drawable) -> None:
    shape.draw()

# Works with any class that has draw() method
class Circle:
    def draw(self):
        print("Drawing circle")

class Square:
    def draw(self):
        print("Drawing square")

# Both work with render() without inheritance
render(Circle())
render(Square())
```

---

## Exception Handling

### Specific Exception Handling

Catch specific exceptions, not broad `Exception` or `BaseException`.

**Examples:**

```python
# Good: specific exceptions
def parse_config(filepath):
    try:
        with open(filepath) as f:
            return json.load(f)
    except FileNotFoundError:
        print(f"Config file not found: {filepath}")
        return {}
    except json.JSONDecodeError as e:
        print(f"Invalid JSON in config: {e}")
        return {}

# Good: re-raise if you can't handle
def fetch_user(user_id):
    try:
        return api.get(f"/users/{user_id}")
    except ConnectionError:
        retry_logic()
    # ValueError propagates to caller

# Bad: catch-all (hides bugs)
try:
    result = some_operation()
except Exception:
    return None  # masks real errors

# Bad: catch BaseException
try:
    operation()
except BaseException:  # catches KeyboardInterrupt, SystemExit!
    pass
```

### Create Custom Exceptions

Define specific exceptions for your domain.

**Examples:**

```python
# Good: custom exceptions
class ValidationError(Exception):
    """Raised when data validation fails."""
    pass

class UserNotFoundError(Exception):
    """Raised when a user cannot be found."""
    pass

class DatabaseError(Exception):
    """Raised when a database operation fails."""
    pass

# Good: use them specifically
def get_user(user_id):
    if not user_id:
        raise ValidationError("user_id is required")

    user = db.find(user_id)
    if not user:
        raise UserNotFoundError(f"User {user_id} not found")

    return user

# Good: hierarchy for grouping
class ApiError(Exception):
    """Base exception for API errors."""
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

### Module-Level Docstrings

Every module should start with a docstring explaining its purpose.

**Examples:**

```python
"""
User management module.

This module provides functions for creating, updating, and deleting users,
as well as user authentication and authorization.
"""

import os
from typing import Optional
from datetime import datetime

# ... rest of module
```

### Clear Imports

Organize imports: standard library, third-party, local modules.

**Examples:**

```python
# Good: organized imports
import os
import sys
from typing import Dict, List, Optional
from datetime import datetime

import requests
from sqlalchemy import create_engine
from sqlalchemy.orm import Session

from myapp.models import User
from myapp.utils import validate_email
from myapp.config import DATABASE_URL

# Bad: unorganized or wildcard imports
from myapp.utils import *  # unclear what's imported
import *  # never do this
```

---

## Common Pitfalls

### 1. Mutable Default Arguments

Never use mutable objects as default arguments; they persist across calls.

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

result1 = add_user("Alice")  # ["Alice"]
result2 = add_user("Bob")    # ["Bob"]
```

### 2. Side Effects in Properties

Use `@property` for simple accessors; use regular methods for operations with side effects.

```python
# Bad: property with side effect
class User:
    @property
    def data(self):
        self.log_access()  # side effect!
        return self._data

# Good: explicit method for side-effect code
class User:
    @property
    def data(self):
        return self._data

    def get_data_with_logging(self):
        self.log_access()
        return self._data
```

### 3. Not Using `__slots__` for Performance-Critical Classes

In tight loops, `__slots__` reduces memory and speeds up attribute access.

```python
# Good: __slots__ for data classes
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

### 4. Silent Failures

Log or handle exceptions explicitly.

```python
# Bad: silent failure
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
        logger.warning(f"Invalid item {item}: {e}")
        return None
    except Exception as e:
        logger.error(f"Unexpected error processing {item}: {e}")
        raise
```

---

## Summary

Pythonic code is:
- **Readable:** Clear names, comprehensions, context managers
- **Explicit:** No magic, handle errors with EAFP
- **Type-aware:** Use type hints for clarity and static analysis
- **Idiomatic:** Follow PEP 8 and PEP 20 (Zen of Python)
- **Maintainable:** Small functions with single purpose

Remember: "Beautiful is better than ugly. Explicit is better than implicit." — The Zen of Python
