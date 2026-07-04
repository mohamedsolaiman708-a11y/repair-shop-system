# API Conventions

Backend

Supabase

---

Repositories

Repositories are the only layer allowed to communicate with Supabase.

Widgets never access Supabase directly.

---

Error Handling

Convert Supabase exceptions into application failures.

Never expose raw database exceptions to users.

---

Response Handling

Always validate returned data.

Avoid null assumptions.

---

Realtime

Use Supabase Realtime only when required.

Avoid unnecessary subscriptions.

---

Pagination

Use cursor-based pagination whenever large datasets are expected.