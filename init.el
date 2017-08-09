;;; package --- Emacs configuration with batteries included

;;; ----------------------------------------------------------------------------
;;; Commentary:

;;; ----------------------------------------------------------------------------
;;; Code:

;; -----------------------------------------------------------------------------
;;  Package repositories

;; Use MELPA repisitory for download packages
(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))

;; Downloads new packages in case of a fresh install
(package-initialize)

(if (not (package-installed-p 'use-package))
    (progn
      (package-refresh-contents)
      (package-install 'use-package)))

(require 'use-package)

;; -----------------------------------------------------------------------------
;; Custom set variable

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("a4c9e536d86666d4494ef7f43c84807162d9bd29b0dfd39bdf2c3d845dcc7b2e" default)))
 '(package-selected-packages
   (quote
    (move-dup powerline company ng2-mode helm-projectile flycheck projectile multiple-cursors helm use-package))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; -----------------------------------------------------------------------------
;; Setup color theme and window

;; Set the default font
(cond
 ((find-font (font-spec :name "Noto Mono"))
  (set-frame-font "Noto Mono-11"))
 ((find-font (font-spec :name "DejaVu Sans Mono"))
  (set-frame-font "DejaVu Sans Mono-11"))
 ((find-font (font-spec :name "Lucida Console"))
  (set-frame-font "Lucida Console-11"))
)

;; Load theme
(use-package atom-one-dark-theme
  :ensure t
  :init (load-theme 'atom-one-dark))

;; Basic settings
(toggle-frame-maximized)          ;; Start with maximized frame
(setq inhibit-startup-message t)  ;; No more Emacs splash screen
(tool-bar-mode -1)                ;; Disable toolbar on top
;; (menu-bar-mode -1)             ;; Uncomment to disable menu bar on top
(scroll-bar-mode -1)              ;; No more scrollbars
(blink-cursor-mode t)             ;; Blink cursor
(setq-default cursor-type 'bar)   ;; Cursor like a bar
(set-cursor-color "#ffffff")      ;; Color white
(global-hl-line-mode)             ;; Hightlight current line

;; Add line numbers to the right
(require 'linum)
(global-linum-mode 1)
(setq linum-format " %d ")

;; Show parenthesis
(require 'paren)
(set-face-background 'show-paren-match (face-background 'default))
(set-face-foreground 'show-paren-match "#def")
(set-face-attribute 'show-paren-match nil :weight 'extra-bold)
(show-paren-mode 1)

;; Makes *scratch* empty.
(setq initial-scratch-message "")
;; Initial minibuffer message
(defun display-startup-echo-area-message ()
  "Overwrite default startup message."
  (message ""))

;; Slip window in vertical
(split-window-horizontally)

;; Removes *messages* from the buffer list.
(setq-default message-log-max nil)
(kill-buffer "*Messages*")

;; Removes *Completions* from buffer after you've opened a file.
(add-hook 'minibuffer-exit-hook
      '(lambda ()
         (let ((buffer "*Completions*"))
           (and (get-buffer buffer)
                (kill-buffer buffer)))))

;; Don't show *Buffer list* when opening multiple files at the same time.
(setq inhibit-startup-buffer-menu t)

;; Show completion in a separate window
(add-to-list 'special-display-buffer-names '("*Completions*" my-display-completions))

(defun my-display-completions (buf)
  "Put the buffer on the right of the frame.  BUF is the buffer."
  (let ((windows (delete (minibuffer-window) (window-list))))
    (if (eq 1 (length windows))
        (progn
          (select-window (car windows))
          (split-window-horizontally)))
    (let ((target-window (window-at (- (frame-width) 2) 0))
          (pop-up-windows t))
      (set-window-buffer target-window buf)
      target-window)))

;; Change mode line
(use-package powerline
  :ensure t
  :init
  )
(powerline-center-theme)

;; -----------------------------------------------------------------------------
;;  Editing (and movement between files)

;; Setup Ctrl-C, Ctrl-V, Ctrl-X like Windows
(cua-mode t)

;; Standard Windows behaviour
(setq cua-keep-region-after-copy t)

;; Don't tabify after rectangle commands
(setq cua-auto-tabify-rectangles nil)

;; Typed text deletes selected text
(delete-selection-mode t)

;; No region when it is not highlighted
(transient-mark-mode 1)

;; Delete trailing whitespace when save
;; Show trailing whitespaces, tabs, lines
(use-package whitespace
  :ensure t
  :init
  )
(global-whitespace-mode t)
(setq whitespace-style '(face empty tabs lines-tail trailing))

(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; Do not indent using tab
(setq-default indent-tabs-mode nil)

;; Do not create *~ backup files
(setq make-backup-files nil)

;; No more typing the whole yes or no. Just y or n will do.
(fset 'yes-or-no-p 'y-or-n-p)

;; Setup multiple cursors. With this package you can have multiple cursors
;; and type the same data into multiple positions at the same time
;; Ctrl-D is used by Emacs su we unset it before binding.

(global-unset-key (kbd "C-d"))
(use-package multiple-cursors
  :ensure t
  :init
  :bind (("M-S-<down>" . mc/mark-next-like-this)
         ("M-S-<up>" . mc/mark-previous-like-this)
         ("S-C-d" . mc/mark-all-symbols-like-this)
         ("C-d" . mc/mark-all-symbols-like-this-in-defun))
  )

;; In C++ mode the Ctrl-D is reactivated: force unset.
(defun my-disable-ctrl-d ()
  "Disable Ctrl-D"
  (local-unset-key (kbd "C-d"))
  )
(add-hook 'c++-mode-hook 'my-disable-ctrl-d)

(use-package move-dup
  :ensure t
  :init (global-move-dup-mode)
  )

;; ----------------------------------------------------------------------------
;;  Advanced: incremental completion (Support for AngularJS 2+)

(use-package ng2-mode
  :ensure t
  :init
  )

;; ----------------------------------------------------------------------------
;;  Advanced: incremental completion (Helm)

(global-unset-key (kbd "C-o"))
(global-unset-key (kbd "C-j"))

(use-package helm
  :ensure t
  :init
  :bind (("C-<tab>" . helm-multi-files)
         ("C-o" . helm-find-files)
         ("C-x C-f" . helm-find-files)
         ("C-j" . helm-imenu)
         ("S-C-j" . helm-occur)
         ("M-x" . helm-M-x))
  )

(add-to-list 'special-display-buffer-names '("*helm buffers*" my-display-completions))
(add-to-list 'special-display-buffer-names '("*helm multi files*" my-display-completions))
(add-to-list 'special-display-buffer-names '("*helm find files*" my-display-completions))

;; ----------------------------------------------------------------------------
;;  Advanced: incremental completion (Projectile)

(use-package projectile
  :ensure t
  :init (projectile-mode)
  )

(use-package helm-projectile
  :ensure t
  :init (helm-projectile-on)
  :bind (("C-p" . helm-projectile-find-file-dwim)
         ("S-C-o" . helm-projectile-switch-project)
         ("S-C-f" . helm-projectile-grep))
  )

;; ----------------------------------------------------------------------------
;;  Advanced: incremental completion (Flycheck)

(use-package flycheck
  :ensure t
  :init
  )
(add-hook 'after-init-hook #'global-flycheck-mode)

;; -----------------------------------------------------------------------------
;;  Advanced: autocomplete framework (Company)

(use-package company
  :ensure t
  :init
  )

;;(require 'company)
(add-hook 'after-init-hook 'global-company-mode)
;; Use Ctrl-<space> for completion
(global-set-key (kbd "C-SPC") 'company-complete)

;; Use clang for backends
(setq company-backends (delete 'company-semantic company-backends))
(add-to-list 'company-backends 'company-web-html)
(add-to-list 'company-backends 'company-web-jade)
(add-to-list 'company-backends 'company-web-slim)
(add-to-list 'company-backends 'company-c-headers)

;; ----------------------------------------------------------------------------
;;  Keybindings

;; Compile Project
(global-set-key (kbd "<f5>") 'projectile-compile-project)

;; Show flycheck errors
(global-set-key (kbd "<f8>") 'flycheck-list-errors)

(defun save-all ()
  "Save buffer without confirmation."
  (interactive) (save-some-buffers t))

;; Ctrl-S: save current file
;; Shift-Ctrl-S: save all files without confirmation
(global-unset-key (kbd "C-s"))
(global-set-key (kbd "C-s") 'save-buffer)
(global-unset-key (kbd "S-C-s"))
(global-set-key (kbd "S-C-s") 'save-all)

;; Change Search and Replace keys
(global-unset-key "\C-f")
(global-set-key (kbd "\C-f") 'isearch-forward)
(define-key isearch-mode-map "\C-f" 'isearch-repeat-forward)

;; Switch from .c/.h and vicevarsa
(global-set-key (kbd "C-S-a") 'ff-find-other-file)

;; Move between buffers
(global-set-key (kbd "M-<right>") 'next-buffer)
(global-set-key (kbd "M-<left>") 'previous-buffer)

;; Close current buffer and window
(global-set-key (kbd "C-w") 'kill-this-buffer)
(global-set-key (kbd "<C-iso-lefttab>") 'other-window)

;; ----------------------------------------------------------------------------

(provide 'init)
;;; init.el ends here
