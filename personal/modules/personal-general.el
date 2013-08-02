;;; Code:

(if (fboundp 'global-flycheck-mode)
    (global-flycheck-mode -1)
  (remove-hook 'prog-mode-hook 'flycheck-mode))

;; highlight the current line
(global-hl-line-mode -1)

;; encoding
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(prefer-coding-system 'utf-8)

(require 'nav)

;; enable fill column indicator
(require 'fill-column-indicator)
(require 'fci-osx-23-fix)
(setq fci-always-use-textual-rule 1)
(setq fci-rule-color "#000000")
(setq-default fci-rule-column 79)
(define-globalized-minor-mode
  global-fci-mode fci-mode (lambda () (fci-mode 1)))
(global-fci-mode 1)
(setq whitespace-style '(face trailing))

;; turn on the dired details
(require 'dired-details)
(dired-details-install)
;; configure omit files
(setq-default dired-omit-extensions
              '(".pyc" ".beam" ".class" ".o" "~" ".dvi" ".aux" ".elc"))
;; configure dired
(add-hook 'dired-mode-hook
          (lambda ()
            (require 'dired-x)
            (dired-omit-mode 1)))

;; disable dired hidden string
(setq-default dired-details-hidden-string "")

;; stops using lockfiles
(setq create-lockfiles nil)

;; remove trailing whitespaces and tabs
(defun remove-trailing-whitespaces-and-tabs ()
  (interactive)
  (if (not indent-tabs-mode)
      (untabify (point-min) (point-max)))
  (delete-trailing-whitespace))
(add-hook 'before-save-hook 'remove-trailing-whitespaces-and-tabs)

;; configure makefile mode
(add-to-list 'auto-mode-alist '("Makefile$" . makefile-mode))

(provide 'personal-general)
;;; personal-general.el ends here
