# .gitignore lines

Append these lines to `.gitignore` (create the file if missing). Never rewrite or reorder existing lines; add only the lines that are not already present, and show the user which ones will be added in the file-list approval step.

```
# Daily work history log (local only)
docs/history/*
!docs/history/.gitkeep

# OS
.DS_Store

# Env
.env
.env.local
*.local
```

Also create an empty `docs/history/.gitkeep`.
