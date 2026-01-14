---
name: Screaming Architecture Examples
description: Real-world examples of screaming architecture patterns and folder structures.
---

# Screaming Architecture Examples

---

## Example 1: E-Commerce Application

### Full Project Structure

```
src/
├── features/
│   ├── products/
│   │   ├── product-grid/
│   │   │   ├── product-grid.tsx
│   │   │   ├── product-card.tsx
│   │   │   └── product-grid.test.tsx
│   │   ├── product-details/
│   │   │   ├── product-details.tsx
│   │   │   ├── product-images.tsx
│   │   │   ├── product-reviews.tsx
│   │   │   └── use-product-details.ts
│   │   ├── api/
│   │   │   ├── get-products.ts
│   │   │   ├── get-product-by-id.ts
│   │   │   └── update-product.ts
│   │   ├── types.ts
│   │   └── index.ts
│   │
│   ├── cart/
│   │   ├── cart-sidebar/
│   │   │   ├── cart-sidebar.tsx
│   │   │   └── cart-item.tsx
│   │   ├── cart-provider/
│   │   │   ├── cart-provider.tsx
│   │   │   └── cart-context.ts
│   │   ├── use-cart/
│   │   │   └── use-cart.ts
│   │   ├── api/
│   │   │   ├── add-to-cart.ts
│   │   │   ├── remove-from-cart.ts
│   │   │   └── update-quantity.ts
│   │   ├── types.ts
│   │   └── index.ts
│   │
│   ├── checkout/
│   │   ├── checkout-form/
│   │   │   ├── checkout-form.tsx
│   │   │   ├── shipping-address.tsx
│   │   │   └── payment-method.tsx
│   │   ├── order-confirmation/
│   │   │   └── order-confirmation.tsx
│   │   ├── use-checkout/
│   │   │   └── use-checkout.ts
│   │   ├── api/
│   │   │   └── create-order.ts
│   │   ├── types.ts
│   │   └── index.ts
│   │
│   ├── auth/
│   │   ├── login-form/
│   │   │   └── login-form.tsx
│   │   ├── signup-form/
│   │   │   └── signup-form.tsx
│   │   ├── auth-provider/
│   │   │   ├── auth-provider.tsx
│   │   │   └── auth-context.ts
│   │   ├── use-auth/
│   │   │   └── use-auth.ts
│   │   ├── api/
│   │   │   ├── login.ts
│   │   │   ├── signup.ts
│   │   │   └── logout.ts
│   │   ├── types.ts
│   │   └── index.ts
│   │
│   └── user-profile/
│       ├── profile-header/
│       │   └── profile-header.tsx
│       ├── profile-settings/
│       │   └── profile-settings.tsx
│       ├── order-history/
│       │   ├── order-history.tsx
│       │   └── order-item.tsx
│       ├── api/
│       │   ├── get-profile.ts
│       │   ├── update-profile.ts
│       │   └── get-order-history.ts
│       ├── types.ts
│       └── index.ts
│
├── common/
│   ├── ui/
│   │   ├── button.tsx
│   │   ├── input.tsx
│   │   ├── modal.tsx
│   │   ├── toast.tsx
│   │   └── index.ts
│   ├── hooks/
│   │   ├── use-local-storage.ts
│   │   ├── use-api.ts
│   │   ├── use-form.ts
│   │   └── index.ts
│   ├── utils/
│   │   ├── format-currency.ts
│   │   ├── format-date.ts
│   │   ├── validate-email.ts
│   │   └── index.ts
│   ├── types/
│   │   ├── api.ts
│   │   └── index.ts
│   ├── providers/
│   │   ├── theme-provider.tsx
│   │   └── toast-provider.tsx
│   └── index.ts
│
├── lib/
│   ├── api-client.ts
│   └── auth-service.ts
│
├── config/
│   └── api.ts
│
└── app.tsx
```

### Barrel File Examples

```typescript
// features/products/index.ts
export { ProductGrid } from './product-grid/product-grid';
export { ProductCard } from './product-grid/product-card';
export { ProductDetails } from './product-details/product-details';
export { useProductDetails } from './product-details/use-product-details';
export type { Product, ProductFilters } from './types';

// Usage
import { ProductGrid, useProductDetails, type Product } from 'features/products';
```

```typescript
// features/cart/index.ts
export { CartSidebar } from './cart-sidebar/cart-sidebar';
export { CartProvider } from './cart-provider/cart-provider';
export { useCart } from './use-cart/use-cart';
export type { CartItem, CartContextType } from './types';

// Usage
import { CartProvider, useCart } from 'features/cart';
```

### Feature Type Definition

```typescript
// features/products/types.ts
export interface Product {
  id: string;
  name: string;
  description: string;
  price: number;
  currency: 'USD' | 'EUR';
  images: string[];
  inStock: boolean;
  category: string;
  rating: number;
  reviews: Review[];
}

export interface Review {
  id: string;
  author: string;
  rating: number;
  comment: string;
  date: Date;
}

export interface ProductFilters {
  category?: string;
  priceRange?: [number, number];
  sortBy?: 'price' | 'rating' | 'newest';
}
```

---

## Example 2: SaaS Dashboard Application

### Project Structure

```
src/
├── features/
│   ├── dashboard/
│   │   ├── dashboard-layout/
│   │   │   ├── dashboard-layout.tsx
│   │   │   ├── sidebar.tsx
│   │   │   ├── topbar.tsx
│   │   │   └── dashboard-layout.module.css
│   │   ├── metrics-widget/
│   │   │   ├── metrics-widget.tsx
│   │   │   └── use-metrics.ts
│   │   ├── charts-widget/
│   │   │   ├── charts-widget.tsx
│   │   │   ├── line-chart.tsx
│   │   │   └── bar-chart.tsx
│   │   ├── recent-activity/
│   │   │   ├── recent-activity.tsx
│   │   │   └── activity-item.tsx
│   │   ├── api/
│   │   │   ├── get-metrics.ts
│   │   │   ├── get-charts-data.ts
│   │   │   └── get-activity.ts
│   │   ├── types.ts
│   │   └── index.ts
│   │
│   ├── projects/
│   │   ├── project-list/
│   │   │   ├── project-list.tsx
│   │   │   ├── project-card.tsx
│   │   │   └── project-list.test.tsx
│   │   ├── project-detail/
│   │   │   ├── project-detail.tsx
│   │   │   ├── project-header.tsx
│   │   │   ├── project-members.tsx
│   │   │   └── project-settings.tsx
│   │   ├── create-project-modal/
│   │   │   └── create-project-modal.tsx
│   │   ├── api/
│   │   │   ├── get-projects.ts
│   │   │   ├── get-project-by-id.ts
│   │   │   ├── create-project.ts
│   │   │   └── update-project.ts
│   │   ├── types.ts
│   │   └── index.ts
│   │
│   ├── team-members/
│   │   ├── members-list/
│   │   │   ├── members-list.tsx
│   │   │   └── member-row.tsx
│   │   ├── invite-member-modal/
│   │   │   └── invite-member-modal.tsx
│   │   ├── member-roles/
│   │   │   └── member-roles.tsx
│   │   ├── api/
│   │   │   ├── get-members.ts
│   │   │   ├── invite-member.ts
│   │   │   ├── remove-member.ts
│   │   │   └── update-role.ts
│   │   ├── types.ts
│   │   └── index.ts
│   │
│   ├── notifications/
│   │   ├── notification-bell/
│   │   │   ├── notification-bell.tsx
│   │   │   └── notification-dropdown.tsx
│   │   ├── notification-provider/
│   │   │   ├── notification-provider.tsx
│   │   │   └── notification-context.ts
│   │   ├── use-notifications/
│   │   │   └── use-notifications.ts
│   │   ├── api/
│   │   │   ├── get-notifications.ts
│   │   │   └── mark-as-read.ts
│   │   ├── types.ts
│   │   └── index.ts
│   │
│   └── settings/
│       ├── general-settings/
│       │   └── general-settings.tsx
│       ├── security-settings/
│       │   ├── security-settings.tsx
│       │   └── change-password.tsx
│       ├── integrations/
│       │   ├── integrations.tsx
│       │   └── integration-card.tsx
│       ├── api/
│       │   ├── update-settings.ts
│       │   ├── change-password.ts
│       │   └── manage-integrations.ts
│       ├── types.ts
│       └── index.ts
│
├── common/
│   ├── ui/
│   │   ├── badge.tsx
│   │   ├── dropdown.tsx
│   │   ├── table.tsx
│   │   ├── pagination.tsx
│   │   ├── loading-spinner.tsx
│   │   └── index.ts
│   ├── hooks/
│   │   ├── use-pagination.ts
│   │   ├── use-table-sort.ts
│   │   ├── use-debounce.ts
│   │   └── index.ts
│   ├── utils/
│   │   ├── format-date.ts
│   │   ├── format-number.ts
│   │   ├── truncate-string.ts
│   │   └── index.ts
│   ├── providers/
│   │   ├── theme-provider.tsx
│   │   └── toast-provider.tsx
│   └── index.ts
│
├── lib/
│   ├── api.ts
│   └── auth.ts
│
└── app.tsx
```

### Component Import Examples

```typescript
// ✅ Good: Import from barrel file
import { ProjectList, ProjectDetail } from 'features/projects';
import { MembersList } from 'features/team-members';
import { Button, Dropdown } from 'common/ui';
import { useDebounce } from 'common/hooks';

// ❌ Bad: Import internals directly
import { ProjectCard } from 'features/projects/project-list/project-card';
import Button from 'common/ui/button.tsx';
```

---

## Example 3: Migration from Framework-Based to Feature-Based

### Before (Framework-Based - Anti-Pattern)

```
src/
├── components/
│   ├── Dashboard.tsx
│   ├── ProjectList.tsx
│   ├── ProjectCard.tsx
│   ├── MembersList.tsx
│   ├── MemberRow.tsx
│   └── NotificationBell.tsx
├── hooks/
│   ├── useDashboard.ts
│   ├── useProjects.ts
│   ├── useMembers.ts
│   └── useNotifications.ts
├── pages/
│   ├── dashboard.tsx
│   ├── projects.tsx
│   ├── team.tsx
│   └── settings.tsx
├── api/
│   ├── getDashboard.ts
│   ├── getProjects.ts
│   ├── getMembers.ts
│   └── createProject.ts
├── types/
│   ├── index.ts
│   ├── api.ts
│   ├── dashboard.ts
│   └── projects.ts
└── utils/
    └── format.ts
```

**Problems:**
- Hard to find all dashboard-related code
- Components scattered across folders
- Unclear which hooks belong to which feature
- Difficult to understand business domains

### After (Feature-Based - Screaming Architecture)

```
src/
├── features/
│   ├── dashboard/
│   │   ├── dashboard-layout/
│   │   ├── metrics-widget/
│   │   ├── charts-widget/
│   │   ├── api/
│   │   ├── types.ts
│   │   └── index.ts
│   │
│   ├── projects/
│   │   ├── project-list/
│   │   ├── project-detail/
│   │   ├── create-project-modal/
│   │   ├── api/
│   │   ├── types.ts
│   │   └── index.ts
│   │
│   └── team-members/
│       ├── members-list/
│       ├── invite-member-modal/
│       ├── api/
│       ├── types.ts
│       └── index.ts
│
├── common/
│   ├── ui/
│   ├── hooks/
│   ├── utils/
│   └── types/
│
└── app.tsx
```

**Benefits:**
- All dashboard code in one place
- Clear feature boundaries
- Easy onboarding: "Look at features/ to understand domains"
- Simple to scale: Add new feature folder

---

## Example 4: Feature with Complex State Management

### Using Context Provider Pattern

```
features/todos/
├── add-todo-form/
│   ├── add-todo-form.tsx
│   ├── add-todo-form.test.tsx
│   └── use-add-todo.ts
├── todo-list/
│   ├── todo-list.tsx
│   ├── todo-item.tsx
│   └── use-todo-filters.ts
├── todo-provider/
│   ├── todo-provider.tsx
│   ├── todo-context.ts
│   └── todo-reducer.ts
├── use-todo/
│   └── use-todo.ts
├── api/
│   ├── get-todos.ts
│   ├── create-todo.ts
│   ├── update-todo.ts
│   └── delete-todo.ts
├── types.ts
├── index.ts
└── README.md
```

### Code Structure

```typescript
// features/todos/todo-context.ts
import React from 'react';
import type { Todo, TodoContextType } from './types';

export const TodoContext = React.createContext<TodoContextType | null>(null);

// features/todos/todo-provider/todo-provider.tsx
import { TodoContext } from '../todo-context';
import { useTodoReducer } from './todo-reducer';

export function TodoProvider({ children }: { children: React.ReactNode }) {
  const [state, dispatch] = useTodoReducer();

  return (
    <TodoContext.Provider value={{ todos: state.todos, dispatch }}>
      {children}
    </TodoContext.Provider>
  );
}

// features/todos/use-todo/use-todo.ts
import { useContext } from 'react';
import { TodoContext } from '../todo-context';

export function useTodo() {
  const context = useContext(TodoContext);
  if (!context) {
    throw new Error('useTodo must be used within TodoProvider');
  }
  return context;
}

// features/todos/index.ts
export { TodoProvider } from './todo-provider/todo-provider';
export { useTodo } from './use-todo/use-todo';
export type { Todo, TodoContextType } from './types';
```

### Usage in Other Features

```typescript
// features/dashboard/dashboard-layout.tsx
import { TodoProvider } from 'features/todos';

export function DashboardLayout() {
  return (
    <TodoProvider>
      <Dashboard />
    </TodoProvider>
  );
}
```

---

## Key Takeaways

1. **Everything for a feature lives in one folder** - No hunting through `components/`, `hooks/`, `api/`
2. **Barrel files are the public API** - Other features see only exported contracts
3. **Naming clearly states purpose** - `add-todo-form` not `form`, `use-todos` not `hook`
4. **Shared is for truly generic code** - Not every utility goes there
5. **The folder tree tells the story** - New developers see business domains immediately
