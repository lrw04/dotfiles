;;; init.el --- Emacs configuration

;; Ensure new version
(let ((minver "28.1"))
  (when (version< emacs-version minver)
    (error "Emacs is too old: v%s is required." minver)))

'(add-to-list 'load-path (expand-file-name "custom" user-emacs-directory))

'(set-fontset-font t nil (font-spec :size 14 :name "等距更纱黑体 SC"))
'(set-frame-font "等距更纱黑体 SC 14" nil t)
'(set-language-environment "UTF-8")

;; Convenience settings
(cd "~/")
(setq visible-bell 1)			                          ; disable ringing for C-g and such
(setq gc-cons-threshold (* 256 1024 1024))               ; to accelerate boot?	
(defconst *spell-check-support-enabled* t)
(electric-pair-mode t)		                              ; automatically pair parentheses
(add-hook 'prog-mode-hook #'show-paren-mode)              ; highlight pairing parentheses
(global-auto-revert-mode t)	                              ; automatically refresh on file change
(delete-selection-mode t)	                              ; replace marked text when typing
(setq make-backup-files nil)
(add-hook 'prog-mode-hook #'hs-minor-mode)                ; enable folding
(global-display-line-numbers-mode 1)
(setq display-line-numbers-type 'relative)
'(add-to-list 'default-frame-alist '(width . 160))
'(add-to-list 'default-frame-alist '(height . 60))
(fset 'yes-or-no-p 'y-or-n-p)
(load-theme 'leuven t)

(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)

;; Mirror configuration
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)

;; Configure general packages
(use-package bind-key :ensure t :config (add-to-list 'same-window-buffer-names "*Personal Keybindings*"))

(use-package ivy
  :ensure t
  :init (ivy-mode)
  :config (progn (setq ivy-use-virtual-buffers t))
  :bind (("C-x b" . 'ivy-switch-buffer)
	 ("C-c v" . 'ivy-push-view)
	 ("C-c s" . 'ivy-switch-view)
	 ("C-c V" . 'ivy-pop-view)))

(use-package counsel
  :ensure t
  :bind (("M-x" . counsel-M-x)))

(use-package amx
  :ensure t
  :init (amx-mode))

(use-package ace-window
  :ensure t
  :bind (("M-o" . 'ace-window)))

(use-package mwim
  :ensure t
  :bind (("C-a" . mwim-beginning-of-code-or-line)
	     ("C-e" . mwim-end-of-code-or-line)))

(use-package marginalia
  :ensure t
  :init (marginalia-mode)
  :bind (:map minibuffer-local-map ("M-A" . marginalia-cycle)))

(use-package projectile
  :ensure t
  :bind ("C-c p" . projectile-command-map)
  :config (progn (setq projectile-mode-line "Projectile")
		 (setq projectile-track-known-projects-automatically nil)))

(use-package counsel-projectile
  :ensure t
  :after (projectile)
  :init (counsel-projectile-mode))

(use-package dashboard
  :ensure t
  ;:after (projectile)
  :config (progn (setq dashboard-startup-banner 'official)
		 (setq dashboard-items '((recents . 5)
					 (bookmarks . 5)
					 (projects . 10)))
		 (dashboard-setup-startup-hook)))

(use-package highlight-symbol
  :ensure t
  :init (highlight-symbol-mode)
  :bind (("<f3>" . highlight-symbol)))

(use-package rainbow-delimiters
  :ensure t
  :hook ((prog-mode . rainbow-delimiters-mode)))

;; SLIME configuration
(load (expand-file-name "~/.roswell/helper.el"))
(setq inferior-lisp-program "ros -Q run")
(slime-setup '(slime-fancy slime-quicklisp slime-asdf))

;; Packages for Common Lisp
(use-package paredit
  :ensure t
  :commands (enable-paredit-mode)
  :init (progn (mapc
		        (lambda (mode)
		          (add-hook mode #'enable-paredit-mode))
		        '(emacs-lisp-mode-hook
		          eval-expression-minibuffer-setup-hook
		          ielm-mode-hook
		          lisp-mode-hook
		          lisp-interaction-mode-hook
		          scheme-mode-hook))
	           (add-hook 'slime-repl-mode-hook
			             (lambda () (paredit-mode +1)))))

;; Configuration for LaTeX editing
(setq doc-view-continuous t)

(use-package tex
  :ensure auctex
  :config (progn (setq TeX-electric-math (cons "$" "$"))
                 (setq LaTeX-electric-left-right-brace t)
                 (setq-default TeX-engine 'xetex)
                 (setq font-latex-fontify-sectioning 'color))
  :init (progn (add-hook 'LaTeX-mode-hook (lambda ()
                                            (TeX-global-PDF-mode t)
                                            (define-key LaTeX-mode-map (kbd "TAB") 'TeX-complete-symbol)))))

(use-package company-auctex
  :ensure t
  :config (company-auctex-init))

(require 'doc-view)
(setq doc-view-resolution 288)

;; C++
(use-package lsp-mode :ensure t
  :config (define-key lsp-mode-map (kbd "C-c l") lsp-command-map))
(use-package yasnippet :ensure t)
(use-package lsp-treemacs :ensure t)
(use-package helm-lsp :ensure t)
(use-package hydra :ensure t)
(use-package flycheck :ensure t)
(use-package company :ensure t)
(use-package which-key :ensure t
  :config (which-key-mode))
(use-package helm-xref :ensure t
  :config (progn
            (define-key global-map [remap find-file] #'helm-find-files)
            (define-key global-map [remap execute-extended-command] #'helm-M-x)
            (define-key global-map [remap switch-to-buffer] #'helm-mini)))
(use-package helm :ensure t :config (helm-mode))
(use-package dap-mode :ensure t)
(add-hook 'c-mode-hook 'lsp)
(add-hook 'c++-mode-hook 'lsp)

(with-eval-after-load 'lsp-mode
  (add-hook 'lsp-mode-hook #'lsp-enable-which-key-integration)
  (require 'dap-cpptools)
  (yas-global-mode))

(provide 'init)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(display-line-numbers-type 'relative)
 '(global-display-line-numbers-mode t)
 '(package-selected-packages
   '(use-package undo-tree slime rainbow-delimiters paredit mwim marginalia highlight-symbol dashboard counsel-projectile company-auctex amx ace-window)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
