# Database Relationships

## Overview

The database is relational.

All relationships must be enforced using Foreign Keys.

---

# Branch

Branch

↓

Users

Technicians

Customers

Repair Orders

---

# Customer

Customer

↓

Devices

---

# Device

Device

↓

Repair Orders

---

# Technician

Technician

↓

Repair Orders

---

# Repair Order

Repair Order

↓

Status History

Payments

WhatsApp Logs

Attachments (Future)

---

# User

User

↓

Created Repair Orders

Status Changes

Payments

---

# Status

Repair Status

↓

Repair Orders

↓

Status History

---

# Rules

Deleting parent records is restricted.

Historical business records must remain intact.

Relationships should preserve data integrity.