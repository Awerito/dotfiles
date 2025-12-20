## Development Environment
- **OS**: Pop!_OS (Linux)
- **Terminal**: Kitty
- **Editor**: Neovim (nvim)

## Programming Preferences
- Write all code in English
- Write all code comments in English
- Only use Spanish if explicitly requested otherwise

## Code Formatting
- **CRITICAL**: Write code ALREADY FORMATTED as the formatter would output it
- **CRITICAL**: The goal is that when the user opens a file in nvim, conform.nvim does NOT make any changes
- **Python**: Format with `black` (line length 88, default settings)
- **JavaScript/TypeScript** (`.js`, `.jsx`, `.ts`, `.tsx`): Format with `prettier`
  - Use double quotes `"`, not single quotes `'`
  - Always include semicolons
  - Break long lines as prettier would
- **HTML/CSS/JSON/YAML**: Format with `prettier`
  - Break long attributes onto multiple lines as prettier does
- Ensure consistent indentation and spacing in all generated code
- NEVER write code that will be reformatted when opened - get it right the first time

## Tool and Package Installation Guidelines
- **CRITICAL**: Always check official documentation before suggesting commands or configurations
- **CRITICAL**: Verify current versions and avoid deprecated features/functions
- Never assume knowledge is up-to-date without verification
- When suggesting any tool, library, or command:
  1. First search for or reference official documentation
  2. Verify the syntax and features are current
  3. Warn if there are known breaking changes from older versions

## Behavior Rules
- Prioritize official docs over assumptions
- Be explicit about version-specific commands
- Warn about deprecated features proactively
- When in doubt about a tool's current state, search the official documentation first

## File Exploration Efficiency
- **CRITICAL**: Use `tree` instead of multiple `ls` commands to explore directory structures
- `tree -L 2` or `tree -L 3` gives a complete view in one command, saving tokens
- Avoid patterns like `ls -laR ... 2>/dev/null || echo "..."` - use `tree` instead
- Only use `ls -la` for a single specific directory when you need file details (permissions, sizes)

## Temporary/Exploratory Scripts
- **CRITICAL**: Scripts created for exploration, debugging, or testing that won't be part of the final solution MUST go in `./sanity/` at the project root
- Never leave temporary scripts mixed with production code in module directories
- Examples of what goes in `sanity/`:
  - `explore_*.py` - Scripts to understand data structures
  - `test_*.py` - One-off test scripts (not pytest tests)
  - `debug_*.py` - Debugging scripts
  - Any script that "worked but won't be integrated"
- Always ensure `sanity/` is in `.gitignore`

## Implementation Confirmation Rules
- **CRITICAL**: NEVER implement, export, or execute ANY code without explicit user confirmation first
- **CRITICAL**: ALWAYS show detailed plans, column lists, and structure BEFORE writing/running code
- **CRITICAL**: WAIT for explicit user approval with "sí", "dale", "ok", or similar confirmation
- When working on data processing, exports, or transformations:
  1. **EXPLORE FIRST**: Read actual data structure from source (MongoDB, files, etc.)
  2. **SHOW STRUCTURE**: Display all keys, fields, and data types found
  3. **PROPOSE PLAN**: List exactly what will go in each output (columns, files, etc.)
  4. **WAIT**: Stop and ask "¿Está correcto? ¿Procedo?"
  5. **ONLY AFTER CONFIRMATION**: Write and execute implementation code
- Never assume the user wants you to proceed immediately
- Never batch multiple steps without intermediate confirmations
- If you catch yourself about to implement something: STOP and confirm first

## Example Workflow
When asked about installing or configuring something:
1. Identify the tool/package
2. Check official documentation for current installation method
3. Provide Pop!_OS/Debian-specific commands when applicable
4. Mention if Kitty terminal has specific configuration needs
5. Include nvim integration tips if relevant
6. Ensure all suggestions use current, non-deprecated approaches

---

**Quick Reminder**: Always verify with official docs before suggesting commands or features to avoid deprecated or outdated information.
