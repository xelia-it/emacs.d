;;; .emacs.d --- Emacs configuration with batteries included

;;; ----------------------------------------------------------------------------
;;; Commentary:
;;;

;;; ----------------------------------------------------------------------------
;;; Code:

;; -----------------------------------------------------------------------------
;; Language: HTML/CSS/Javascript

(use-package web-mode
  :ensure t
  :defer t
  :mode (
         ("\\.html?\\'" . web-mode)
         ("\\.erb\\'" . web-mode)
         ("\\.handlebars\\'" . web-mode)
         ("\\.mustache\\'" . web-mode)
         )
  :config
  ;; Configuration
  (setq web-mode-enable-auto-pairing t)
  (setq web-mode-enable-css-colorization t)
  (setq web-mode-enable-block-face t)
  (setq web-mode-enable-part-face t)
  (setq web-mode-enable-heredoc-fontification t)
  (setq web-mode-enable-current-element-highlight t)
  (setq web-mode-enable-current-column-highlight t)
  (setq web-mode-markup-indent-offset 2)

  ;; Configure face
  (set-face-attribute 'web-mode-block-face nil :background nil)
  (set-face-attribute 'web-mode-inlay-face nil :background nil)
  (set-face-attribute 'web-mode-current-column-highlight-face nil
                      :foreground "#ffffff" :background nil)
  (set-face-attribute 'web-mode-current-element-highlight-face nil
                      :foreground "#ffffff" :background nil :weight 'extra-bold)
  )

(use-package js2-mode
  :ensure t
  :defer t
  :mode (
         ("\\.js?\\'" . js2-mode)
         )
  )

(use-package impatient-mode
  :ensure t
  :defer t
  :bind (
         ("C-S-i" . impatient-mode)
         )
  :config

  (defun my-open-impatient-modes()
    "Open Impatient Mode Window."
    (call-process "firefox" nil 0 nil "-new-tab"  "http://localhost:8080/imp/")
   )
  )

(use-package emmet-mode
  :ensure t
  :defer t
  :hook (
         (web-mode . emmet-mode)
         (sgml-mode . emmet-mode)
         (css-mode . emmet-mode)
         )
  )

;; -----------------------------------------------------------------------------
;; Language: Ruby

(use-package projectile-rails
  :ensure t
  ;;:defer t
  :after (helm projectile)
  :hook (prog-mode . projectile-rails-mode)
  )

;; ------------------------------------------------------------------------------
;; Language: C++

;; -----------------------------------------------------------------------------
;; Language: Python

;;(use-package company-jedi
;;  :ensure t
;;  :defer t
;;  :config
;;
;;  (defun my/python-mode-hook ()
;;    (add-to-list 'company-backends 'company-jedi))
;;
;;  (add-hook 'python-mode-hook 'my/python-mode-hook)
;;  )

;; -----------------------------------------------------------------------------
;; Language: Angular

;;(use-package tide
;;  :ensure t
;;  :defer t
;;  :after (company)
;;  :config
;;
;;  (defun setup-tide-mode ()
;;    "Main configuraton for using tide for Typescrypt autocomplete."
;;    (interactive)
;;    (tide-setup)
;;    (flycheck-mode +1)
;;    (setq flycheck-check-syntax-automatically '(save mode-enabled))
;;    (eldoc-mode +1)
;;    (tide-hl-identifier-mode +1)
;;    ;; company is an optional dependency. You have to
;;    ;; install it separately via package-install
;;    ;; `M-x package-install [ret] company`
;;    (company-mode +1)
;;    (message "Tide setup complete")
;;    )
;;
;;  ;; aligns annotation to the right hand side
;;  (setq company-tooltip-align-annotations t)
;;
;;  ;; formats the buffer before saving
;;  (add-hook 'before-save-hook 'tide-format-before-save)
;;
;;  (add-hook 'typescript-mode-hook #'setup-tide-mode)
;;
;;  ;; Web mode with Angular
;;  ;; (require 'web-mode)
;;  ;; (add-to-list 'auto-mode-alist '("\\.tsx\\'" . web-mode))
;;  ;; (add-hook 'web-mode-hook
;;  ;;           (lambda ()
;;  ;;             (when (string-equal "tsx" (file-name-extension buffer-file-name))
;;  ;;               (setup-tide-mode))))
;;  ;; ;; enable typescript-tslint checker
;;  ;; (flycheck-add-mode 'typescript-tslint 'web-mode)
;;  (message "Config tide completed")
;;  )

;; -----------------------------------------------------------------------------
;; Language: YAML

(use-package yaml-mode
  :ensure t
  :defer t
  :config

  ;; TODO: can be used :hook from use-package?
  (require 'yaml-mode)
  (add-to-list 'auto-mode-alist '("\\.yml\\'" . yaml-mode))
   ;;(add-hook 'yaml-mode-hook
   ;; '(lambda ()
   ;;    (define-key yaml-mode-map "\C-m" 'newline-and-indent)))
  )

;; -----------------------------------------------------------------------------
;; Language: JSON

(use-package json-mode
  :ensure t
  :defer t
  :mode ("\\.json\\'" . json-mode)
  )

;; -----------------------------------------------------------------------------
;; Language: Markdown

(use-package markdown-mode
  :ensure t
  :defer t
  :commands (markdown-mode gfm-mode)
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :init
  (setq markdown-command "multimarkdown")
  )

;; -----------------------------------------------------------------------------
;; Language: Nginx config files

(use-package nginx-mode
  :ensure t
  :defer t
  :mode ("\\.nginx\\'" . nginx-mode)
  )

;; -----------------------------------------------------------------------------
;; Language: Kivy files

(use-package kivy-mode
  :ensure t
  :defer t
  :mode ("\\.kv\\'" . kivy-mode)
  )

(provide 'init-languages)
;;; init-languages.el ends here
