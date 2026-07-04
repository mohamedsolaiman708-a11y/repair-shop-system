# Project Structure

## Architecture

The project follows:

- Clean Architecture
- Feature First Architecture

The application is organized around business features rather than technical layers.

---

## Main Folder Structure

lib/

core/

features/

shared/

services/

routes/

main.dart

---

## Feature Structure

Each feature contains:

data/

domain/

presentation/

---

## Data Layer

Contains:

Models

Repositories

Remote Data Sources

Local Data Sources (Future)

---

## Domain Layer

Contains:

Entities

Repository Contracts

Use Cases

Business Logic

---

## Presentation Layer

Contains:

Screens

Widgets

Providers

State

Navigation

---

## Core

Contains shared infrastructure.

Examples:

Theme

Constants

Errors

Extensions

Helpers

Validators

Utilities

Network

Logger

---

## Shared

Contains reusable UI components.

Examples:

Buttons

Dialogs

Inputs

Tables

Loading Widgets

Cards