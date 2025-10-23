;;; config.el -*- lexical-binding: t; -*-
;;
;; RUST PROFILE - Configuration

;; Load base configuration
(load! "../base/config.el")

;;
;;; Rust specific configuration

;; Rust-mode configuration
(after! rustic
  ;; Use rust-analyzer (recommended)
  (setq rustic-lsp-client 'eglot  ; or 'lsp-mode
        rustic-format-on-save nil  ; set to t for auto-format
        rustic-format-trigger 'on-save)

  ;; Cargo configuration
  (setq rustic-cargo-bin "cargo"
        rustic-rustfmt-bin "rustfmt"
        rustic-clippy-bin "clippy")

  ;; Better compilation
  (setq rustic-compile-backtrace "1")

  ;; Display errors inline
  (setq rustic-display-spinner nil))

;; LSP rust-analyzer configuration
(after! lsp-mode
  (setq lsp-rust-analyzer-cargo-watch-command "clippy"
        lsp-rust-analyzer-server-display-inlay-hints t
        lsp-rust-analyzer-display-lifetime-elision-hints-enable "skip_trivial"
        lsp-rust-analyzer-display-chaining-hints t
        lsp-rust-analyzer-display-parameter-hints t
        lsp-rust-analyzer-display-closure-return-type-hints t
        lsp-rust-analyzer-display-reborrow-hints "mutable"))

;; Eglot rust-analyzer configuration
(after! eglot
  (add-hook 'rust-mode-hook
            (lambda ()
              (setq-local eglot-workspace-configuration
                          '(:rust-analyzer
                            (:checkOnSave (:command "clippy")
                             :inlayHints (:enable t)))))))

;; Cargo integration
(after! rustic
  ;; Better test output
  (setq rustic-test-arguments "--nocapture"))

;; Keybindings for Rust development
(map! :map rustic-mode-map
      :localleader
      :desc "Cargo build" "c b" #'rustic-cargo-build
      :desc "Cargo run" "c r" #'rustic-cargo-run
      :desc "Cargo test" "c t" #'rustic-cargo-test
      :desc "Cargo test current" "c T" #'rustic-cargo-current-test
      :desc "Cargo check" "c c" #'rustic-cargo-check
      :desc "Cargo clippy" "c C" #'rustic-cargo-clippy
      :desc "Cargo clean" "c k" #'rustic-cargo-clean
      :desc "Cargo doc" "c d" #'rustic-cargo-doc
      :desc "Format buffer" "f" #'rustic-format-buffer
      :desc "Cargo add dependency" "c a" #'rustic-cargo-add
      :desc "Cargo rm dependency" "c D" #'rustic-cargo-rm
      :desc "Open Cargo.toml" "o" #'rustic-cargo-open-project-toml
      :desc "Toggle inline hints" "h" #'lsp-rust-analyzer-inlay-hints-mode)

;; Optional: Crates.io integration for dependency management
;; (after! cargo
;;   (add-hook 'rust-mode-hook #'cargo-minor-mode))
