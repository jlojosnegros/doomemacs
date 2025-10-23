;;; config.el -*- lexical-binding: t; -*-
;;
;; BASE PROFILE - Common configuration

;; Theme
(setq doom-theme 'doom-one)

;; Line numbers
(setq display-line-numbers-type t)

;; Org directory
(setq org-directory "~/org/")

;;
;;; Emacs keybindings (no evil mode)

;; Common keybindings for all profiles
(map! :map global-map
      ;; Better buffer navigation
      "C-x C-b" #'ibuffer
      ;; Quick access to config
      "C-c C-," #'doom/open-private-config
      ;; Better window navigation
      "C-x o" #'other-window
      "C-x 2" #'split-window-below
      "C-x 3" #'split-window-right
      "C-x 0" #'delete-window
      "C-x 1" #'delete-other-windows)

;; Useful Doom leader key shortcuts (C-c by default for non-evil)
(map! :leader
      :desc "Find file in project" "p f" #'projectile-find-file
      :desc "Switch project" "p p" #'projectile-switch-project
      :desc "Search in project" "p s" #'projectile-ripgrep
      :desc "Open vterm" "o t" #'vterm
      :desc "Toggle treemacs" "o p" #'treemacs)

;; Font configuration (uncomment and adjust as needed)
;; (setq doom-font (font-spec :family "Fira Code" :size 12)
;;       doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))

;; Performance tweaks
(setq gc-cons-threshold 100000000)  ; 100MB
(setq read-process-output-max (* 1024 1024))  ; 1MB
