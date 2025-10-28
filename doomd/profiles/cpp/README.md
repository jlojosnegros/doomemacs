# C++ Development Profile - Configuration Guide

## Overview

This profile is configured for C++ development with special support for large codebases using **Bazel** build system and **compile_commands.json** for LSP integration.

## Features

### Core Capabilities
- ✅ **Semantic navigation** via clangd LSP server
- ✅ **Intelligent autocompletion** based on actual build configuration
- ✅ **compile_commands.json** auto-discovery
- ✅ **Bazel** build system support
- ✅ **Protobuf** (.proto files) syntax highlighting
- ✅ **C++20** standard support
- ✅ **clang-format** integration

### Optimizations for Large Projects
- Background indexing for fast symbol lookup
- Lazy connection to LSP server
- Disabled file watchers for better performance
- Memory-based PCH storage
- Limited result sets to prevent slowdowns

## Configuration

### LSP Server: clangd

The profile uses **eglot** (Emacs built-in LSP client) with **clangd**. Configuration includes:

```elisp
;; clangd arguments (automatically configured)
"--background-index"           ; Index project in background
"--clang-tidy"                ; Enable clang-tidy checks
"--completion-style=detailed" ; Better completion
"--compile-commands-dir=."    ; Auto-discover compile_commands.json
"--pch-storage=memory"        ; Faster PCH access
"--all-scopes-completion"     ; Complete from all scopes
"--function-arg-placeholders" ; Show function arguments
```

### Project Detection

Projects are detected by the presence of:
- `compile_commands.json` (highest priority)
- `WORKSPACE` (Bazel workspace)
- `.bazelversion`
- `.git`
- `BUILD` files

## Working with Envoy (or similar Bazel projects)

### Initial Setup

1. **Generate compile_commands.json**:
   ```bash
   cd /path/to/envoy
   ./ci/run_envoy_docker.sh './ci/do_ci.sh refresh_compdb'
   ```

   This takes 30-60 minutes on first run but only needs to be done:
   - After cloning the project
   - When changing BUILD files
   - When modifying protobuf definitions
   - When adding/removing dependencies

2. **Open Emacs with C++ profile**:
   ```bash
   emacs --profile cpp /path/to/envoy/source/some_file.cc
   ```

3. **Eglot auto-starts**: If `.dir-locals.el` is configured (see below), eglot will automatically start when opening C++ files.

### Project-Specific Configuration (.dir-locals.el)

A `.dir-locals.el` file has been created for Envoy at:
```
/home/jojosneg/source/redhat/envoy/upstream/main/.dir-locals.el
```

This configures:
- **C++20** as the language standard
- **2-space indentation** (Google style)
- **Auto-start eglot** when opening C++ files
- **Compile command** for the project

To create similar configuration for other projects, copy and adapt this file.

### Keybindings

All keybindings use the **local leader** key (default: `C-c` for non-evil users).

#### LSP Navigation
- `C-c l d` - Find definition
- `C-c l r` - Find references
- `C-c l R` - Rename symbol
- `C-c l a` - Code actions
- `C-c l f` - Format buffer (LSP)
- `C-c l s` - Restart LSP server

#### Build & Compilation
- `C-c c` - Compile project
- `C-c r` - Recompile
- `C-c f` - Format buffer (clang-format)
- `C-c F` - Format region (clang-format)

#### Project-Specific (Envoy)
- `C-c p c` - Refresh compile_commands.json (regenerate compilation database)
- `C-c p f` - Find and open compile_commands.json

#### General Navigation (built-in)
- `M-.` - Go to definition (xref)
- `M-,` - Go back
- `M-?` - Find references

### Workflow Example

1. **Open a file**:
   ```bash
   emacs --profile cpp ~/source/redhat/envoy/upstream/main/source/common/http/http2/codec_impl.cc
   ```

2. **Wait for eglot to connect** (you'll see "Connected to clangd" in the modeline)

3. **Navigate**:
   - Place cursor on a symbol
   - Press `M-.` to jump to definition
   - Press `C-c l r` to find all references

4. **Edit and format**:
   - Make changes
   - Press `C-c f` to format the current buffer
   - Or enable format-on-save (uncomment in `init.el`)

5. **If navigation doesn't work**:
   - Check if `compile_commands.json` exists: `C-c p f`
   - Restart LSP server: `C-c l s`
   - Regenerate compilation database: `C-c p c`

## Troubleshooting

### Eglot doesn't start automatically

**Solution**: Make sure `.dir-locals.el` exists and contains:
```elisp
(c++-mode . ((eval . (add-hook 'c++-mode-hook #'eglot-ensure nil t))))
```

Or manually start eglot with `M-x eglot`.

### "Cannot find symbol" or navigation doesn't work

**Cause**: compile_commands.json is missing or outdated.

**Solution**:
1. Verify it exists: `C-c p f`
2. If missing, regenerate: `C-c p c` (or run the refresh command manually)
3. Restart eglot: `C-c l s`

### Eglot is slow or freezes

**Cause**: Large project index, or clangd is still building the index.

**Solution**:
1. Wait for background indexing to complete (check \*eglot events\* buffer)
2. Close unnecessary buffers: `C-x k`
3. Restart eglot: `C-c l s`
4. Disable file watchers (already done in this profile)

### Wrong clangd version

**Cause**: System clangd is outdated.

**Solution**: Install or specify a newer clangd:
```elisp
;; In your .dir-locals.el or config.el
(setq-local eglot-server-programs
            '((c++-mode c-mode) . ("/opt/llvm/bin/clangd" ...args...)))
```

### Completion doesn't show protobuf generated code

**Cause**: compile_commands.json doesn't include generated files.

**Solution**: Regenerate compile_commands.json:
```bash
./ci/run_envoy_docker.sh './ci/do_ci.sh refresh_compdb'
```

This includes generated protobuf headers in the compilation database.

## Performance Tips

### For Very Large Projects (like Envoy)

1. **Disable auto-format on save** (keep manual formatting):
   ```elisp
   ;; Keep this commented in init.el:
   ;; (format +onsave)
   ```

2. **Use eglot selectively**: Only start eglot when needed, not auto-start.
   Comment out the auto-start hook in `.dir-locals.el`.

3. **Limit indexed directories**: Create a `.clangd` config file in project root:
   ```yaml
   # .clangd
   CompileFlags:
     CompilationDatabase: .

   Index:
     Background: Build

   # Exclude test directories if not needed
   If:
     PathMatch: test/.*
   Index:
     Background: Skip
   ```

4. **Close buffers you're not using**: Eglot keeps one server per project, but fewer buffers = less memory.

## Advanced: Custom clangd Configuration

Create a `.clangd` file in your project root for project-specific clangd settings:

```yaml
# .clangd - Project-specific clangd config
CompileFlags:
  CompilationDatabase: .          # Look for compile_commands.json here
  Add: [-std=c++20, -Wall]        # Additional flags for all files

Diagnostics:
  ClangTidy:
    Add: [modernize-*, readability-*]
    Remove: [modernize-use-trailing-return-type]
  UnusedIncludes: Strict

Index:
  Background: Build               # Build index in background
```

## Additional Resources

- **Eglot documentation**: `M-x info` → `Eglot`
- **clangd documentation**: https://clangd.llvm.org/
- **Envoy build documentation**: See Envoy's `.devcontainer/README.md`
- **Bazel compilation database**: https://github.com/grailbio/bazel-compilation-database

## Summary of Files Modified

- `profiles/cpp/config.el` - Enhanced LSP configuration and helper functions
- `profiles/cpp/packages.el` - Added bazel and protobuf-mode packages
- `/path/to/envoy/.dir-locals.el` - Project-specific Envoy configuration
- `profiles/cpp/README.md` - This file

## Next Steps

1. **Sync the profile**:
   ```bash
   doom sync --profile cpp
   ```

2. **Restart Emacs** with the C++ profile:
   ```bash
   emacs --profile cpp
   ```

3. **Open an Envoy file** and verify eglot connects and navigation works.

4. **Customize** keybindings or settings in `config.el` as needed.
