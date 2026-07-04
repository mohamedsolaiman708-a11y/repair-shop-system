# Device Statuses

## Purpose

This document defines all valid repair order statuses and the allowed transitions between them.

The repair order must always have exactly one active status.

---

## 1. Registered

Description

The repair order has been created successfully.

Allowed Next Status

- Under Inspection

---

## 2. Under Inspection

Description

The technician is diagnosing the device.

Allowed Next Status

- Waiting Customer Approval
- Repair In Progress
- Not Repairable

---

## 3. Waiting Customer Approval

Description

Customer approval is required before continuing.

Allowed Next Status

- Repair In Progress
- Cancelled

---

## 4. Repair In Progress

Description

The repair work has started.

Allowed Next Status

- Waiting Parts
- Ready For Pickup
- Not Repairable

---

## 5. Waiting Parts

Description

Repair cannot continue until required parts arrive.

Allowed Next Status

- Repair In Progress

---

## 6. Ready For Pickup

Description

Repair completed.

Customer has been notified.

Allowed Next Status

- Delivered

---

## 7. Delivered

Description

Customer received the device.

Repair order closed.

No further transitions allowed.

---

## 8. Cancelled

Description

Repair cancelled by customer.

Repair order closed.

---

## 9. Not Repairable

Description

Device cannot be repaired.

Allowed Next Status

- Delivered