# Database Tables

## branches

Purpose

Stores all company branches.

---

Fields

id

name

phone

address

is_active

created_at

updated_at

---

## users

Purpose

Stores authenticated users.

Administrator.

Branch Operators.

---

Fields

id

branch_id

full_name

email

phone

role

is_active

created_at

updated_at

---

## technicians

Purpose

Stores technicians for each branch.

Technicians do not authenticate.

---

Fields

id

branch_id

name

phone

specialization

is_active

created_at

updated_at

---

## customers

Purpose

Stores customer information.

---

Fields

id

branch_id

name

phone

alternate_phone

address

notes

created_at

updated_at

---

## devices

Purpose

Stores customer devices.

A device may have multiple repair orders.

---

Fields

id

customer_id

device_type

brand

model

serial_number

color

notes

created_at

updated_at

---

## repair_orders

Purpose

Main business table.

Every repair request is stored here.

---

Fields

id

branch_id

device_id

technician_id

repair_number

barcode

status

problem_description

inspection_notes

repair_notes

estimated_cost

final_cost

deposit

delivery_date

completed_at

delivered_at

created_by

created_at

updated_at

---

## repair_status_history

Purpose

Stores every status change.

---

Fields

id

repair_order_id

old_status

new_status

changed_by

changed_at

notes

---

## payments

Purpose

Stores all payments.

---

Fields

id

repair_order_id

amount

payment_method

payment_type

notes

created_by

created_at

---

## whatsapp_logs

Purpose

Stores WhatsApp messages.

---

Fields

id

repair_order_id

template_name

phone

status

response

sent_at

---

## settings

Purpose

Stores configurable system settings.

Examples:

Pickup reminder days.

WhatsApp templates.

Barcode settings.

Receipt settings.