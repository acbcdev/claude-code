---
name: Screaming Architecture for Next.js
description: Feature-based organization patterns for Next.js applications.
---

# Screaming Architecture for Next.js

## Next.js Project Structure

```
my-app/
├── src/
│   ├── app/                    # Next.js App Router
│   │   ├── layout.tsx          # Root layout
│   │   ├── page.tsx            # Home page
│   │   ├── dashboard/
│   │   │   ├── layout.tsx      # Dashboard layout
│   │   │   ├── page.tsx        # Dashboard page (route)
│   │   │   ├── projects/
│   │   │   │   └── page.tsx    # Projects page
│   │   │   └── settings/
│   │   │       └── page.tsx    # Settings page
│   │   └── api/                # API routes
│   │       ├── auth/
│   │       │   ├── login/
│   │       │   │   └── route.ts
│   │       │   └── logout/
│   │       │       └── route.ts
│   │       └── todos/
│   │           ├── route.ts
│   │           └── [id]/
│   │               └── route.ts
│   │
│   ├── features/                # Feature modules
│   │   ├── todos/
│   │   ├── dashboard/
│   │   ├── auth/
│   │   └── projects/
│   │
│   ├── common/
│   │   ├── ui/
│   │   ├── hooks/
│   │   ├── utils/
│   │   └── types/
│   │
│   └── lib/
│       ├── db.ts              # Database client
│       ├── auth.ts            # Auth utilities
│       └── api.ts             # API client
│
├── prisma/                     # Database (if using Prisma)
│   └── schema.prisma
│
└── package.json
```

---

## App Router Integration

### Page Routes with Features

```
app/
├── dashboard/
│   ├── layout.tsx
│   └── page.tsx               # Imports from features/dashboard
├── todos/
│   ├── layout.tsx
│   └── page.tsx               # Imports from features/todos
└── api/
    ├── todos/
    │   ├── route.ts           # API logic imported from features
    │   └── [id]/
    │       └── route.ts
```

### Dashboard Page Example

```typescript
// app/dashboard/page.tsx
import { DashboardLayout } from 'features/dashboard/dashboard-layout';
import { MetricsWidget } from 'features/dashboard/metrics-widget';
import { ChartsWidget } from 'features/dashboard/charts-widget';

export default async function DashboardPage() {
  return (
    <DashboardLayout>
      <MetricsWidget />
      <ChartsWidget />
    </DashboardLayout>
  );
}
```

### API Route Integration

```typescript
// app/api/todos/route.ts
import { getTodos, createTodo } from 'features/todos/api';

export async function GET(request: Request) {
  try {
    const todos = await getTodos();
    return Response.json(todos);
  } catch (error) {
    return Response.json({ error: 'Failed to fetch todos' }, { status: 500 });
  }
}

export async function POST(request: Request) {
  try {
    const data = await request.json();
    const todo = await createTodo(data);
    return Response.json(todo, { status: 201 });
  } catch (error) {
    return Response.json({ error: 'Failed to create todo' }, { status: 400 });
  }
}
```

---

## Server vs Client Components

### Feature Structure with Server/Client Split

```
features/todos/
├── add-todo-form/
│   ├── add-todo-form.tsx         # Client component (interactive)
│   └── add-todo-form.test.tsx
│
├── todo-list/
│   ├── todo-list.tsx             # Server component (data fetching)
│   ├── todo-item.tsx             # Client component (interactive)
│   └── todo-filters.tsx          # Client component
│
├── api/
│   ├── get-todos.ts              # Server action or API utility
│   ├── create-todo.ts
│   └── delete-todo.ts
│
├── types.ts
└── index.ts
```

### Server Component Pattern

```typescript
// features/todos/todo-list/todo-list.tsx
// This is a server component - fetches data directly
import { getTodos } from '../api/get-todos';
import { TodoItem } from './todo-item';

export async function TodoList() {
  const todos = await getTodos();

  return (
    <ul>
      {todos.map((todo) => (
        <TodoItem key={todo.id} todo={todo} />
      ))}
    </ul>
  );
}
```

### Client Component Pattern

```typescript
// features/todos/add-todo-form/add-todo-form.tsx
'use client';

import { createTodo } from '../api/create-todo';
import { useState } from 'react';

export function AddTodoForm() {
  const [title, setTitle] = useState('');

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    await createTodo(title);
    setTitle('');
  };

  return (
    <form onSubmit={handleSubmit}>
      <input
        value={title}
        onChange={(e) => setTitle(e.target.value)}
        placeholder="Add todo..."
      />
      <button type="submit">Add</button>
    </form>
  );
}
```

---

## Server Actions in Features

### Feature with Server Actions

```
features/todos/
├── add-todo-form/
│   ├── add-todo-form.tsx
│   ├── add-todo.action.ts       # Server action
│   └── add-todo-form.test.tsx
│
├── todo-item/
│   ├── todo-item.tsx
│   ├── delete-todo.action.ts    # Server action
│   └── toggle-todo.action.ts
│
├── types.ts
└── index.ts
```

### Server Action Implementation

```typescript
// features/todos/add-todo-form/add-todo.action.ts
'use server';

import { db } from 'lib/db';
import type { Todo } from '../types';

export async function addTodo(title: string): Promise<Todo> {
  if (!title.trim()) {
    throw new Error('Title is required');
  }

  const todo = await db.todo.create({
    data: { title },
  });

  return todo;
}
```

### Using Server Actions in Client Components

```typescript
// features/todos/add-todo-form/add-todo-form.tsx
'use client';

import { addTodo } from './add-todo.action';
import { useTransition } from 'react';

export function AddTodoForm() {
  const [isPending, startTransition] = useTransition();
  const [title, setTitle] = useState('');

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    startTransition(async () => {
      await addTodo(title);
      setTitle('');
    });
  };

  return (
    <form onSubmit={handleSubmit}>
      <input
        value={title}
        onChange={(e) => setTitle(e.target.value)}
        disabled={isPending}
      />
      <button disabled={isPending}>
        {isPending ? 'Adding...' : 'Add'}
      </button>
    </form>
  );
}
```

---

## Database Models Integration

### Prisma Schema

```prisma
// prisma/schema.prisma
model Todo {
  id        String    @id @default(cuid())
  title     String
  completed Boolean   @default(false)
  userId    String
  user      User      @relation(fields: [userId], references: [id])
  createdAt DateTime  @default(now())
  updatedAt DateTime  @updatedAt

  @@map("todos")
}

model User {
  id    String     @id @default(cuid())
  email String     @unique
  name  String?
  todos Todo[]
}
```

### Feature Database Utilities

```
features/todos/
├── api/
│   ├── get-todos.ts
│   │   └── Uses: db.todo.findMany()
│   ├── create-todo.ts
│   │   └── Uses: db.todo.create()
│   └── delete-todo.ts
│       └── Uses: db.todo.delete()
├── types.ts
└── index.ts
```

### Implementation

```typescript
// features/todos/api/get-todos.ts
import { db } from 'lib/db';
import type { Todo } from '../types';

export async function getTodos(userId: string): Promise<Todo[]> {
  return db.todo.findMany({
    where: { userId },
    orderBy: { createdAt: 'desc' },
  });
}
```

---

## Middleware Integration

### Feature-Scoped Middleware

```
features/auth/
├── middleware.ts                # Auth-specific logic
├── use-auth/
├── types.ts
└── index.ts
```

### Middleware Implementation

```typescript
// middleware.ts (root level)
import { type NextRequest, NextResponse } from 'next/server';
import { verifyAuth } from 'features/auth/middleware';

export function middleware(request: NextRequest) {
  const { pathname } = request.nextUrl;

  // Protect dashboard routes
  if (pathname.startsWith('/dashboard')) {
    const isAuthed = verifyAuth(request);
    if (!isAuthed) {
      return NextResponse.redirect(new URL('/login', request.url));
    }
  }

  return NextResponse.next();
}

export const config = {
  matcher: ['/dashboard/:path*'],
};
```

---

## Environment Variables

### .env.local Structure

```bash
# Database
DATABASE_URL="postgresql://..."

# API
NEXT_PUBLIC_API_URL="http://localhost:3000/api"
API_SECRET_KEY="..."

# Auth
AUTH_SECRET="..."

# Feature-specific
TODOS_API_ENDPOINT="..."
```

### Usage in Features

```typescript
// lib/config.ts
export const config = {
  apiUrl: process.env.NEXT_PUBLIC_API_URL,
  authSecret: process.env.AUTH_SECRET,
};

// features/todos/api/get-todos.ts
import { config } from 'lib/config';

export async function getTodos() {
  const response = await fetch(`${config.apiUrl}/todos`);
  // ...
}
```

---

## Testing Features

### Feature-Level Tests

```
features/todos/
├── add-todo-form/
│   ├── add-todo-form.tsx
│   ├── add-todo-form.test.tsx   # Component tests
│   └── add-todo.action.test.ts  # Server action tests
│
├── api/
│   ├── get-todos.ts
│   └── get-todos.test.ts        # API tests
│
└── types.ts
```

### Component Test Example

```typescript
// features/todos/add-todo-form/add-todo-form.test.tsx
import { render, screen, fireEvent } from '@testing-library/react';
import { AddTodoForm } from './add-todo-form';

describe('AddTodoForm', () => {
  it('submits form with title', async () => {
    render(<AddTodoForm />);
    const input = screen.getByPlaceholderText('Add todo...');
    const button = screen.getByText('Add');

    fireEvent.change(input, { target: { value: 'Test todo' } });
    fireEvent.click(button);

    // Assert
  });
});
```

### Server Action Test Example

```typescript
// features/todos/add-todo-form/add-todo.action.test.ts
import { addTodo } from './add-todo.action';

describe('addTodo', () => {
  it('creates a todo with valid title', async () => {
    const result = await addTodo('Test todo');
    expect(result.id).toBeDefined();
    expect(result.title).toBe('Test todo');
  });

  it('throws error for empty title', async () => {
    await expect(addTodo('')).rejects.toThrow('Title is required');
  });
});
```

---

## Export Organization

### Barrel Files

```typescript
// features/todos/index.ts
// Client Components
export { AddTodoForm } from './add-todo-form/add-todo-form';
export { TodoList } from './todo-list/todo-list';
export { TodoItem } from './todo-item/todo-item';

// Server Actions
export { addTodo } from './add-todo-form/add-todo.action';
export { deleteTodo } from './todo-item/delete-todo.action';

// Hooks
export { useTodoFilters } from './todo-list/use-todo-filters';

// Types
export type { Todo, TodoFilters } from './types';
```

### Usage

```typescript
// app/dashboard/page.tsx
import {
  AddTodoForm,
  TodoList,
  type Todo,
} from 'features/todos';

export default function TodosPage() {
  return (
    <>
      <h1>Todos</h1>
      <AddTodoForm />
      <TodoList />
    </>
  );
}
```

### Common UI Imports

```typescript
// Example: Using common UI components
import { Button, Input, Modal } from 'common/ui';
import { useDebounce } from 'common/hooks';
```

---

## Best Practices for Next.js

1. **Keep features independent** - No feature-to-feature imports except through barrel files
2. **Server components by default** - Use client components only where needed
3. **Colocate server actions** - Keep `.action.ts` files with components that use them
4. **Database access in features** - API utilities in each feature handle their own data
5. **Use common for UI only** - Buttons, inputs, layouts (no business logic)
6. **Environment variables centralized** - Avoid `.env` sprawl in features
7. **API routes as thin adapters** - Route handlers delegate to feature functions

---

## Quick Reference

- **App Router**: Route components live in `app/`, import features
- **Server Actions**: Keep in feature folders as `.action.ts` files
- **Database**: Feature-scoped utility files handle queries
- **API Routes**: Delegate to feature functions
- **Exports**: Use barrel files for clean imports
- **Tests**: Colocate with feature code
- **Common**: Only for generic UI, hooks, and utilities
