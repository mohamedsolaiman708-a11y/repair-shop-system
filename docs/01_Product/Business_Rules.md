# Business Rules

## Branches

Every repair order belongs to exactly one branch.

---

## Operators

Every repair order is created by one branch operator.

---

## Technicians

Technicians are assigned by the operator.

Technicians never log into the system.

---

## Customers

A customer may own multiple devices.

---

## Devices

Every repair order belongs to one device.

A device may have multiple repair orders over time.

---

## Barcode

Every repair order has a unique barcode.

Barcode values cannot be duplicated.

---

## Repair Number

Every repair order has a unique repair number.

Repair numbers are generated automatically.

---

## Status

Every repair order always has one active status.

---

## WhatsApp

Notifications are sent automatically based on status changes.

---

## Payments

A repair order may contain:

No payment.

Deposit.

Partial payment.

Full payment.

---

## Reports

Reports must use real-time data whenever possible.

---

## Audit

Important actions should be recorded for auditing.

Examples:

Status changed.

Repair assigned.

Payment received.

Device delivered.