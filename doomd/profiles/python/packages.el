;;; packages.el -*- lexical-binding: t; -*-
;;
;; PYTHON PROFILE - Additional packages

;; Python environment management
(package! pyvenv)

;; Testing framework
(package! python-pytest)

;; Code formatting
(package! py-isort)  ; Sort imports
(package! blacken)   ; Black formatter integration

;; Type checking
;; (package! flycheck-mypy)

;; Jupyter/IPython integration (optional)
;; (package! ein)  ; Emacs IPython Notebook

;; Poetry integration (optional)
;; (package! poetry)

;; Virtual environment detection (optional)
;; (package! auto-virtualenv)
