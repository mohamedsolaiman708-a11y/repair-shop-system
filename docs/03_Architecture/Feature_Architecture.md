# Feature Architecture

Every feature is completely isolated.

Example:

devices/

data/

domain/

presentation/

Each feature owns:

Business Logic

Repository

State

Widgets

Models

---

Features communicate only through interfaces.

Never directly access another feature's internal implementation.

---

Business logic belongs inside Domain.

UI belongs inside Presentation.

Database access belongs inside Data.