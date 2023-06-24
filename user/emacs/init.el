;; Disable startup screen
(setq inhibit-startup-message t)

;; Disable UI elements
(scroll-bar-mode -1) ; Disable scrollbar
(tool-bar-mode -1) ; Disable tool bar
(tooltip-mode -1) ; Disable tooltips
(set-fringe-mode 10) ; Set fringe width
(menu-bar-mode -1) ; Disable menu bar

;; Enable visual bell
(setq visible-bell t)

;; Enable line numbers
(column-number-mode)
(add-hook 'prog-mode-hook 'display-line-numbers-mode)

;; ESC quits prompts
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

;; Font configuration
(set-face-attribute 'default nil :font "Hack Nerd Font" :height 140)

;; Stop *Warning buffer* popping up for native compilation warnings & errors
(setq native-comp-async-report-warnings-errors 'silent)

;; Put custom set variables in separate file
(setq-default custom-file (expand-file-name "custom.el" user-emacs-directory))
(when (file-exists-p custom-file)
  (load custom-file))

;; Initialise Package
(require 'package)
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
			 ("elpa" . "https://elpa.gnu.org/packages/")))
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

;; Bootstrap use-package
(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)
(use-package diminish) ; Needed for :diminish in use-package

;; Use Counsel and Ivy for completion
(use-package ivy
  :diminish
  :bind
  (("C-s" . swiper)
   :map ivy-minibuffer-map
   ("TAB" . ivy-alt-done)
   ("C-l" . ivy-alt-done)
   ("C-j" . ivy-next-line)
   ("C-k" . ivy-previous-line)
   :map ivy-switch-buffer-map
   ("C-k" . ivy-previous-line)
   ("C-l" . ivy-done)
   ("C-d" . ivy-switch-buffer-kill)
   :map ivy-reverse-i-search-map
   ("C-k" . ivy-previous-line)
   ("C-d" . ivy-reverse-i-search-kill))
  :config
  (ivy-mode 1))

(use-package counsel
  :bind
  (("M-x" . counsel-M-x)
   ("C-x b" . counsel-ibuffer)
   ("C-x C-f" . counsel-find-file)
   :map minibuffer-local-map
   ("C-r" . 'counsel-minibuffer-history))
  :config
  (setq ivy-initial-inputs-alist nil))

(use-package ivy-rich
  :init
  (ivy-rich-mode 1))

;; Rainbow delimiters
(use-package rainbow-delimiters
  :hook (emacs-lisp-mode . rainbow-delimiters-mode))

;; Which key
(use-package which-key
  :diminish which-key-mode
  :init
  (which-key-mode)
  :config
  (setq which-key-idle-delay 0.5))

;; Better help buffer
(use-package helpful
  :custom
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-variable-function #'helpful-variable)
  :bind
  ([remap describe-command] . helpful-command)
  ([remap describe-key] . helpful-key)
  ([remap describe-function] . counsel-describe-function)
  ([remap describe-variable] . counsel-describe-variable))

;; Doom packages
(use-package doom-themes
  :config
  (setq doom-themes-enable-bold t
	doom-themes-enable-italic t)
  (load-theme 'doom-spacegrey t)
  (doom-themes-visual-bell-config)
  (doom-themes-org-config))
(use-package doom-modeline
  :init
  (doom-modeline-mode 1))

;; Projectile
(use-package projectile
  :diminish projectile-mode
  :config
  (projectile-mode)
  :custom
  (projectile-completion-system 'ivy)
  :bind-keymap
  ("C-c p" . projectile-command-map)
  :init
  (when (file-directory-p "~/Documents/git")
    (setq projectile-project-search-path '("~/Documents/git")))
  (setq projectile-switch-project-action #'projectile-dired))

(use-package counsel-projectile
  :config
  (counsel-projectile-mode))

;; Git
(use-package magit
  :custom
  (magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1))

;; Nix mode
(use-package nix-mode
  :mode "\\.nix\\'")
