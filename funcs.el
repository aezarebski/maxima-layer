(defun spacemacs/maxima-company-hook-function ()
  (run-with-timer 2 nil #'maxima-init-inferiors)
  (run-with-timer 5 nil #'company-mode))

