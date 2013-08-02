;;; Code:

(add-to-list 'auto-mode-alist '("Capfile$" . ruby-mode))
(add-to-list 'auto-mode-alist '("Gemfile$" . ruby-mode))
(add-to-list 'auto-mode-alist '("Rakefile$" . ruby-mode))
(add-to-list 'auto-mode-alist '("Vagrantfile$" . ruby-mode))
(add-to-list 'auto-mode-alist '("Cheffile$" . ruby-mode))
(add-to-list 'auto-mode-alist '("Guardfile$" . ruby-mode))

(add-hook 'ruby-mode-hook
          (lambda () (modify-syntax-entry ?_ "w")))

;(require 'rcodetools)
;(define-key ruby-mode-map (kbd "C-c C-c") 'xmp)

(provide 'personal-ruby)
;;; prelude-ruby.el ends here
