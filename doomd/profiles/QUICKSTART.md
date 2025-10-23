# Inicio Rápido - Perfiles de Doom Emacs

## 🎯 ¿Qué son los perfiles?

Los perfiles te permiten tener múltiples configuraciones de Emacs especializadas para diferentes tareas, todas compartiendo una configuración base común.

## 📦 Perfiles creados

| Perfil | Descripción | Lenguajes | LSP |
|--------|-------------|-----------|-----|
| **base** | Configuración común | Emacs Lisp, Markdown, Org, Bash | - |
| **cpp** | Desarrollo C++ | C, C++ | clangd |
| **python** | Desarrollo Python | Python | pyright |
| **rust** | Desarrollo Rust | Rust | rust-analyzer |

## 🚀 Uso rápido

### Con el script auxiliar (recomendado)

```bash
# Lanzar Emacs con un perfil
~/.doom.d/profiles/switch-profile.sh launch python

# Listar perfiles disponibles
~/.doom.d/profiles/switch-profile.sh list

# Sincronizar todos los perfiles
~/.doom.d/profiles/switch-profile.sh sync

# Sincronizar un perfil específico
~/.doom.d/profiles/switch-profile.sh sync cpp
```

### Directamente con Emacs/Doom

```bash
# Lanzar Emacs con un perfil
emacs --profile python

# Sincronizar un perfil
doom sync --profile cpp

# Ejecutar doom doctor en un perfil
doom doctor --profile rust
```

## 🔧 Establecer perfil por defecto

### Opción 1: Variable de entorno

Añade a tu `~/.bashrc` o `~/.zshrc`:

```bash
export DOOMPROFILE=python  # Cambia 'python' por el perfil que prefieras
```

### Opción 2: Alias

Añade a tu `~/.bashrc` o `~/.zshrc`:

```bash
alias em-cpp='emacs --profile cpp'
alias em-py='emacs --profile python'
alias em-rs='emacs --profile rust'
alias em-base='emacs --profile base'
```

### Opción 3: Usar el script

```bash
~/.doom.d/profiles/switch-profile.sh set-default python
```

## 📋 Dependencias del sistema

### Para todos los perfiles
```bash
sudo dnf install git ripgrep fd-find  # Ya deberías tenerlos
```

### Para C++ (perfil cpp)
```bash
# Fedora
sudo dnf install clang-tools-extra cmake

# Ubuntu/Debian
sudo apt install clangd clang-format cmake
```

### Para Python (perfil python)
```bash
# Instalar pyright (recomendado)
pip install --user pyright

# O python-lsp-server (alternativa)
pip install --user python-lsp-server

# Herramientas de desarrollo
pip install --user black isort pytest ipython
```

### Para Rust (perfil rust)
```bash
# Instalar rustup si no lo tienes
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# Componentes necesarios (normalmente ya vienen)
rustup component add rust-analyzer rustfmt clippy
```

## 🎨 Características comunes a todos los perfiles

- ✅ **Sin evil-mode** - Keybindings estándar de Emacs
- ✅ **Theme**: doom-one (puedes cambiarlo en `base/config.el`)
- ✅ **Completion**: Corfu + Vertico
- ✅ **Git**: Magit
- ✅ **Org-mode**: Completo
- ✅ **Snippets**: Yasnippet
- ✅ **Leader key**: `C-c` (en lugar de `SPC` de Vim)

## ⌨️ Keybindings importantes

### Globales (todos los perfiles)
```
C-x C-f     Abrir archivo
C-x C-s     Guardar archivo
C-x C-b     Lista de buffers (ibuffer)
C-x b       Cambiar buffer
C-x k       Cerrar buffer

C-c p f     Buscar archivo en proyecto (projectile)
C-c p p     Cambiar de proyecto
C-c p s     Buscar en proyecto (ripgrep)
C-c C-,     Abrir configuración de Doom
```

### Específicos por lenguaje

#### C++ (perfil cpp)
```
C-c m c     Compilar
C-c m r     Recompilar
C-c m f     Formatear buffer con clang-format
```

#### Python (perfil python)
```
C-c m '     Abrir Python REPL
C-c m s r   Enviar región al REPL
C-c m t t   Ejecutar pytest
C-c m f     Formatear con black
```

#### Rust (perfil rust)
```
C-c m c b   Cargo build
C-c m c r   Cargo run
C-c m c t   Cargo test
C-c m c c   Cargo check
C-c m c C   Cargo clippy
C-c m f     Formatear con rustfmt
```

## 🔄 Flujo de trabajo típico

1. **Primera vez**: Sincronizar todos los perfiles
   ```bash
   ~/.doom.d/profiles/switch-profile.sh sync
   ```

2. **Trabajar en un proyecto Python**:
   ```bash
   cd ~/mi-proyecto-python
   emacs --profile python
   ```

3. **Trabajar en un proyecto C++**:
   ```bash
   cd ~/mi-proyecto-cpp
   emacs --profile cpp
   ```

4. **Después de modificar configuración**:
   ```bash
   doom sync --profile <nombre>
   ```

## 📝 Personalización

### Cambiar el theme en todos los perfiles

Edita `~/.doom.d/profiles/base/config.el`:
```elisp
(setq doom-theme 'doom-gruvbox)  ; o cualquier otro theme
```

Luego sincroniza:
```bash
~/.doom.d/profiles/switch-profile.sh sync
```

### Añadir paquetes a un perfil específico

Ejemplo para Python, edita `~/.doom.d/profiles/python/packages.el`:
```elisp
(package! nombre-del-paquete)
```

Luego sincroniza ese perfil:
```bash
doom sync --profile python
```

### Modificar keybindings

Edita el archivo `config.el` del perfil correspondiente y añade:
```elisp
(map! :map python-mode-map
      "C-c C-r" #'mi-funcion-personalizada)
```

## 🐛 Solución de problemas

### Error al lanzar un perfil
```bash
# Limpiar y reconstruir
doom clean --profile python
doom sync --profile python
```

### LSP no funciona
```bash
# Verificar que el language server está instalado
which clangd    # Para C++
which pyright   # Para Python
which rust-analyzer  # Para Rust

# Ejecutar doom doctor
doom doctor --profile <nombre>
```

### Cambios no se aplican
```bash
# Asegúrate de sincronizar después de cambios
doom sync --profile <nombre>

# Y reinicia Emacs
```

## 📚 Recursos adicionales

- [Documentación de Doom Emacs](https://github.com/doomemacs/doomemacs)
- [Doom Discourse](https://discourse.doomemacs.org/)
- [Doom Discord](https://doomemacs.org/discord)
- README completo: `~/.doom.d/profiles/README.md`

## 💡 Tips

1. **Usa `C-h k`** seguido de una tecla para ver qué hace ese keybinding
2. **Usa `C-h v`** para inspeccionar variables
3. **Usa `C-h f`** para ver documentación de funciones
4. **Usa `M-x describe-mode`** para ver información del modo actual y sus keybindings
5. **Usa `which-key`** (espera después de `C-c`) para ver comandos disponibles
