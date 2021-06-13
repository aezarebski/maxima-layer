;;; packages.el --- maxima layer packages file for Spacemacs.
;;
;; Copyright (c) 2012-2021 Sylvain Benner & Contributors
;;
;; Author: dalanicolai <dalanicolai@daniel-fedora>
;; URL: https://github.com/syl20bnr/spacemacs
;;
;; This file is not part of GNU Emacs.
;;
;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; See the Spacemacs documentation and FAQs for instructions on how to implement
;; a new layer:
;;
;;   SPC h SPC layers RET
;;
;;
;; Briefly, each package to be installed or configured by this layer should be
;; added to `maxima-packages'. Then, for each package PACKAGE:
;;
;; - If PACKAGE is not referenced by any other Spacemacs layer, define a
;;   function `maxima/init-PACKAGE' to load and initialize the package.

;; - Otherwise, PACKAGE is already referenced by another Spacemacs layer, so
;;   define the functions `maxima/pre-init-PACKAGE' and/or
;;   `maxima/post-init-PACKAGE' to customize the package as it is loaded.

;;; Code:

(defconst maxima-packages
  '(
    (maxima :location (recipe
                       :fetcher gitlab
                       :repo "sasanidas/maxima"
                       :files ("*")))
    ;; ob-maxima ; :location built-in
    company-maxima)
  "The list of Lisp packages required by the maxima layer.

Each entry is either:

1. A symbol, which is interpreted as a package to be installed, or

2. A list of the form (PACKAGE KEYS...), where PACKAGE is the
    name of the package to be installed or loaded, and KEYS are
    any number of keyword-value-pairs.

    The following keys are accepted:

    - :excluded (t or nil): Prevent the package from being loaded
      if value is non-nil

    - :location: Specify a custom installation location.
      The following values are legal:

      - The symbol `elpa' (default) means PACKAGE will be
        installed using the Emacs package manager.

      - The symbol `local' directs Spacemacs to load the file at
        `./local/PACKAGE/PACKAGE.el'

      - A list beginning with the symbol `recipe' is a melpa
        recipe.  See: https://github.com/milkypostman/melpa#recipe-format")

(defun maxima/init-maxima ()
  (use-package maxima
    :mode ("\\.mac\\'" . maxima-mode)
    :interpreter ("maxima" . maxima-mode)
    :init
    (with-eval-after-load 'org
      (setq org-format-latex-options     (plist-put org-format-latex-options :scale 2.0)
	          maxima-display-maxima-buffer nil))
    (with-eval-after-load 'ob
      (add-to-list 'org-babel-load-languages '(maxima . t)))
    :config
    (evil-define-key 'insert maxima-mode-map
      (kbd "TAB") 'maxima-complete)

    (evil-define-key 'insert maxima-inferior-mode-map
      (kbd "TAB") 'maxima-complete)

    (dolist (mode '(maxima-mode
                   maxima-inferior-mode))
      (spacemacs/declare-prefix-for-mode mode "mh" "help")
      (spacemacs/set-leader-keys-for-major-mode mode
        "hd" 'maxima-help
        "ha" 'maxima-apropos
        "hp" 'maxima-help-at-point)
      (spacemacs/declare-prefix-for-mode mode "ms" "repl")
      (spacemacs/set-leader-keys-for-major-mode mode
        "si" 'maxima
        "sb" 'maxima-send-buffer
        "sr" 'maxima-send-region))))

;; (defun maxima/pre-init-ob-maxima ()
;;   (spacemacs|use-package-add-hook org
;;     :post-config
;;     (use-package ob-maxima
;;       :init (add-to-list 'org-babel-load-languages '(maxima . t)))))
;; (defun maxima/init-ob-maxima ())

(defun maxima/init-company-maxima ()
  (use-package company-maxima
    :after maxima
    :init
    (add-hook 'maxima-mode-hook #'maxima-hook-function)
    (add-hook 'maxima-inferior-mode-hook #'maxima-hook-function)))
