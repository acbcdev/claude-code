---
name: JavaScript/TypeScript Code Style Reference
description: Language-specific style guidelines for JavaScript and TypeScript.
---

# JavaScript/TypeScript Style Guide

## Variable Declarations

- **PREFER `const` by default** - prevents accidental reassignment
- **Use `let` for reassignment only**
- **DO NOT use `var`** - use `const` or `let`

```javascript
const MAX_RETRIES = 3;        // Good: const by default
let attempt = 0;              // OK: reassignment needed
var count = 0;                // Bad: avoid var
```

## Functions & Control Flow

- **Use arrow functions for callbacks:** `numbers.map(n => n * 2)`
- **Use named functions for recursion or exports**
- **DO NOT use `else` statements** - use guard clauses and early returns
- **DO NOT use nested ternaries** - extract to function if complex
- **Prefer ternary for simple conditions only**

```javascript
// Good: arrow functions and guard clauses
const doubled = numbers.map(n => n * 2);

function validateUser(user) {
  if (!user) return false;
  if (!user.email) return false;
  return true;
}

// Good: simple ternary
const status = isActive ? 'active' : 'inactive';

// Bad: else statements
if (condition) { doThis(); } else { doThat(); }

// Bad: nested ternary
const x = a ? (b ? 'x' : 'y') : 'z';
```

## Strings & Templates

- **PREFER template literals** - clearer, prevent concatenation errors
- **DO NOT concatenate strings** with `+` operator

```javascript
const greeting = `Hello, ${name}!`;              // Good
const url = `https://api.example.com/users/${id}`;  // Good
const badGreeting = 'Hello, ' + name + '!';     // Bad
```

## Destructuring

- **DO destructuring in function parameters** - clarifies intent
- **DO NOT destructure unnecessarily** - only what you use
- **DO destructure in loop bodies for complex cases** - improves readability

```javascript
// Good: destructuring in parameters
function renderUser({ name, email, isActive }) {
  if (!isActive) return null;
  return `${name} (${email})`;
}

// Good: in loop body
for (const user of users) {
  const { id, name } = user;
}

// Bad: unnecessary destructuring
const { x } = point;
const { y } = point;  // extract only if needed
```

## Array Operations

- **PREFER array methods** - `map()`, `filter()`, `reduce()` express intent
- **Use for loops only for early exit** with `break`
- **DO NOT use loops for simple transformations**

```javascript
const doubled = numbers.map(n => n * 2);     // Good
const evens = numbers.filter(n => n % 2 === 0);  // Good

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

## Asynchronous Code

- **PREFER `async`/`await`** - reads linearly
- **DO NOT use promise chains**
- **DO NOT silently catch errors** - log or rethrow
- **Only catch errors you can handle** - let others propagate

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
api.getUser(userId).then(user => api.getPosts(user.id).then(posts => ({ user, posts })));

// Bad: silent errors
try { await saveUser(user); } catch (error) { }
```

## TypeScript-Specific

- **AVOID `any` type** - use specific types or `unknown`
- **Use interfaces for object contracts**
- **Annotate function boundaries, not obvious types**
- **DO NOT use wildcard imports** without alias
- **PREFER named exports**

```typescript
// Good: specific type
interface User {
  id: number;
  name: string;
  email: string;
}

function process(data: User): User { return data; }

// Good: annotate boundaries
function calculateTotal(items: CartItem[]): number {
  return items.reduce((sum, item) => sum + item.price, 0);
}

// Bad: any type
function process(data: any) { return data.value; }

// Bad: unnecessary annotations
const count: number = 0;  // number is obvious
const name: string = 'Alice';

// Bad: wildcard without alias
import * from './utils';

// Good: wildcard with alias
import * as utils from './utils';
```

## Anti-Patterns to Avoid

- **Boolean parameters** - create separate functions instead
- **Magic numbers/strings** - extract to named constants
- **Side effects in getters** - use explicit methods
- **Nested conditions** - use early returns and guard clauses

```typescript
// Bad: boolean parameter
function sendNotification(user: User, isEmail: boolean) {
  if (isEmail) sendEmailNotification(user);
  else sendSmsNotification(user);
}

// Good: separate functions
function sendEmailNotification(user: User) { }
function sendSmsNotification(user: User) { }

// Bad: magic number
if (retries > 3) { }

// Good: named constant
const MAX_RETRIES = 3;
if (retries > MAX_RETRIES) { }

// Bad: side effect in getter
get user() {
  analytics.track('accessed');
  return this._user;
}

// Good: explicit method
function getUserWithTracking() {
  analytics.track('accessed');
  return this._user;
}
```

## Quick Reference

- Use `const` by default
- Prefer guard clauses, early returns
- Use template literals, array methods, async/await
- Avoid `any`, `else`, `var`, nested ternaries, boolean parameters
- Annotate function boundaries; let TypeScript infer obvious types
- Extract constants; no magic values
