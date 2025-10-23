;;; config.el -*- lexical-binding: t; -*-
;;
;; PYTHON PROFILE - Configuration

;; Load base configuration
(load! "../base/config.el")

;;
;;; Python specific configuration

;; Python environment
(after! python
  ;; Use IPython for REPL if available
  (setq python-shell-interpreter "ipython"
        python-shell-interpreter-args "-i --simple-prompt --no-color-info"
        python-shell-prompt-regexp "In \\[[0-9]+\\]: "
        python-shell-prompt-output-regexp "Out\\[[0-9]+\\]: "
        python-shell-completion-setup-code
        "from IPython.core.completerlib import module_completion"
        python-shell-completion-module-string-code
        "';'.join(module_completion('''%s'''))\n"
        python-shell-completion-string-code
        "';'.join(get_ipython().Completer.all_completions('''%s'''))\n")

  ;; Pytest integration
  (setq python-pytest-executable "pytest"))

;; LSP configuration for Python
(after! lsp-mode
  ;; Pyright configuration (recommended)
  (setq lsp-pyright-multi-root nil
        lsp-pyright-use-library-code-for-types t
        lsp-pyright-diagnostic-mode "workspace")

  ;; Python LSP Server configuration (alternative)
  (setq lsp-pylsp-plugins-flake8-enabled t
        lsp-pylsp-plugins-pylint-enabled nil
        lsp-pylsp-plugins-pycodestyle-enabled nil
        lsp-pylsp-plugins-autopep8-enabled nil
        lsp-pylsp-plugins-yapf-enabled nil
        lsp-pylsp-plugins-black-enabled t))

;; Formatting with Black
(after! python
  (add-hook 'python-mode-hook
            (lambda ()
              ;; Use black for formatting
              (setq-local format-all-formatters '(("Python" black))))))

;; Virtual environment support
(after! pyvenv
  ;; Auto-activate virtualenv if .venv exists
  (add-hook 'python-mode-hook
            (lambda ()
              (when-let ((venv (locate-dominating-file default-directory ".venv")))
                (pyvenv-activate (expand-file-name ".venv" venv))))))

;; Keybindings for Python development
(map! :map python-mode-map
      :localleader
      :desc "Start Python REPL" "'" #'+python/open-repl
      :desc "Send region to REPL" "s r" #'python-shell-send-region
      :desc "Send buffer to REPL" "s b" #'python-shell-send-buffer
      :desc "Send defun to REPL" "s d" #'python-shell-send-defun
      :desc "Run pytest" "t t" #'python-pytest
      :desc "Run pytest file" "t f" #'python-pytest-file
      :desc "Format buffer" "f" #'format-all-buffer
      :desc "Sort imports" "i" #'py-isort-buffer)

;; Jupyter/IPython notebook support (if using ein module)
;; (after! ein
;;   (setq ein:output-area-inlined-images t))
