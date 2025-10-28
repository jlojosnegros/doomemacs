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

  ;; C++17 and newer standards (can be overridden per-project with .dir-locals.el)
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
          "--header-insertion-decorators=0"
          ;; Enable compile_commands.json discovery
          "--compile-commands-dir=."
          ;; Performance improvements for large codebases
          "--pch-storage=memory"
          "--limit-results=100"))

  ;; Performance tuning for large projects like Envoy
  (setq lsp-idle-delay 0.5
        lsp-log-io nil
        lsp-enable-file-watchers nil  ; Disable for performance in large repos
        lsp-file-watch-threshold 5000))

;; Eglot configuration (preferred for this profile)
(after! eglot
  ;; Enhanced clangd configuration
  (setq eglot-server-programs
        (cons '((c++-mode c-mode) . ("clangd"
                                     "--background-index"
                                     "--clang-tidy"
                                     "--completion-style=detailed"
                                     "--header-insertion=never"
                                     "--compile-commands-dir=."
                                     "--pch-storage=memory"
                                     "--limit-results=100"
                                     ;; Useful for large projects with many headers
                                     "--all-scopes-completion"
                                     "--function-arg-placeholders"
                                     ;; Enable logging for debugging (comment out for production)
                                     ;; "--log=verbose"
                                     ))
              (assq-delete-all '(c++-mode c-mode) eglot-server-programs)))

  ;; Performance tuning for eglot
  (setq eglot-events-buffer-size 0  ; Disable event logging for performance
        eglot-sync-connect nil       ; Don't block on connection
        eglot-autoshutdown t)        ; Shutdown server when last buffer closes

  ;; Better diagnostics display
  (setq eglot-report-progress t)

  ;; Increase request timeout for large projects
  (setq eglot-connect-timeout 120))

;; CMake integration
(add-hook 'cmake-mode-hook
          (lambda ()
            (setq cmake-tab-width 4)))

;;
;;; Project-specific helpers

;; Function to refresh compile_commands.json for Envoy
(defun +cpp/refresh-envoy-compdb ()
  "Regenerate compile_commands.json for Envoy using the DevContainer."
  (interactive)
  (let* ((default-directory (or (locate-dominating-file default-directory "ci/do_ci.sh")
                                default-directory))
         (cmd "./ci/run_envoy_docker.sh './ci/do_ci.sh refresh_compdb'"))
    (if (file-exists-p "ci/do_ci.sh")
        (progn
          (message "Refreshing compilation database for Envoy (this may take a while)...")
          (compile cmd))
      (user-error "Not in an Envoy project directory"))))

;; Function to find compile_commands.json in project
(defun +cpp/find-compile-commands ()
  "Find compile_commands.json in the current project."
  (interactive)
  (let ((compdb (locate-dominating-file default-directory "compile_commands.json")))
    (if compdb
        (progn
          (message "Found compile_commands.json in: %s" compdb)
          (find-file (expand-file-name "compile_commands.json" compdb)))
      (user-error "No compile_commands.json found in project tree"))))

;; Auto-detect project root for large C++ projects
(defun +cpp/project-root ()
  "Find the root of a C++ project."
  (or (locate-dominating-file default-directory "compile_commands.json")
      (locate-dominating-file default-directory ".git")
      (locate-dominating-file default-directory "BUILD")
      (locate-dominating-file default-directory "WORKSPACE")
      default-directory))

;; Set project root for projectile
(after! projectile
  (add-to-list 'projectile-project-root-files "compile_commands.json")
  (add-to-list 'projectile-project-root-files "WORKSPACE")  ; Bazel workspace
  (add-to-list 'projectile-project-root-files ".bazelversion"))

;; Automatically enable eglot in C++ files when compile_commands.json exists
(defun +cpp/maybe-enable-eglot ()
  "Enable eglot if compile_commands.json is found in project."
  (when (and (derived-mode-p 'c-mode 'c++-mode)
             (locate-dominating-file default-directory "compile_commands.json"))
    (eglot-ensure)))

;; Uncomment to auto-start eglot when opening C++ files in projects with compile_commands.json
;; (add-hook 'c++-mode-hook #'+cpp/maybe-enable-eglot)
;; (add-hook 'c-mode-hook #'+cpp/maybe-enable-eglot)

;; Keybindings for C++ development
(map! :map c++-mode-map
      :localleader
      :desc "Compile" "c" #'compile
      :desc "Recompile" "r" #'recompile
      :desc "Format buffer" "f" #'clang-format-buffer
      :desc "Format region" "F" #'clang-format-region
      ;;; LSP/Eglot commands
      :desc "Find references" "l r" #'xref-find-references
      :desc "Find definition" "l d" #'xref-find-definitions
      :desc "Rename symbol" "l R" #'eglot-rename
      :desc "Code actions" "l a" #'eglot-code-actions
      :desc "Format buffer (LSP)" "l f" #'eglot-format-buffer
      :desc "Restart LSP" "l s" #'eglot-reconnect
      ;;; Project-specific
      :desc "Refresh compile DB (Envoy)" "p c" #'+cpp/refresh-envoy-compdb
      :desc "Find compile_commands.json" "p f" #'+cpp/find-compile-commands)

;; Same keybindings for C mode
(map! :map c-mode-map
      :localleader
      :desc "Compile" "c" #'compile
      :desc "Recompile" "r" #'recompile
      :desc "Format buffer" "f" #'clang-format-buffer
      :desc "Format region" "F" #'clang-format-region
      ;;; LSP/Eglot commands
      :desc "Find references" "l r" #'xref-find-references
      :desc "Find definition" "l d" #'xref-find-definitions
      :desc "Rename symbol" "l R" #'eglot-rename
      :desc "Code actions" "l a" #'eglot-code-actions
      :desc "Format buffer (LSP)" "l f" #'eglot-format-buffer
      :desc "Restart LSP" "l s" #'eglot-reconnect
      ;;; Project-specific
      :desc "Refresh compile DB (Envoy)" "p c" #'+cpp/refresh-envoy-compdb
      :desc "Find compile_commands.json" "p f" #'+cpp/find-compile-commands)

;; Optional: Enable modern-c++-font-lock for better syntax highlighting
;; (add-hook 'c++-mode-hook #'modern-c++-font-lock-mode)
