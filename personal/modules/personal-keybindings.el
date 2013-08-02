;;; Code:

;; bind standard Mac keys
(setq mac-command-modifier 'super)
(setq mac-option-modifier 'meta)

(global-set-key (kbd "<s-return>") 'toggle-fullscreen)
(global-set-key '[(meta super left)] 'shrink-window-horizontally)
(global-set-key '[(meta super right)]'enlarge-window-horizontally)
(global-set-key '[(meta super down)] 'shrink-window)
(global-set-key '[(meta super up)] 'enlarge-window)
(global-set-key [(super =)] 'er/expand-region)
(global-set-key [(super -)] 'er/contract-region)
(global-set-key [(super z)] 'undo)
(global-set-key [(super x)] 'clipboard-kill-region)
(global-set-key [(super c)] 'clipboard-kill-ring-save)
(global-set-key [(super v)] 'yank)
(global-set-key [(super a)] 'mark-whole-buffer)
(global-set-key [(super w)] 'erlang-wrangler-on)
(global-set-key (kbd "M-n") 'linum-mode)
(global-set-key (kbd "M-p") 'nav-toggle)
(global-set-key (kbd "S-`") 'other-frame)
(global-set-key (kbd "<C-tab>") 'bury-buffer)
(global-set-key [(super i)] 'prelude-indent-region-or-buffer)
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

(provide 'personal-keybindings)
;;; prelude-keybindings.el ends here
