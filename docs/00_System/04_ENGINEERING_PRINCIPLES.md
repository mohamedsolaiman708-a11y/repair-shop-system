# Engineering Principles

## Clean Architecture

The application follows Clean Architecture.

Layers:

- Presentation
- Domain
- Data

Dependencies always point inward.

---

## Feature First

The project is organized by features.

Each feature contains:

- Data
- Domain
- Presentation

Avoid organizing by file type across the entire project.

---

## SOLID

Follow all SOLID principles.

Prefer composition over inheritance.

---

## DRY

Don't Repeat Yourself.

Extract reusable logic.

---

## KISS

Keep implementations simple.

Avoid unnecessary complexity.

---

## YAGNI

Don't build features before they are needed.

Implement only current business requirements.

---

## Single Responsibility

Every class should have one responsibility.

Every widget should have one purpose.

---

## Separation of Concerns

Keep:

UI

Business Logic

Data Access

Independent.

---

## Dependency Injection

Dependencies should be injected.

Avoid creating services directly inside widgets.

---

## Immutability

Prefer immutable objects.

Use copyWith patterns when updating state.

---

## Readability

Readable code is more valuable than clever code.

Always prioritize clarity.