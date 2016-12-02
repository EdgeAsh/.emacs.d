(require 'cl)

(when (>= emacs-major-version 24)
  ;;(require 'package)
  ;;(package-initialize)
  (add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t)
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


(ivy-mode 1)
(setq ivy-use-virtual-buffers t)

;;config js2-mode for js file
(setq auto-mode-alist
      (append
       '(("\\.js\\'" . js2-mode))
       auto-mode-alist))

(global-company-mode t)

(load-theme 'monokai t)

(require 'popwin)
;;when require, wh(setq company-minimum-prefix-length 1)en not require
(popwin-mode t)

(provide 'init-packages)
