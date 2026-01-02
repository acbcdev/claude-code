---
name: JavaScript/TypeScript Code Style Reference
description: Language-specific style guidelines, patterns, and best practices for JavaScript and TypeScript projects.
---

# JavaScript/TypeScript Style Guide

This guide complements the main code-style skill with JavaScript and TypeScript-specific patterns, syntax preferences, and idioms. Follow these guidelines alongside the universal principles in the main skill.

---

## Variable Declarations

Use `const` by default, `let` for reassignment, never `var`.

---

## Modern Syntax & Features

### Arrow Functions for Anonymous Functions

Use arrow functions for callbacks; use named functions for exports or recursion.

```javascript
const doubled = numbers.map(n => n * 2);        // Good: arrow
const filtered = numbers.filter(n => n > 1);    // Good: arrow

function factorial(n) {                          // Good: named for recursion
  return n <= 1 ? 1 : n * factorial(n - 1);
}

// Watch: arrow functions don't bind 'this' correctly in methods
const obj = {
  greet: () => console.log(this.name),           // Bad: wrong 'this'
  greetRight: function() { console.log(this); }  // Good: correct 'this'
};
```

### Template Literals Over String Concatenation

```javascript
const greeting = `Hello, ${name}!`;                                    // Good
const url = `https://api.example.com/users/${userId}`;                 // Good
const multiLine = `Line 1\nLine 2`;                                    // Good

const badGreeting = 'Hello, ' + name + '!';                            // Bad: concatenation
const badUrl = 'https://api.example.com/users/' + userId;              // Bad: concatenation
```

### Destructuring

```javascript
// Good: destructuring in parameters
function renderUser({ name, email, isActive }) {
  if (!isActive) return null;
  return `${name} (${email})`;
}

// Good: array destructuring
const [first, second] = getCoordinates();

// Good: default values
function fetchUser({ id = 1 } = {}) { }

// In loops, destructure in body for clarity:
for (const user of users) {
  const { id, name } = user;  // Good: readable
}
```

### Array Methods Over Loops

```javascript
const doubled = numbers.map(n => n * 2);          // Good: declarative
const evens = numbers.filter(n => n % 2 === 0);   // Good: intent clear
const sum = numbers.reduce((acc, n) => acc + n);  // Good: reduce

// OK: for loop with early exit
for (const user of users) {
  if (user.id === targetId) {
    found = user;
    break;
  }
}

// Bad: for loop for transformation
const doubled = [];
for (let i = 0; i < numbers.length; i++) doubled.push(numbers[i] * 2);
```

---

## Asynchronous Code

### `async`/`await` Over Promises

```javascript
// Good: async/await
async function fetchAndProcess(userId) {
  try {
    const user = await api.getUser(userId);
    const posts = await api.getPosts(user.id);
    return { user, posts };
  } catch (error) {
    logger.error('Failed:', error);
    throw error;
  }
}

// Good: Promise.all for concurrency
const results = await Promise.all(ids.map(id => api.fetch(id)));

// Bad: promise chains
api.getUser(userId)
  .then(user => api.getPosts(user.id).then(posts => ({ user, posts })))
  .catch(error => logger.error(error));
```

### Error Handling in Async

```javascript
// Good: catch and handle or rethrow
async function saveUser(user) {
  try {
    await db.save(user);
  } catch (error) {
    if (error.code === 'DUPLICATE_KEY') throw new UserAlreadyExistsError(user.id);
    throw error;
  }
}

// Good: let errors propagate
async function processUsers(users) {
  return Promise.all(users.map(u => saveUser(u)));
}

// Bad: silent failures
async function getUser(id) {
  try {
    return await api.getUser(id);
  } catch (error) {
    // silently fails - DON'T DO THIS
  }
}
```

---

## Conditional Statements

### Guard Clauses Over Else

```javascript
// Good: guard clauses
function validateUser(user) {
  if (!user) return false;
  if (!user.email) return false;
  if (!user.isActive) return false;
  return true;
}

// Good: guard clause
function processOrder(order) {
  if (!order.isValid()) throw new ValidationError('Invalid order');
  // happy path continues
}

// Bad: nested if/else
function validateUser(user) {
  if (user) {
    if (user.email) {
      if (user.isActive) return true;
      else return false;
    } else return false;
  } else return false;
}
```

### Ternary for Simple Conditions

```javascript
const status = isActive ? 'active' : 'inactive';        // Good: simple
const message = count > 0 ? `${count} items` : 'empty'; // Good: simple

const bad = isActive ? (isPremium ? 'premium' : 'active') : 'inactive';  // Bad: nested

// Better: use function for complex logic
function getStatus(isActive, isPremium) {
  if (!isActive) return 'inactive';
  return isPremium ? 'premium' : 'active';
}
```

---

## TypeScript-Specific Guidelines

### Avoid `any` Type

```typescript
// Bad: any
function process(data: any) { return data.value + 1; }

// Good: specific type
interface DataPoint { value: number; }
function process(data: DataPoint) { return data.value + 1; }

// Good: generic
function identity<T>(data: T): T { return data; }

// Acceptable: unknown with type guard
function process(data: unknown) {
  if (typeof data === 'object' && 'value' in data) {
    return (data as { value: number }).value;
  }
  throw new Error('Invalid');
}
```

### Interfaces for Object Contracts

```typescript
// Good: clear interface
interface User {
  id: number;
  name: string;
  email: string;
  isActive: boolean;
}

// Good: composition
interface AdminUser extends User { permissions: Permission[]; }

// Good: generic
interface ApiResponse<T> {
  data: T;
  status: number;
  error?: string;
}

// Bad: overly generic
interface Data { [key: string]: any; }
```

### Type Annotations Sparingly

```typescript
// Good: inferred (obvious)
const count = 0;              // inferred as number
const name = 'Alice';         // inferred as string

// Good: annotate function boundaries
function calculateTotal(items: CartItem[]): number {
  return items.reduce((sum, item) => sum + item.price, 0);
}

// Good: annotate external boundaries
const response: ApiResponse<User> = await fetch(url);

// Avoid: unnecessary annotations
const count: number = 0;      // redundant
const name: string = 'Alice'; // redundant
```

---

## Module Organization

### Import/Export Organization

```typescript
// Good: organized by source
import express, { Router } from 'express';
import { v4 as uuid } from 'uuid';

import { UserRepository } from './repositories/UserRepository';
import type { User, ApiResponse } from './types';

// Good: named exports
export function createUser(data: UserData): User { }
export function deleteUser(id: string): Promise<void> { }

// Acceptable: default export
export default UserService;

// Avoid: unclear exports
module.exports = { a: funcA, b: funcB };

// Avoid: wildcard without alias
import * from './utils'; // Unclear what's available
import * as utils from './utils'; // Better with alias
```

---

## Common Pitfalls

### Boolean Parameters

```typescript
// Bad: flag parameter
function sendNotification(user: User, isEmail: boolean) {
  if (isEmail) sendEmailNotification(user);
  else sendSmsNotification(user);
}

// Good: separate functions
function sendEmailNotification(user: User) { }
function sendSmsNotification(user: User) { }
```

### Magic Values

```typescript
if (retries > 3) { }              // Bad: magic number
const delay = 5000;                // Bad: unclear unit

const MAX_RETRIES = 3;             // Good: named
const RETRY_DELAY_MS = 5000;       // Good: unit specified
```

### Silent Errors

```typescript
try { await saveUser(user); } catch (error) { }  // Bad: silent

try {
  await saveUser(user);
} catch (error) {
  logger.error('Failed:', error);  // Good: log or rethrow
  throw error;
}
```

### Side Effects in Getters

```typescript
get user() {
  analytics.track('accessed');  // Bad: side effect in getter
  return this._user;
}

function getUserWithTracking() {  // Good: explicit function
  analytics.track('accessed');
  return this._user;
}
```

---

## Summary

Modern JavaScript/TypeScript is declarative, typed, and composable:
- Use array methods, async/await, destructuring
- Guard clauses, early returns, clear names
- Specific types, avoid `any`
- Small, focused functions
