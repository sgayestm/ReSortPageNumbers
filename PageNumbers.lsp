;;;--------------=={ SheetNumber.lsp - Sheet number indexer }==----------;;
;;;                                                                      ;;
;;;  This program allows the user to update the sheet number in          ;;
;;;  projects where use of %s is not allowed, this is done by getting    ;;
;;;  the number of sheets from the wdp file then checking the current    ;;
;;;  page title compared with the wdp file position then updating the    ;;
;;;  standard block used for the title block that is placed at 0,0,0     ;;
;;;                                                                      ;;
;;;----------------------------------------------------------------------;;
;;;  Author:  Matthew Ayestaran                                          ;;
;;;----------------------------------------------------------------------;;
;;;  Version 1.0    -    2024-07-21                                      ;;
;;;                                                                      ;;
;;;  - First release.                                                    ;;
;;;----------------------------------------------------------------------;;

(defun AddZero (Number)
  (if (< Number 10)
    (strcat "0" (itoa Number))  ; Convert Number to string if it's less than 10
    (itoa Number)               ; Convert Number to string if it's 10 or more
  )
)

(defun c:PageNumbers (/ aline file Control current dwg BOMpage BOMCurrent ConnectionsPage ConnectionsCurrent LayoutPage LayoutCurrent InterconnectPage InterconnectCurrent)
  (setq Control 0)
  (setq BOMpage 0)
  (setq ConnectionsPage 0)
  (setq LayoutPage 0)
  (setq InterconnectPage 0)  
  
  (setq dwg (getvar "dwgname"))

  ;(close file)
  ; Code to read the wdp and extract the control pages numbers
  (setq file (open (ace_getactiveproject) "r"))
  
  (while (setq aline (read-line file))
    ; Check if it is a dwg title
    (if (wcmatch aline "##*")  
      (if (wcmatch (strcase aline) "*CONTROL*")
        ; Check for control drawing
        (progn
          (setq Control (+ 1 Control))
          (princ (strcat "Checking: " aline "\n"))
          (if (wcmatch (strcase aline) (strcase dwg))
            ; Check for current page in count
            (progn
              (setq current Control)
              (princ (strcat "current page: " aline "\n"))
            ) ; progn
          ) ; if
        ) ; progn
      ) ; if
    ) ; if
    
    (if (wcmatch aline "##*")  
      (if (wcmatch (strcase aline) "*BOM*")
        ; Check for BOM drawing
        (progn
          (setq BOMpage (+ 1 BOMpage))
          (princ (strcat "Checking: " aline "\n"))
          (if (wcmatch (strcase aline) (strcase dwg))
            ; Check for current page in count
            (progn
              (setq BOMCurrent BOMpage)
              (princ (strcat "current page: " aline "\n"))
            ) ; progn
          ) ; if
        ) ; progn
      ) ; if
    ) ; if
    
    (if (wcmatch aline "##*")  
      (if (wcmatch (strcase aline) "*LAYOUT*")
        ; Check for layout drawing
        (progn
          (setq LayoutPage (+ 1 LayoutPage))
          (princ (strcat "Checking: " aline "\n"))
          (if (wcmatch (strcase aline) (strcase dwg))
            ; Check for current page in count
            (progn
              (setq LayoutCurrent LayoutPage)
              (princ (strcat "current page: " aline "\n"))
            ) ; progn
          ) ; if
        ) ; progn
      ) ; if
    ) ; if

    (if (wcmatch aline "##*")  
      (if (wcmatch (strcase aline) "*CONNECTION*")
        ; Check for connection drawing
        (progn
          (setq ConnectionsPage (+ 1 ConnectionsPage))
          (princ (strcat "Checking: " aline "\n"))
          (if (wcmatch (strcase aline) (strcase dwg))
            ; Check for current page in count
            (progn
              (setq ConnectionsCurrent ConnectionsPage)
              (princ (strcat "current page: " aline "\n"))
            ) ; progn
          ) ; if
        ) ; progn
      ) ; if
    ) ; if

    (if (wcmatch aline "##*")  
      (if (wcmatch (strcase aline) "*INTERCONNECT*")
        ; Check for interconnect drawing
        (progn
          (setq InterconnectPage (+ 1 InterconnectPage))
          (princ (strcat "Checking: " aline "\n"))
          (if (wcmatch (strcase aline) (strcase dwg))
            ; Check for current page in count
            (progn
              (setq InterconnectCurrent InterconnectPage)
              (princ (strcat "current page: " aline "\n"))
            ) ; progn
          ) ; if
        ) ; progn
      ) ; if
    ) ; if
  ) ; while

  (princ) 

  (close file) 

  ; Presuming the title block is at 0 0 0 then you can update it with the below code to show the correct sheet number should only be called if it is meant to be used
  (if (> current 0)
    (setpropertyvalue (ssname (ssget "_x" '((0 . "insert") (10 0.0000 0.0000 0.0000))) 0) "SHEET" (strcat "SHEET " (AddZero current) " OF " (AddZero Control)))
    (princ "No Change")
  ) ; if

  (if (> BOMCurrent 0)
    (setpropertyvalue (ssname (ssget "_x" '((0 . "insert") (10 0.0000 0.0000 0.0000))) 0) "SHEET" (strcat "BOM SHEET " (AddZero BOMCurrent) " OF " (AddZero BOMpage)))
    (princ "No Change")
  ) ; if

  (if (> ConnectionsCurrent 0)
    (setpropertyvalue (ssname (ssget "_x" '((0 . "insert") (10 0.0000 0.0000 0.0000))) 0) "SHEET" (strcat "CONNECTIONS " (AddZero ConnectionsCurrent) " OF " (AddZero ConnectionsPage)))
    (princ "No Change")
  ) ; if

  (if (> LayoutCurrent 0)
    (setpropertyvalue (ssname (ssget "_x" '((0 . "insert") (10 0.0000 0.0000 0.0000))) 0) "SHEET" (strcat "PANEL LAYOUT " (AddZero LayoutCurrent) " OF " (AddZero LayoutPage)))
    (princ "No Change")
  ) ; if

  (if (> InterconnectCurrent 0)
    (setpropertyvalue (ssname (ssget "_x" '((0 . "insert") (10 0.0000 0.0000 0.0000))) 0) "SHEET" (strcat "INTERCONNECT " (AddZero InterconnectCurrent) " OF " (AddZero InterconnectPage)))
    (princ "No Change")
  ) ; if
) ; end
