#!/usr/bin/env bash

dconf load / << EOF
[desktop/ibus/general]
engines-order=['xkb:us::eng', 'pinyin', 'anthy']
preload-engines=['xkb:us::eng', 'pinyin', 'anthy']
version='1.5.28'

[desktop/ibus/general/hotkey]
triggers=['<Control>space']

[org/cinnamon]
enabled-applets=['panel1:left:0:menu@cinnamon.org:0', 'panel1:left:1:separator@cinnamon.org:1', 'panel1:left:2:grouped-window-list@cinnamon.org:2', 'panel1:right:0:systray@cinnamon.org:3', 'panel1:right:1:xapp-status@cinnamon.org:4', 'panel1:right:2:notifications@cinnamon.org:5', 'panel1:right:3:printers@cinnamon.org:6', 'panel1:right:4:removable-drives@cinnamon.org:7', 'panel1:right:5:keyboard@cinnamon.org:8', 'panel1:right:6:favorites@cinnamon.org:9', 'panel1:right:7:network@cinnamon.org:10', 'panel1:right:8:sound@cinnamon.org:11', 'panel1:right:9:power@cinnamon.org:12', 'panel1:right:10:calendar@cinnamon.org:13', 'panel1:right:11:cornerbar@cinnamon.org:14']
next-applet-id=15

[org/cinnamon/desktop/interface]
font-name='Noto Sans CJK SC 9'
text-scaling-factor=1.0

[org/cinnamon/desktop/sound]
event-sounds=false

[org/cinnamon/desktop/wm/preferences]
titlebar-font='Noto Sans CJK SC Bold 10'

[org/gnome/desktop/a11y/applications]
screen-keyboard-enabled=false
screen-reader-enabled=false

[org/cinnamon/desktop/background]
picture-uri='file:///mnt/nas/pictures/cinnamoroll.webp'

[org/gnome/desktop/a11y/mouse]
dwell-click-enabled=false
dwell-threshold=10
dwell-time=1.2
secondary-click-enabled=false
secondary-click-time=1.2

[org/gnome/desktop/interface]
document-font-name='Noto Sans CJK SC 11'
monospace-font-name='Sarasa Mono SC 10'
toolkit-accessibility=false

[org/gnome/terminal/legacy/profiles:/:b1dcc9dd-5262-4d8d-a863-c897e6d979b9]
use-system-font=false

[org/nemo/window-state]
sidebar-bookmark-breakpoint=0
start-with-sidebar=true
EOF

mkdir -p ~/.config/Code/User/
cat << EOF > ~/.config/Code/User/settings.json
{
    "workbench.colorTheme": "Default Light+",
    "C_Cpp.default.compilerPath": "/usr/bin/g++",
    "files.autoSave": "afterDelay",
    "editor.fontFamily": "'Sarasa Mono SC', 'Droid Sans Mono', 'monospace', monospace",
    "C_Cpp.clang_format_fallbackStyle": "{ BasedOnStyle: Google, UseTab: Never, IndentWidth: 4, TabWidth: 4 }",
    "C_Cpp.clang_format_style": "{ BasedOnStyle: Google, UseTab: Never, IndentWidth: 4, TabWidth: 4 }",
    "C_Cpp.default.cppStandard": "c++23",
    "C_Cpp.default.cStandard": "c23"
}
EOF

cat << EOF > ~/.emacs
(setq visible-bell 1)			                          ; disable ringing for C-g and such
(setq gc-cons-threshold (* 256 1024 1024))               ; to accelerate boot?	
(defconst *spell-check-support-enabled* t)
(electric-pair-mode t)		                              ; automatically pair parentheses
(add-hook 'prog-mode-hook #'show-paren-mode)              ; highlight pairing parentheses
(global-auto-revert-mode t)	                              ; automatically refresh on file change
(delete-selection-mode t)	                              ; replace marked text when typing
(setq make-backup-files nil)
(setq auto-save-default t)
(add-hook 'prog-mode-hook #'hs-minor-mode)                ; enable folding
(global-display-line-numbers-mode 1)
(setq display-line-numbers-type 'relative)
(fset 'yes-or-no-p 'y-or-n-p)
(load-theme 'leuven t)

(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)

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

(use-package paredit
             :ensure t
             :commands (enable-paredit-mode)
             :init (progn (mapc
                           (lambda (mode)
                             (add-hook mode #'enable-paredit-mode))
                           '(emacs-lisp-mode-hook
                             lisp-interaction-mode-hook
                             scheme-mode-hook))
                          (add-hook 'slime-repl-mode-hook
                                    (lambda () (paredit-mode +1)))))

(use-package geiser-chez :ensure t)
(setq geiser-chez-binary "/usr/bin/chez")

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

(use-package clang-format :ensure t)
(setq clang-format-style "file")
(setq clang-format-fallback-style "{ BasedOnStyle: Google, IndentWidth: 4 }")

(provide 'init)
EOF
