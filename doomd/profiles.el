;;; profiles.el --- Doom profiles configuration -*- lexical-binding: t; -*-

;; Doom profiles allow you to have multiple configurations that can be switched
;; between easily. Each profile can have its own packages, modules, and settings.
;;
;; Usage:
;;   Launch a profile: emacs --profile <name>
;;   Use doom with profile: doom sync --profile <name>
;;   Set default profile: export DOOMPROFILE=<name>

((base
  ;; Base profile with common configuration shared by all other profiles
  ;; This includes theme, general keybindings, and essential packages
  (user-emacs-directory :path "~/.doom.d/profiles/base"))

 (cpp
  ;; C++ development profile (inherits from base)
  ;; Includes LSP, debugging tools, and C++ specific packages
  (user-emacs-directory :path "~/.doom.d/profiles/cpp"))

 (python
  ;; Python development profile (inherits from base)
  ;; Includes LSP, virtual environment management, and Python tools
  (user-emacs-directory :path "~/.doom.d/profiles/python"))

 (rust
  ;; Rust development profile (inherits from base)
  ;; Includes rust-analyzer, cargo integration, and Rust tools
  (user-emacs-directory :path "~/.doom.d/profiles/rust")))
