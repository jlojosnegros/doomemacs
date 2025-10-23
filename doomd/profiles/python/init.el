;;; init.el -*- lexical-binding: t; -*-
;;
;; PYTHON PROFILE - Development environment for Python
;; Inherits base configuration and adds Python specific tools

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
       ;;(format +onsave)  ; auto-format with black on save
       snippets
       (whitespace +guess +trim)

       :emacs
       dired
       electric
       tramp
       undo
       vc

       :term
       ;;vterm             ; terminal for running Python REPL

       :checkers
       syntax
       ;;(spell +flyspell)

       :tools
       (eval +overlay)
       lookup
       (lsp +eglot)        ; LSP support with eglot (pylsp/pyright)
       ;;debugger          ; debugging support (pdb, debugpy)
       magit
       (tree-sitter)       ; better syntax highlighting

       :os
       (:if (featurep :system 'macos) macos)

       :lang
       (python +lsp +pyright +tree-sitter) ; Python with LSP and tools
       emacs-lisp
       markdown
       org
       sh
       ;;json              ; for working with JSON data
       ;;yaml              ; for config files
       ;;rest              ; for testing REST APIs

       :email
       :app
       :config
       (default +bindings +smartparens))
