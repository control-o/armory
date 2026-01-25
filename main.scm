(import (owl io)
        (owl args)
        (owl vector)
        (owl alist)
        (owl json)
        (owl ff)
        (owl lazy))

(define url "https://pub.colonq.computer/~nichepenguin/cgi-bin/armory?name=")

(define (pp-sword sword)
  (let ((sw/type      (alget sword "sword_type" #f))
        (sw/name      (alget sword "name" #f))
        (sw/real-name (alget sword "real_name" #f))
        (sw/id        (alget sword "id" #f))
        (sw/owner     (alget sword "owner" #f))
        (sw/quality   (alget sword "quality" #f))
        (sw/handle    (alget sword "handle" #f))
        (sw/material  (alget sword "material" #f)))

    (print
      "("  sw/quality sw/material " " sw/type
      (if (not (eq? sw/handle 'null))
        (string-append " with "  sw/handle " handle") "")
      sw/quality ")")
))


(define (qarmory json query)
  (print "type " (type query))
  (vector-map (lambda (x)
                (pipe
                  x
                  (alget query #f)
                  print))
                json))

(define (get-armory user? query?)
  (lets ((r w (popen (string-append "curl -s " url user?))) ; dont be evil
         (stream (port->byte-stream (fd->port r)))
         (json (parse-json stream)))
         (if query?
           (begin
             (print user? "'s " query? "s") (qarmory json query?))
           (begin
             (print user? "'s armory")
             (vector-map (lambda (sw) (pp-sword sw)) json)))
        0))

(define rules
  (cl-rules
   `((help    "-h" "--help")
     (user    "-u" "--user"  has-arg comment "user to fetch" default "ctrl_o")
     (query   "-q" "--query" has-arg comment "field to query")
     (listing "-l" "--list"          comment "list fields to query (unimplemented)")
     )))

(define (help args)
  (print "usage: " (car args) " [args]")
  (print-rules rules))

(λ (args)
   (process-arguments
     (cdr args) rules "limes cry D:"
     (λ (opt extra)
        (print "opt: " (ff->list opt))
        (let ((user?    (get opt 'user #f))
              (query?   (get opt 'query #f))
              (listing? (get opt 'listing #f))
              (help?    (get opt 'help #f)))
          (cond
            (help?    (help args))
            (listing? (print "unimplemented"))
            (else     (get-armory user? query?)))
          ))))
