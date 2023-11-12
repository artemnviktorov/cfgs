;;; package --- my emacs config
;;; Commentary:
;;; Code:

(setq user-full-name "Artem Viktorov"
      user-mail-address "artemnv@gmail.com")

(setq gc-cons-threshold 67108864) ;; 64 mb
(setq large-file-warning-threshold 4294967296) ;; 4 gb

(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)

(toggle-scroll-bar 0)
(tool-bar-mode 0)
(blink-cursor-mode 0)

(setq visible-bell t)

(global-display-line-numbers-mode 1)
(setq display-line-numbers 'relative)
(column-number-mode 1)
(size-indication-mode 1)

(setq inhibit-startup-screen t)

(setq frame-title-format
      '((:eval (if (buffer-file-name)
       (abbreviate-file-name (buffer-file-name))
       "%b"))))

(setq scroll-margin 0
      scroll-conservatively 100000
      scroll-preserve-screen-position 1)

(set-frame-font "Cascadia Code 10" nil t)

(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))

(fset 'yes-or-no-p 'y-or-n-p)

(global-auto-revert-mode 1)

(setq-default tab-width 4
              indent-tabs-mode nil)

(global-set-key (kbd "C-x k") 'kill-this-buffer)

(add-hook 'before-save-hook 'whitespace-cleanup)

(cua-mode 1)
(electric-pair-mode 1)
(show-paren-mode 1)

(setq-default c-basic-offset 4
              c-default-style "ellemtel")

(require 'package)
(setq package-enable-at-startup nil)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/"))
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile
  (require 'use-package))

(use-package diminish
  :ensure t)

(use-package which-key
  :ensure t
  :diminish which-key-mode
  :config
  (which-key-mode 1))

(use-package company
  :ensure t
  :diminish company-mode
  :config
  (add-hook 'after-init-hook #'global-company-mode))

(use-package flycheck
  :ensure t
  :diminish flycheck-mode
  :config
  (add-hook 'after-init-hook #'global-flycheck-mode))

(use-package magit
  :ensure t)

(use-package projectile
  :ensure t
  :diminish projectile-mode
  :bind
  (("C-c p f" . helm-projectile-find-file)
   ("C-c p p" . helm-projectile-switch-project)
   ("C-c p s" . projectile-save-project-buffers))
  :config
  (projectile-mode 1)
  (setq projectile-enable-caching t)
  (setq projectile-indexing-method 'git))

(use-package helm
  :ensure t
  :diminish helm-mode
  :defer 2
  :bind
  ("M-x" . helm-M-x)
  ("C-x C-f" . helm-find-files)
  ("M-y" . helm-show-kill-ring)
  ("C-x b" . helm-mini)
  :config
  (helm-mode 1)
  (setq helm-split-window-inside-p t
    helm-move-to-line-cycle-in-source t)
  (setq helm-autoresize-max-height 0)
  (setq helm-autoresize-min-height 20)
  (helm-autoresize-mode 1)
  (define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action) ; rebind tab to run persistent action
  (define-key helm-map (kbd "C-i") 'helm-execute-persistent-action) ; make TAB work in terminal
  (define-key helm-map (kbd "C-z")  'helm-select-action)) ; list actions using C-z

(use-package helm-projectile
  :ensure t
  :config
  (helm-projectile-on))

(use-package ample-theme
  :ensure t
  :config
  (load-theme 'ample-flat-theme))

;;
