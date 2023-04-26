;; Package Sources
(require 'package)

(setq package-archives '(("melpa" . "https://melpa.org/packages/")
	      ("org" . "https://orgmode.org/elpa/")
	      ("elpa" . "https://elpa.gnu.org/packages/")))

(package-initialize)
(package-refresh-contents t)

;; handle non-linux
(unless (package-installed-p 'use-package)
  (package-install 'use-package))
;; Force evil
(unless (package-installed-p 'evil)
  (package-install 'evil))

(require 'use-package)
(setq use-package-always-ensure t)

;; simplify UI
(setq inhibit-startup-message t) ; No startup page

(scroll-bar-mode -1) 		; Disable the scroll bar
(tool-bar-mode -1) 		; Disable the toolbar
(tooltip-mode -1) 		; No tooltips
(set-fringe-mode 10) 		; spaceeeeee
(menu-bar-mode -1) 		; no menu bar

(setq visible-bell t) 		; no beeps on incorrect entry

;; build new UI
;; 	font
(set-face-attribute 'default nil :font "liberation mono" :height 125)

(load-theme 'wombat)

;; 	Line numbers and column in the modeline
(column-number-mode)
(global-display-line-numbers-mode t)

;; 	Disable in non-lined modes
(dolist (mode '(org-mode-hook
		term-mode-hook
		shell-mode-hook
		eshell-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

;;	Rainbow Delimiters
(use-package rainbow-delimiters
	     	:hook (prog-mode . rainbow-delimiters-mode))

;; Make ESC leave prompts
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)



(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(initial-frame-alist '((fullscreen . maximized)))
 '(package-selected-packages
   '(treemacs-evil swiper cmake-mode use-package ivy doom-modeline command-log-mode)))

;; deps
(use-package swiper) ;; for ivy
;; packages
(use-package ivy
	     :diminish
	     :bind (("C-s" . swiper)
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
		    ("C-d" . ivy-reverse-i-serach-kill))
	     :config 
	     (ivy-mode 1))


(use-package all-the-icons) ;; Need to run M-x all-the-icons-fonts 1 time

(use-package doom-modeline
	     :ensure t
	     :init (doom-modeline-mode 1))
(use-package doom-themes
	     :ensure t
	     :config
	     (setq doom-themes-enable-bold t
		   doom-themes-enable-italic t)
	     (load-theme 'doom-gruvbox t)
	     (doom-themes-visual-bell-config)
	     (doom-themes-neotree-config)
	     (doom-themes-org-config))
(use-package which-key
	     :init (which-key-mode)
	     :diminish which-key-mode
	     :config
	     (setq which-key-idle-delay 0.15))
(use-package ivy-rich
	     :init
	     (ivy-rich-mode 1))
(use-package counsel
	     :bind (("M-x" . counsel-M-x)
		    ("C-x b" . counsel-ibuffer)
		    ("C-x C-f" . counsel-find-file)
		    ("C-M-j" . 'counsel-switch-buffer)
		    :map minibuffer-local-map
		    ("C-r" . 'counsel-minibuffer-history))
	     :config
	     (setq ivy-initial-inputs-alist nil)) ;; don't start searches with ^
(use-package helpful
	     :ensure t
	     :custom 
	     (counsel-describe-function-function #'helpful-callable)
	     (counsel-describe-variable-function #'helpful-variable)
	     :bind
	     ([remap describe-function] . counsel-describe-function)
	     ([remap describe-command] . helpful-command)
	     ([remap describe-variable] . counsel-describe-variable)
	     ([remap describe-key] . helpful-key))
(use-package general
	     :config
	     (general-create-definer rune/leader-keys
				     :keymaps '(normal insert visual emacs)
				     :prefix "SPC"
				     :global-prefix "C-SPC")
	     (rune/leader-keys
	       "t" 	'(:ignore t :which-key "toggles")
	       "tt" 	'(counsel-load-theme :which-key "choose theme")))
(use-package evil
	     :init
	     (setq evil-want-integration t)
	     (setq evil-want-keybinding nil)
	     (setq evil-want-C-u-scroll t)
	     (setq evil-want-C-i-jump nil)
	     :config
	     (evil-mode 1)
	     (define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state)

	     ;; Use visual line motions even outside of visual line mode buffers
	     (evil-global-set-key 'motion "j" 'evil-next-visual-line)
	     (evil-global-set-key 'motion "k" 'evil-previous-visual-line)

	     (evil-set-initial-state 'messages-bugger-mode 'normal)
	     (evil-set-initial-state 'dashboard-mode 'normal))

(use-package evil-collection
  :after evil magit
  :config
  (evil-collection-init))

(use-package hydra)

(use-package projectile
  :diminish projectile-mode
  :config (projectile-mode)
  :bind-keymap
  ("C-c p" . projectile-command-map)
  :init
  (when (file-directory-p "~/Documents/code")
    (setq projectile-project-search-path '("~/Documents/code")))
  (setq projectile-switch-project-action #'projectile-dired))

(use-package counsel-projectile
  :config (counsel-projectile-mode))

(use-package magit)

(defhydra hydra-text-scale (:timeout 4)
  "scale text"
  ("j" text-scale-increase "in")
  ("k" text-scale-decrease "out")
  ("f" nil "finished" :exit t))

(rune/leader-keys
   "ts" '(hydra-text-scale/body :which-key "scale text"))


(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
