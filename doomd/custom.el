;;; -*- lexical-binding: t -*-
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(safe-local-variable-values
   '((eval progn (add-hook 'c++-mode-hook #'eglot-ensure nil t)
           (setq-local compile-command
                       "./ci/run_envoy_docker.sh './ci/do_ci.sh dev'"))
     (flycheck-gcc-language-standard . "c++20")
     (flycheck-clang-language-standard . "c++20")
     (eval setq-local projectile-project-root
           (locate-dominating-file default-directory ".dir-locals.el")))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
