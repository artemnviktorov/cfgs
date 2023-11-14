;;; package --- my emacs config
;;; Commentary:
;;; Code:

(setq user-full-name "Artem Viktorov"
      user-mail-address "artemnv@gmail.com")

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
  :config
  (add-hook 'after-init-hook #'global-flycheck-mode))
(add-hook 'c++-mode-hook (lambda () (setq flycheck-gcc-language-standard "c++17")))
(add-hook 'c++-mode-hook (lambda () (setq flycheck-clang-language-standard "c++17")))

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
  (define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action)
  (define-key helm-map (kbd "C-i") 'helm-execute-persistent-action)
  (define-key helm-map (kbd "C-z")  'helm-select-action))

(use-package helm-projectile
  :ensure t
  :config
  (helm-projectile-on))

(use-package irony
  :ensure t
  :config
  (progn
    (unless (irony--find-server-executable) (call-interactively #'irony-install-server))
    (add-hook 'c++-mode-hook 'irony-mode)
    (add-hook 'c-mode-hook 'irony-mode)
    (setq-default irony-cdb-compilation-databases '(irony-cdb-libclang
                                                    irony-cdb-clang-complete))
    (add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options)))

(use-package company-irony
  :ensure t
  :config
  (progn
    (eval-after-load 'company '(add-to-list 'company-backends 'company-irony))))

(use-package flycheck-irony
  :ensure t
  :config
  (progn
    (eval-after-load 'flycheck '(add-hook 'flycheck-mode-hook #'flycheck-irony-setup))))

(use-package irony-eldoc
  :ensure t
  :config
  (progn
    (add-hook 'irony-mode-hook #'irony-eldoc)))

;; Windows performance tweaks
(when (boundp 'w32-pipe-read-delay)
  (setq w32-pipe-read-delay 0))
(when (boundp 'w32-pipe-buffer-size)
  (setq irony-server-w32-pipe-buffer-size (* 128 1024))) ;; 128 kb

(use-package ample-theme
  :ensure t)
(load-theme 'ample-flat t)

(setq gc-cons-threshold 134217728 ;; 128 mb
      large-file-warning-threshold 4294967296 ;; 4 gb
      read-process-output-max 1048576 ;; 1 mb
      company-idle-delay 0.0
      company-minimum-prefix-length 1
      lsp-idle-delay 0.1)

(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)

(toggle-scroll-bar 0)
(tool-bar-mode 0)
(blink-cursor-mode 0)

(setq visible-bell t)

(defvar display-line-numbers-type 'relative)
(global-display-line-numbers-mode 1)

(column-number-mode 1)
(size-indication-mode 1)

(setq inhibit-startup-screen t)

(setq scroll-margin 0
      scroll-conservatively 100000
      scroll-preserve-screen-position 1)

(setq frame-title-format
      '((:eval (if (buffer-file-name)
       (abbreviate-file-name (buffer-file-name))
       "%b"))))

(set-frame-font "Cascadia Code 10" nil t)

(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))

(fset 'yes-or-no-p 'y-or-n-p)

(global-auto-revert-mode 1)

(global-set-key (kbd "C-x k") 'kill-this-buffer)

(add-hook 'before-save-hook 'whitespace-cleanup)

(cua-mode 1)

(electric-pair-mode 1)
(show-paren-mode 1)

(setq-default tab-width 4
              indent-tabs-mode nil
              c-basic-offset 4
              c-default-style "ellemtel")

(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))

;;
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages '(company-lsp flycheck)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
