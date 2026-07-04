# Project Rules

## Documentation First

Always read the relevant documentation before implementing any feature.

---

## Feature Development Flow

Understand the requirement.

Review related documentation.

Review existing implementation.

Design the solution.

Implement.

Review.

Refactor if necessary.

---

## File Organization

Keep files focused.

Avoid large files.

Prefer reusable components.

---

## Naming

Use meaningful names.

Avoid abbreviations unless universally understood.

---

## Database

Never modify database structure without understanding existing relationships.

Prefer migrations over manual changes.

---

## UI

The operator performs repetitive tasks.

Every screen should reduce typing.

Every workflow should reduce clicks.

Speed is more important than visual complexity.

---

## Business Logic

Business logic belongs inside the Domain layer.

Never place business logic inside Widgets.

---

## State Management

State should be predictable.

Avoid unnecessary global state.

---

## Services

Services should have one responsibility.

Avoid large service classes.

---

## Testing Mindset

Every implementation should be written as if it will be tested later.

Avoid tightly coupled code.

---

## Maintainability

Assume another engineer will maintain this project.

Write code that is easy to understand.