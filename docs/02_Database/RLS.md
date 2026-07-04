# Row Level Security

## Overview

All business tables must use Row Level Security.

Authorization is enforced by PostgreSQL.

---

## Administrator

Can access all branches.

---

## Branch Operator

Can only access:

Own Branch

Own Customers

Own Devices

Own Repair Orders

Own Technicians

Own Reports

---

## Tables Protected

branches

users

technicians

customers

devices

repair_orders

payments

status_history

whatsapp_logs

---

## Principle

Never trust the frontend.

Security belongs to the database.