(require 'cl)

(when (>= emacs-major-version 24)
  ;;(require 'package)
  ;;(package-initialize)
  ;;(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
  ;;(add-to-list 'package-archives '("melpa" . "https://elpa.popkit.org/packages/") t)
  (add-to-list 'package-archives
            '("popkit" . "https://elpa.popkit.org/packages/"))
  )

;;add whatever packages you want here
(defvar edge/packages '(
			company
			monokai-theme
			hungry-delete
			swiper
			counsel
			smartparens
			js2-mode
			popwin
			reveal-in-osx-finder
			;;js2-refactor
			web-mode
			expand-region
			iedit
			org-pomodoro
			) "Default packages")

(setq package-selected-packages edge/packages)

(defun edge/packages-installed-p ()
  (loop for pkg in edge/packages
	when (not (package-installed-p pkg)) do (return nil)
	finally (return t)))

(unless (edge/packages-installed-p)
  (message "%s" "Refreshing package database...")
  (package-refresh-contents)
  (dolist (pkg edge/packages)
    (when (not (package-installed-p pkg))
      (package-install pkg))))

(global-hungry-delete-mode t)

;;(add-hook 'emacs-lisp-mode-hook 'smartparens-mode)
(smartparens-global-mode t)
(sp-local-pair 'emacs-lisp-mode "'" nil :actions nil)

(ivy-mode 1)
(setq ivy-use-virtual-buffers t)

;;config js2-mode for js file
(setq auto-mode-alist
      (append
       '(("\\.js\\'" . js2-mode)
	 ("\\.html\\'" . web-mode)
	 )
       auto-mode-alist))

(global-company-mode t)

;;config for web mode
(defun my-web-mode-indent-setup ()
  (setq web-mode-markup-indent-offset 2)
  (setq web-mode-css-indent-offset 2)
  (setq web-mode-code-indent-offset 2)
  )

(add-hook 'web-mode-hook 'my-web-mode-indent-setup)

(defun my-toggle-web-indent ()
  (interactive)
  ;;web development
  (if (or (eq major-mode 'js-mode) (eq major-mode 'js2-mode))
      (progn
	(setq js-indent-level (if (= js-indent-level 2) 4 2))
	(setq js2-basic-offset (if (= js2-basic-offset 2) 4 2))))

  (if (eq major-mode 'web-mode)
      (progn (setq web-mode-markup-indent-offset (if (= web-mode-markup-indent-offset 2) 4 2))
	     (setq web-mode-css-indent-offset (if (= web-mode-css-indent-offset 2) 4 2))
	     (setq web-mode-code-indent-offset (if (= web-mode-code-indent-offset 2) 4 2))))
  (if (eq major-mode 'css-mode)
      (setq css-indent-offset (if (= css-indent-offset 2) 4 2)))
  
  (setq indent-tabs-mode nil))

(defun js2-imenu-make-index ()
  (interactive)
  (save-excursion
    ;;(setq imenu-generic-expression '((nil "describe\\(\"\\(.+\\)\"" 1)))
    (imenu--generic-function '(("describe" "\\s-*describe\\s-*(\\s-*[\"']\\(.+\\)[\"']\\s-*,.*" 1)
			       ("it" "\\s-*it\\s-*(\\s-*[\"']\\(.+\\)[\"']\\s-*,.*" 1)
			       ("test" "\\s-*test\\s-*[\\s-*[\"']\\(.+\\)[\"']\\s-*,.*" 1)
			       ("before" "\\s-*before\\s-*[\\s-*[\"']\\(.+\\)[\"']\\s-*,.*" 1)
			       ("after" "\\s-*after\\s-*[\\s-*[\"']\\(.+\\)[\"']\\s-*,.*" 1)
			       ("Function" "function[ \t]+\\([a-zA-Z0-9_$.]+\\)[ \t]*(" 1)
			       ("Function" "^[ \t]+\\([a-zA-Z0-9_$.]+\\)[ \t]*=[ \t]*function[ \t]*(" 1)
			       ("Function" "^var[ \t]+\\([a-zA-Z0-9_$.]+\\)[ \t]*=[ \t]*function[ \t]*(" 1)
			       ("Function" "^[ \t]+\\([a-zA-Z0-9_$.]+\\)[ \t]*()[ \t]*(" 1)
			       ("Function" "^[ \t]+\\([a-zA-Z0-9_$.]+\\)[ \t]*:[ \t]*function[ \t]*(" 1)
			       ("Task" "[. \t]task([ \t]*['\"]\\([^'\"]+\\))" 1)))))
(add-hook 'js2-mode-hook
	  (lambda ()
	    (setq imenu-create-index-function 'js2-imenu-make-index)))

(load-theme 'monokai t)

(require 'popwin)
;;when require, wh(setq company-minimum-prefix-length 1)en not require
(popwin-mode t)

(require 'org-pomodoro)

(provide 'init-packages)
