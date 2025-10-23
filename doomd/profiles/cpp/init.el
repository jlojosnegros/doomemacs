;;; init.el -*- lexical-binding: t; -*-
;;
;; C++ PROFILE - Development environment for C++
;; Inherits base configuration and adds C++ specific tools

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
       ;;(format +onsave)  ; auto-format on save (uncomment if desired)
       snippets
       (whitespace +guess +trim)

       :emacs
       dired
       electric
       tramp
       undo
       vc

       :term
       ;;vterm             ; terminal emulator

       :checkers
       syntax
       ;;(spell +flyspell)

       :tools
       (eval +overlay)
       lookup
       (lsp +eglot)        ; LSP support with eglot
       ;;debugger          ; debugging support (gdb)
       magit
       ;;make              ; build system integration
       (tree-sitter)       ; better syntax highlighting

       :os
       (:if (featurep :system 'macos) macos)

       :lang
       (cc +lsp +tree-sitter) ; C/C++ with LSP and tree-sitter
       emacs-lisp
       markdown
       org
       sh
       ;;cmake             ; CMake support (if you have a cmake module)
       ;;json              ; for compile_commands.json

       :email
       :app
       :config
       (default +bindings +smartparens))
