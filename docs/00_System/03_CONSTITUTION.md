# Engineering Constitution

## Purpose

This document defines the non-negotiable engineering rules for this project.

Every implementation must follow these principles.

If any generated code violates these rules, the implementation is considered incorrect.

---

# Rule 1 — Documentation First

Documentation is the single source of truth.

Never implement features that are not described in the project documentation.

If documentation and code conflict, documentation wins.

---

# Rule 2 — Understand Before Coding

Never start writing code immediately.

Always understand:

- Business purpose
- User workflow
- Existing architecture
- Existing database structure
- User roles
- Business rules

Think before implementing.

---

# Rule 3 — Never Guess

If any requirement is unclear:

Stop.

Explain the ambiguity.

Ask for clarification.

Never invent business logic.

---

# Rule 4 — Keep It Simple

Always choose the simplest solution that satisfies the business requirements.

Avoid unnecessary abstractions.

Avoid overengineering.

---

# Rule 5 — Reuse Before Creating

Before creating:

- Widget
- Service
- Repository
- Utility
- Extension
- Model

Always check whether one already exists.

Avoid duplication.

---

# Rule 6 — Production Quality

Every generated code must be:

- Production Ready
- Readable
- Maintainable
- Modular
- Testable
- Secure

Never generate demo code.

Never generate temporary implementations.

Never leave TODOs.

---

# Rule 7 — Strong Typing

Always use proper Dart types.

Avoid using dynamic unless absolutely necessary.

Use immutable models whenever possible.

---

# Rule 8 — Feature Isolation

Each feature owns its own:

- UI
- State
- Business Logic
- Repository
- Models

Features should communicate through clean interfaces.

Avoid tight coupling.

---

# Rule 9 — Performance Matters

Avoid unnecessary rebuilds.

Avoid duplicated database requests.

Cache when appropriate.

Load only required data.

---

# Rule 10 — Security First

Never expose secrets.

Never bypass authorization.

Always validate user permissions.

Respect Row Level Security (RLS).

---

# Rule 11 — Database Integrity

Never modify the database without considering:

- Existing relationships
- Foreign keys
- Indexes
- Performance
- Security

---

# Rule 12 — Small Components

Large files are difficult to maintain.

Prefer small reusable widgets.

Avoid widgets larger than 300 lines whenever possible.

---

# Rule 13 — Error Handling

Never ignore exceptions.

Always handle failures gracefully.

Provide meaningful error messages.

Log important failures.

---

# Rule 14 — User Experience

Every screen should prioritize:

- Speed
- Simplicity
- Clarity

The operator should complete common tasks with the fewest possible clicks.

---

# Rule 15 — Future Scalability

Every implementation should consider future expansion.

Avoid decisions that make future development difficult.

---

# Final Principle

Write software that another senior engineer can easily understand six months later.