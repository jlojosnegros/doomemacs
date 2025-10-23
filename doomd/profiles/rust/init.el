;;; init.el -*- lexical-binding: t; -*-
;;
;; RUST PROFILE - Development environment for Rust
;; Inherits base configuration and adds Rust specific tools

(doom! :input
       :completion
       (corfu +orderless)
       vertico

       :ui
       doom
       doom-dashboard
       hl-todo
       modeline
       ophints
       (popup +defaults)
       (vc-gutter +pretty)
       vi-tilde-fringe
       workspaces

       :editor
       file-templates
       fold
       ;;(format +onsave)  ; auto-format with rustfmt on save
       snippets
       (whitespace +guess +trim)

       :emacs
       dired
       electric
       tramp
       undo
       vc

       :term
       ;;vterm             ; terminal for running cargo

       :checkers
       syntax
       ;;(spell +flyspell)

       :tools
       (eval +overlay)
       lookup
       (lsp +eglot)        ; LSP support with rust-analyzer
       ;;debugger          ; debugging support (lldb)
       magit
       (tree-sitter)       ; better syntax highlighting

       :os
       (:if (featurep :system 'macos) macos)

       :lang
       (rust +lsp +tree-sitter) ; Rust with LSP and tools
       emacs-lisp
       markdown
       org
       sh
       ;;toml              ; for Cargo.toml
       ;;json              ; for JSON configuration

       :email
       :app
       :config
       (default +bindings +smartparens))
