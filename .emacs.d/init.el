;; straight.el package bootstrap
(defvar bootstrap-version)
(let ((bootstrap-file
        (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
          "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
          'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

;; use-package init
(straight-use-package 'use-package)

;; Package List
(use-package doom-themes
  :straight t
  :config
  (load-theme 'doom-city-lights t)
  (doom-themes-org-config))
(use-package evil-surround
  :straight t
  :config
  (global-evil-surround-mode 1))
(use-package evil-leader
  :straight t
  :config
  (global-evil-leader-mode)
  (evil-leader/set-leader "<SPC>"))
(use-package evil
  :straight t
  :config
  (evil-mode 1))
(use-package telephone-line
  :straight t
  :config
  (telephone-line-mode 1))
(use-package ivy
  :straight t
  :config
  (ivy-mode 1)
  (setq ivy-use-virtual-buffers t)
  (setq enable-recursive-minibuffers t))
(use-package counsel
  :straight t
  :config
  (global-set-key (kbd "M-x") 'counsel-M-x))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(blink-cursor-mode nil)
 '(custom-enabled-themes '(doom-city-lights))
 '(custom-safe-themes
   '("054f5e4c4a933cf760b418be95da472105fbdd2146c93f49d066352246d2e812" "d71aabbbd692b54b6263bfe016607f93553ea214bc1435d17de98894a5c3a086" default))
 '(display-line-numbers t)
 '(evil-echo-state nil)
 '(evil-split-window-below t)
 '(evil-vsplit-window-right t)
 '(evil-want-C-u-scroll t)
 '(menu-bar-mode nil)
 '(package-archives
   '(("gnu" . "https://elpa.gnu.org/packages/")
     ("melpa" . "https://melpa.org/packages/")))
 '(package-selected-packages '(doom-themes))
 '(ring-bell-function 'ignore)
 '(scroll-bar-mode nil)
 '(telephone-line-primary-left-separator 'telephone-line-identity-left)
 '(telephone-line-primary-right-separator 'telephone-line-identity-right)
 '(tool-bar-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:weight normal :height 110 :width normal :family "JetBrains Mono"))))
 '(cursor ((t (:background "gray"))))
 '(telephone-line-evil-emacs ((t (:background "#94f3fc" :foreground "#34939c" :weight bold))))
 '(telephone-line-evil-insert ((t (:background "#94f3fc" :foreground "#34939c" :weight bold))))
 '(telephone-line-evil-motion ((t (:background "#dfff00" :foreground "#225f22" :weight bold))))
 '(telephone-line-evil-normal ((t (:background "#dfff00" :foreground "#225f22" :weight bold))))
 '(telephone-line-evil-operator ((t (:background "#dfff00" :foreground "#225f22" :weight bold))))
 '(telephone-line-evil-replace ((t (:background "#af0000" :foreground "#ffffff" :weight bold))))
 '(telephone-line-evil-visual ((t (:background "#ffaf00" :foreground "#000000" :weight bold)))))
