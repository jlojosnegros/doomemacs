#!/bin/bash
# Script para facilitar el cambio entre perfiles de Doom Emacs

PROFILES_DIR="$HOME/.doom.d/profiles"
PROFILES=("base" "cpp" "python" "rust")

show_usage() {
    cat << EOF
Uso: $(basename "$0") [COMANDO] [PERFIL]

COMANDOS:
    launch      Lanzar Emacs con un perfil específico
    sync        Sincronizar un perfil específico
    doctor      Ejecutar doom doctor en un perfil
    list        Listar perfiles disponibles
    set-default Establecer perfil por defecto (modifica DOOMPROFILE)
    help        Mostrar esta ayuda

PERFILES DISPONIBLES:
    base        - Configuración base común
    cpp         - Desarrollo C++ (con clangd)
    python      - Desarrollo Python (con pyright)
    rust        - Desarrollo Rust (con rust-analyzer)

EJEMPLOS:
    $(basename "$0") launch python    # Lanza Emacs con perfil Python
    $(basename "$0") sync cpp         # Sincroniza perfil C++
    $(basename "$0") doctor rust      # Ejecuta doctor en perfil Rust
    $(basename "$0") set-default cpp  # Establece C++ como perfil por defecto

EOF
}

list_profiles() {
    echo "Perfiles disponibles:"
    echo ""
    for profile in "${PROFILES[@]}"; do
        if [ -d "$PROFILES_DIR/$profile" ]; then
            echo "  ✓ $profile - $(get_profile_description "$profile")"
        else
            echo "  ✗ $profile - NO ENCONTRADO"
        fi
    done
    echo ""
    echo "Perfil actual: ${DOOMPROFILE:-default}"
}

get_profile_description() {
    case "$1" in
        base)   echo "Configuración base (theme, keybindings)" ;;
        cpp)    echo "C++ con LSP (clangd, cmake)" ;;
        python) echo "Python con LSP (pyright, black, pytest)" ;;
        rust)   echo "Rust con LSP (rust-analyzer, cargo)" ;;
        *)      echo "Descripción no disponible" ;;
    esac
}

validate_profile() {
    local profile="$1"
    for p in "${PROFILES[@]}"; do
        if [ "$p" = "$profile" ]; then
            return 0
        fi
    done
    echo "Error: Perfil '$profile' no válido"
    echo "Perfiles disponibles: ${PROFILES[*]}"
    return 1
}

case "${1:-help}" in
    launch)
        if [ -z "$2" ]; then
            echo "Error: Especifica un perfil"
            echo "Uso: $(basename "$0") launch [perfil]"
            exit 1
        fi
        if validate_profile "$2"; then
            echo "Lanzando Emacs con perfil '$2'..."
            emacs --profile "$2"
        fi
        ;;

    sync)
        if [ -z "$2" ]; then
            echo "Sincronizando todos los perfiles..."
            for profile in "${PROFILES[@]}"; do
                echo ""
                echo "=== Sincronizando $profile ==="
                ~/.config/emacs/bin/doom sync --profile "$profile"
            done
        else
            if validate_profile "$2"; then
                echo "Sincronizando perfil '$2'..."
                ~/.config/emacs/bin/doom sync --profile "$2"
            fi
        fi
        ;;

    doctor)
        if [ -z "$2" ]; then
            echo "Error: Especifica un perfil"
            echo "Uso: $(basename "$0") doctor [perfil]"
            exit 1
        fi
        if validate_profile "$2"; then
            echo "Ejecutando doom doctor en perfil '$2'..."
            ~/.config/emacs/bin/doom doctor --profile "$2"
        fi
        ;;

    list)
        list_profiles
        ;;

    set-default)
        if [ -z "$2" ]; then
            echo "Error: Especifica un perfil"
            echo "Uso: $(basename "$0") set-default [perfil]"
            exit 1
        fi
        if validate_profile "$2"; then
            SHELL_RC=""
            if [ -n "$BASH_VERSION" ]; then
                SHELL_RC="$HOME/.bashrc"
            elif [ -n "$ZSH_VERSION" ]; then
                SHELL_RC="$HOME/.zshrc"
            fi

            if [ -n "$SHELL_RC" ]; then
                echo "export DOOMPROFILE=$2" >> "$SHELL_RC"
                echo "✓ Perfil '$2' establecido como predeterminado en $SHELL_RC"
                echo "  Reinicia tu shell o ejecuta: source $SHELL_RC"
            else
                echo "Añade esta línea a tu archivo de configuración del shell:"
                echo "  export DOOMPROFILE=$2"
            fi
        fi
        ;;

    help|--help|-h)
        show_usage
        ;;

    *)
        echo "Comando desconocido: $1"
        echo ""
        show_usage
        exit 1
        ;;
esac
