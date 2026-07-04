# Coding Guidelines

Always follow Clean Architecture.

Never place business logic inside Widgets.

Repositories are the only layer allowed to communicate with Supabase.

Always separate:

Entity

Model

DTO

Never access Supabase directly from UI.

Prefer immutable models.

Use const constructors whenever possible.

Keep widgets small.

Split files larger than 300 lines.

Always validate user input.

Always handle loading state.

Always handle empty state.

Always handle error state.

Write readable code before clever code.