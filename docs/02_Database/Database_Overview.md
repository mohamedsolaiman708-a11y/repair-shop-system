# Database Overview

## Database Engine

PostgreSQL

Managed by Supabase.

---

# Design Goals

The database should:

- Support multiple branches.
- Scale to thousands of repair orders.
- Prevent duplicated data.
- Preserve repair history.
- Support auditing.
- Be secure using Row Level Security (RLS).
- Support future expansion.

---

# Design Principles

Normalize data where appropriate.

Avoid duplicated information.

Use foreign keys.

Use indexes on searchable columns.

Use UUID as the primary key for all tables.

Store timestamps in UTC.

Never physically delete important business data.

Prefer soft delete when applicable.

---

# Branch Isolation

Every business record belongs to one branch.

Branch operators can only access records belonging to their branch.

Administrators can access all branches.

---

# Auditability

Important operations should remain traceable.

Critical business records should never lose history.

Examples:

- Status changes

- Payments

- Device delivery

- Customer approval

---

# Security

All business tables must use Row Level Security.

Permissions are enforced at the database level.

Never rely only on frontend authorization.