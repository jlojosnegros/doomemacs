# Doom Emacs Profiles

This directory contains multiple Doom Emacs profiles for different development environments.

## Perfiles disponibles

### 1. **base** - Perfil base
- Configuración común para todos los perfiles
- Theme: doom-one
- Keybindings: Emacs estándar (sin evil-mode)
- Módulos básicos: org, markdown, magit, etc.

### 2. **cpp** - Desarrollo C++
- Hereda configuración del perfil base
- LSP: clangd con eglot
- Herramientas: clang-format, cmake-mode
- Tree-sitter para mejor sintaxis
- Keybindings específicos para compilación y formato

### 3. **python** - Desarrollo Python
- Hereda configuración del perfil base
- LSP: pyright o pylsp con eglot
- Herramientas: black, isort, pytest
- Soporte para virtualenv/venv
- IPython REPL integration

### 4. **rust** - Desarrollo Rust
- Hereda configuración del perfil base
- LSP: rust-analyzer con eglot
- Herramientas: rustfmt, clippy
- Cargo integration completa
- Inlay hints para tipos

## Uso

### Sincronizar un perfil específico

```bash
# Sincronizar perfil base
doom sync --profile base

# Sincronizar perfil C++
doom sync --profile cpp

# Sincronizar perfil Python
doom sync --profile python

# Sincronizar perfil Rust
doom sync --profile rust
```

### Lanzar Emacs con un perfil

```bash
# Lanzar con perfil base
emacs --profile base

# Lanzar con perfil C++
emacs --profile cpp

# Lanzar con perfil Python
emacs --profile python

# Lanzar con perfil Rust
emacs --profile rust
```

### Establecer un perfil por defecto

Añade a tu `~/.bashrc` o `~/.zshrc`:

```bash
# Para usar siempre el perfil Python por defecto
export DOOMPROFILE=python

# O crea un alias
alias emacs-cpp='emacs --profile cpp'
alias emacs-py='emacs --profile python'
alias emacs-rs='emacs --profile rust'
```

## Dependencias del sistema

### Para C++:
```bash
# Instalar clangd
sudo dnf install clang-tools-extra  # Fedora
# sudo apt install clangd            # Ubuntu/Debian

# Instalar clang-format
sudo dnf install clang-tools-extra
```

### Para Python:
```bash
# Instalar Python LSP servers
pip install --user python-lsp-server  # pylsp
# o
pip install --user pyright            # pyright (recomendado)

# Herramientas de desarrollo
pip install --user black isort pytest ipython
```

### Para Rust:
```bash
# Instalar rust-analyzer (viene con rustup)
rustup component add rust-analyzer

# Instalar herramientas adicionales
rustup component add rustfmt clippy
```

## Personalización

Cada perfil tiene su propia estructura:
```
profiles/<nombre>/
├── init.el      # Módulos de Doom habilitados
├── config.el    # Configuración específica del lenguaje
└── packages.el  # Paquetes adicionales
```

Para modificar un perfil:
1. Edita los archivos correspondientes en `~/.doom.d/profiles/<nombre>/`
2. Ejecuta `doom sync --profile <nombre>`
3. Reinicia Emacs con el perfil

## Estructura de herencia

Todos los perfiles heredan la configuración base mediante:
```elisp
(load! "../base/config.el")
```

Esto permite:
- Mantener configuración común en un solo lugar
- Personalizar cada perfil con sus propias necesidades
- Fácil mantenimiento y actualización

## Comandos útiles

```bash
# Ver todos los perfiles disponibles
doom profile list

# Ver información del perfil actual
doom profile info

# Limpiar cache de un perfil
doom clean --profile <nombre>

# Actualizar todos los paquetes de un perfil
doom upgrade --profile <nombre>
```

## Troubleshooting

Si un perfil no funciona correctamente:

1. Verifica que se sincronizó correctamente:
   ```bash
   doom sync --profile <nombre>
   ```

2. Ejecuta el doctor:
   ```bash
   doom doctor --profile <nombre>
   ```

3. Limpia y reconstruye:
   ```bash
   doom clean --profile <nombre>
   doom sync --profile <nombre>
   ```

4. Verifica que las dependencias del sistema estén instaladas (ver sección arriba)
