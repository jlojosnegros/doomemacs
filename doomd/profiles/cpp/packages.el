;;; packages.el -*- lexical-binding: t; -*-
;;
;; C++ PROFILE - Additional packages

;; Modern C++ font-lock for better syntax highlighting
(package! modern-cpp-font-lock)

;; CMake mode (if not included in Doom by default)
(package! cmake-mode)

;; Clang-format integration
(package! clang-format)

;; Bazel support for BUILD files
(package! bazel
  :recipe (:host github :repo "bazelbuild/emacs-bazel-mode"))

;; Optional: Google's C++ style guide
;; (package! google-c-style)

;; Optional: Company-c-headers for completion
;; (package! company-c-headers)

;; Optional: Protobuf mode for .proto files (common in projects like Envoy)
(package! protobuf-mode)
