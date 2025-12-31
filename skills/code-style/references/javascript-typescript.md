---
name: JavaScript/TypeScript Code Style Reference
description: Language-specific style guidelines, patterns, and best practices for JavaScript and TypeScript projects.
---

# JavaScript/TypeScript Style Guide

This guide complements the main code-style skill with JavaScript and TypeScript-specific patterns, syntax preferences, and idioms. Follow these guidelines alongside the universal principles in the main skill.

---

## Variable Declarations

### Prefer `const` Over `let` Over `var`

Use `const` by default. Use `let` when you need to reassign. Never use `var`.

**Why:**
- `const` prevents accidental reassignment
- `const` signals intent: "this won't change"
- Block scoping (let/const) prevents scope leakage (var's flaw)
- `const` doesn't prevent object/array mutation; it prevents rebinding

**Examples:**

```javascript
// Good: const for objects/arrays that won't be reassigned
const user = { name: 'Alice' };
user.name = 'Bob'; // OK - mutation is fine

// Good: const for primitives
const MAX_RETRIES = 3;
const apiUrl = 'https://api.example.com';

// Acceptable: let when reassignment is needed
let attempt = 0;
while (attempt < MAX_RETRIES) {
  attempt++;
}

// Bad: var creates scope confusion
var count = 0; // Don't do this
```

---

## Modern Syntax & Features

### Prefer Arrow Functions for Anonymous Functions

Arrow functions are concise and have consistent `this` binding.

**Examples:**

```javascript
// Good: arrow functions
const numbers = [1, 2, 3];
const doubled = numbers.map(n => n * 2);
const filtered = numbers.filter(n => n > 1);

// Good: named functions for named exports or recursive functions
function calculateFactorial(n) {
  return n <= 1 ? 1 : n * calculateFactorial(n - 1);
}

// Bad: traditional anonymous function syntax
const doubled = numbers.map(function(n) { return n * 2; });

// Watch out: arrow functions and this binding
const person = {
  name: 'Alice',
  greet: () => console.log(this.name), // 'this' is wrong - don't use arrow here
  greetRight: function() { console.log(this.name); } // correct
};
```

### Use Template Literals Over String Concatenation

Template literals are clearer and prevent concatenation errors.

**Examples:**

```javascript
// Good: template literals
const greeting = `Hello, ${name}!`;
const multiLine = `
  First line
  Second line
`;
const html = `<div class="${className}">${content}</div>`;

// Bad: string concatenation
const greeting = 'Hello, ' + name + '!';
const html = '<div class="' + className + '">' + content + '</div>';

// Bad: mixing quotes in concatenation
const url = 'https://api.example.com/users/' + userId;

// Good: template literal
const url = `https://api.example.com/users/${userId}`;
```

### Destructuring for Function Parameters and Objects

Destructuring reduces variable declarations and makes function signatures clearer.

**Examples:**

```javascript
// Good: object destructuring in parameters
function renderUser({ name, email, isActive }) {
  if (!isActive) return null;
  return `${name} (${email})`;
}

// Good: array destructuring for known positions
const [first, second] = getCoordinates();

// Good: default values with destructuring
function fetchUser({ id = 1, includeProfile = false } = {}) {
  // ...
}

// Avoid: unnecessary destructuring
// Bad: destructuring then immediately reassigning
const { x } = point;
const { y } = point; // extract separately only if you'll use each one differently

// Good: destructure only what you use
const { id, name } = user; // keep email if you don't use it
```

**Exception:** Avoid destructuring in the loop header for clarity:

```javascript
// Less clear
for (const { id, name } of users) { }

// Clearer - destructure in the body if complex
for (const user of users) {
  const { id, name } = user;
}
```

### Use Array Methods Over Loops

`map()`, `filter()`, `reduce()`, and others express intent better than for/while loops.

**Examples:**

```javascript
// Good: array methods
const numbers = [1, 2, 3, 4, 5];
const doubled = numbers.map(n => n * 2);
const evens = numbers.filter(n => n % 2 === 0);
const sum = numbers.reduce((acc, n) => acc + n, 0);

// OK: for loop when you need early exit
let found = null;
for (const user of users) {
  if (user.id === targetId) {
    found = user;
    break; // early exit is OK
  }
}

// Bad: for loop for simple transformations
const doubled = [];
for (let i = 0; i < numbers.length; i++) {
  doubled.push(numbers[i] * 2);
}
```

---

## Asynchronous Code

### Prefer `async`/`await` Over Promises

`async`/`await` reads linearly and reduces callback/promise nesting.

**Examples:**

```javascript
// Good: async/await
async function fetchAndProcess(userId) {
  try {
    const user = await api.getUser(userId);
    const posts = await api.getPosts(user.id);
    return { user, posts };
  } catch (error) {
    logger.error('Failed to fetch:', error);
    throw error;
  }
}

// OK: Promises when you need multiple concurrent requests
async function getParallelData(ids) {
  const results = await Promise.all(
    ids.map(id => api.fetch(id))
  );
  return results;
}

// Bad: promise chains
api.getUser(userId)
  .then(user => api.getPosts(user.id)
    .then(posts => ({ user, posts }))
  )
  .catch(error => logger.error(error));
```

### Error Handling in Async Functions

Always handle errors in async functions. Use try/catch at appropriate levels.

**Examples:**

```javascript
// Good: catch at the point of awareness
async function saveUser(user) {
  try {
    await db.save(user);
  } catch (error) {
    if (error.code === 'DUPLICATE_KEY') {
      throw new UserAlreadyExistsError(user.id);
    }
    throw error; // re-throw if you can't handle it
  }
}

// Good: let errors propagate to higher-level handlers
async function processUsers(users) {
  return Promise.all(users.map(u => saveUser(u)));
  // errors propagate to caller
}

// Bad: catching errors you can't handle
async function getUser(id) {
  try {
    return await api.getUser(id);
  } catch (error) {
    // silently failing
  }
}
```

---

## Conditional Statements

### Avoid Else Statements - Use Guard Clauses

Guard clauses (early returns) are clearer than nested if/else.

**Examples:**

```javascript
// Good: guard clauses
function validateUser(user) {
  if (!user) return false;
  if (!user.email) return false;
  if (!user.isActive) return false;
  return true;
}

// Good: single guard clause when appropriate
function processOrder(order) {
  if (!order.isValid()) {
    throw new ValidationError('Invalid order');
  }
  // ... rest of happy path
}

// Bad: nested if/else
function validateUser(user) {
  if (user) {
    if (user.email) {
      if (user.isActive) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  } else {
    return false;
  }
}

// Bad: else when not needed
if (condition) {
  doThis();
} else {
  doThat();
}
// Better (if both don't need to happen):
if (condition) return doThis();
doThat();
```

### Use Ternary Operator for Simple Conditions

Ternary is good for inline decisions; avoid nested ternaries.

**Examples:**

```javascript
// Good: simple ternary
const status = isActive ? 'active' : 'inactive';
const message = count > 0 ? `${count} items` : 'No items';

// Bad: nested ternary (hard to read)
const status = isActive ? (isPremium ? 'premium' : 'active') : 'inactive';

// Better: use if statement or extract to function
function getStatus(isActive, isPremium) {
  if (!isActive) return 'inactive';
  return isPremium ? 'premium' : 'active';
}
```

---

## TypeScript-Specific Guidelines

### Avoid `any` Type

`any` defeats TypeScript's type safety. Use specific types or `unknown`.

**Examples:**

```typescript
// Bad: any
function process(data: any) {
  return data.value + 1;
}

// Good: specific type
interface DataPoint {
  value: number;
}
function process(data: DataPoint) {
  return data.value + 1;
}

// Good: generic when the type is truly flexible
function process<T>(data: T): T {
  return data;
}

// Acceptable: unknown with type guards
function process(data: unknown) {
  if (typeof data === 'object' && data !== null && 'value' in data) {
    return (data as { value: number }).value;
  }
  throw new Error('Invalid data');
}
```

### Use Interfaces for Object Contracts

Interfaces define clear contracts. Use `extends` for inheritance, composition for flexibility.

**Examples:**

```typescript
// Good: clear interface
interface User {
  id: number;
  name: string;
  email: string;
  isActive: boolean;
}

// Good: interface composition
interface AdminUser extends User {
  permissions: Permission[];
}

// Good: generic interface for reusability
interface ApiResponse<T> {
  data: T;
  status: number;
  error?: string;
}

// Avoid: overly generic interface
interface Data {
  [key: string]: any; // defeats type safety
}
```

### Use Type Annotations Sparingly

Let TypeScript infer types when obvious. Annotate at boundaries.

**Examples:**

```typescript
// Good: inferred types (obvious)
const count = 0; // TypeScript infers number
const name = 'Alice'; // TypeScript infers string
const users = []; // Infer from usage

// Good: annotate function parameters and returns
function calculateTotal(items: CartItem[]): number {
  return items.reduce((sum, item) => sum + item.price, 0);
}

// Good: annotate at external boundaries
const response: ApiResponse<User> = await fetch(url);

// Avoid: unnecessary annotations
const count: number = 0; // number is obvious
const name: string = 'Alice'; // string is obvious
```

---

## Module Organization

### Clear Import/Export Practices

Organize imports by source (external, internal, types). Use named exports for clarity.

**Examples:**

```typescript
// Good: organized imports
import express, { Router } from 'express';
import { v4 as uuid } from 'uuid';

import { UserRepository } from './repositories/UserRepository';
import { validateEmail } from './utils/validation';
import type { User, ApiResponse } from './types';

// Good: named exports for clear API
export function createUser(data: UserData): User { }
export function deleteUser(id: string): Promise<void> { }

// Acceptable: default export for single main export
export default UserService;

// Avoid: mixing many unnamed exports
module.exports = {
  a: funcA,
  b: funcB, // unclear API
};

// Avoid: wildcard imports unless aliased
import * as utils from './utils'; // OK with alias
import * from './utils'; // avoid - unclear what's available
```

---

## Common Pitfalls

### 1. Boolean Parameter Flag Anti-Pattern

Boolean parameters create multiple code paths and are confusing.

```typescript
// Bad: boolean parameter creates branches
function sendNotification(user: User, isEmail: boolean) {
  if (isEmail) {
    sendEmailNotification(user);
  } else {
    sendSmsNotification(user);
  }
}

// Better: separate specific functions
function sendEmailNotification(user: User) { }
function sendSmsNotification(user: User) { }

// Use: let caller choose which to call
```

### 2. Magic Strings/Numbers

Extract configuration values to named constants.

```typescript
// Bad: magic numbers scattered
if (retries > 3) { } // what is 3?
const delay = 5000; // what time unit?

// Good: named constants
const MAX_RETRIES = 3;
const RETRY_DELAY_MS = 5000;
if (retries > MAX_RETRIES) { }
```

### 3. Silent Errors

Never silently catch errors without handling or logging.

```typescript
// Bad: silent failure
try {
  await saveUser(user);
} catch (error) {
  // oops, user wasn't saved
}

// Good: handle or log
try {
  await saveUser(user);
} catch (error) {
  logger.error('Failed to save user:', error);
  throw error; // or handle specifically
}
```

### 4. Side Effects in Selectors/Getters

Functions that look like accessors shouldn't have side effects.

```typescript
// Bad: getter with side effect
get user() {
  analytics.track('user accessed'); // side effect!
  return this._user;
}

// Good: explicit function for side-effect code
function getUserWithTracking() {
  analytics.track('user accessed');
  return this._user;
}
```

---

## Summary

Modern JavaScript/TypeScript code is:
- **Declarative:** Use array methods, async/await, destructuring
- **Clear:** Guard clauses over nested conditions, explicit function names
- **Typed:** (TypeScript) Use specific types, avoid `any`
- **Composable:** Small functions with single purpose
- **Functional:** Prefer pure functions, immutable data when possible

Remember: JavaScript evolved rapidly. These guidelines reflect 2025 best practices using ES2020+ features.
