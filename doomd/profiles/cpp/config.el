;;; config.el -*- lexical-binding: t; -*-
;;
;; C++ PROFILE - Configuration

;; Load base configuration
(load! "../base/config.el")

;;
;;; C++ specific configuration

;; C++ formatting style
(after! cc-mode
  (setq c-default-style "linux"
        c-basic-offset 4)

  ;; C++17 and newer standards
  (setq-default c++-mode-hook
                (lambda ()
                  (setq flycheck-gcc-language-standard "c++17")
                  (setq flycheck-clang-language-standard "c++17"))))

;; LSP configuration for C++
(after! lsp-mode
  (setq lsp-clients-clangd-args
        '("--background-index"
          "--clang-tidy"
          "--completion-style=detailed"
          "--header-insertion=never"
          "--header-insertion-decorators=0"))

  ;; Performance tuning
  (setq lsp-idle-delay 0.5
        lsp-log-io nil))

;; Eglot configuration (alternative to lsp-mode)
(after! eglot
  (add-to-list 'eglot-server-programs
               '((c++-mode c-mode) . ("clangd"
                                      "--background-index"
                                      "--clang-tidy"
                                      "--completion-style=detailed"))))

;; CMake integration
(add-hook 'cmake-mode-hook
          (lambda ()
            (setq cmake-tab-width 4)))

;; Keybindings for C++ development
(map! :map c++-mode-map
      :localleader
      :desc "Compile" "c" #'compile
      :desc "Recompile" "r" #'recompile
      :desc "Format buffer" "f" #'clang-format-buffer
      :desc "Format region" "F" #'clang-format-region)

;; Optional: Enable modern-c++-font-lock for better syntax highlighting
;; (add-hook 'c++-mode-hook #'modern-c++-font-lock-mode)
