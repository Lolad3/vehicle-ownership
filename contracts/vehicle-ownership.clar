;; Vehicle Ownership Registry
;; A contract for registering and transferring vehicle ownership on the blockchain

(define-data-var admin principal tx-sender)

;; Data maps
(define-map vehicles
  { vehicle-id: (string-utf8 17) }  ;; VIN number
  {
    owner: principal,
    make: (string-utf8 50),
    model: (string-utf8 50),
    year: uint,
    registered-at: uint,
    status: (string-utf8 20)
  }
)

(define-map vehicle-history
  { vehicle-id: (string-utf8 17), tx-id: uint }
  {
    previous-owner: principal,
    new-owner: principal,
    timestamp: uint
  }
)

;; Error codes
(define-constant ERR-NOT-AUTHORIZED (err u100))
(define-constant ERR-VEHICLE-EXISTS (err u101))
(define-constant ERR-VEHICLE-NOT-FOUND (err u102))
(define-constant ERR-NOT-OWNER (err u103))

;; Admin functions
(define-public (set-admin (new-admin principal))
  (begin
    (asserts! (is-eq tx-sender (var-get admin)) ERR-NOT-AUTHORIZED)
    (ok (var-set admin new-admin))
  )
)

;; Vehicle registration
(define-public (register-vehicle 
    (vehicle-id (string-utf8 17))
    (make (string-utf8 50))
    (model (string-utf8 50))
    (year uint)
  )
  (let ((current-time (get-block-height)))
    (asserts! (is-none (map-get? vehicles { vehicle-id: vehicle-id })) ERR-VEHICLE-EXISTS)
    
    (map-set vehicles
      { vehicle-id: vehicle-id }
      {
        owner: tx-sender,
        make: make,
        model: model,
        year: year,
        registered-at: current-time,
        status: "active"
      }
    )
    
    (ok true)
  )
)

;; Transfer ownership
(define-public (transfer-ownership
    (vehicle-id (string-utf8 17))
    (new-owner principal)
  )
  (let (
    (vehicle (unwrap! (map-get? vehicles { vehicle-id: vehicle-id }) ERR-VEHICLE-NOT-FOUND))
    (current-time (get-block-height))
    (tx-id (+ (default-to u0 (get-last-tx-id)) u1))
  )
    (asserts! (is-eq (get owner vehicle) tx-sender) ERR-NOT-OWNER)
    
    ;; Update vehicle ownership
    (map-set vehicles
      { vehicle-id: vehicle-id }
      (merge vehicle { owner: new-owner })
    )
    
    ;; Record in history
    (map-set vehicle-history
      { vehicle-id: vehicle-id, tx-id: tx-id }
      {
        previous-owner: tx-sender,
        new-owner: new-owner,
        timestamp: current-time
      }
    )
    
    (ok true)
  )
)

;; Read-only functions
(define-read-only (get-vehicle-info (vehicle-id (string-utf8 17)))
  (map-get? vehicles { vehicle-id: vehicle-id })
)

(define-read-only (get-vehicle-owner (vehicle-id (string-utf8 17)))
  (get owner (default-to 
    { 
      owner: tx-sender, 
      make: "", 
      model: "", 
      year: u0, 
      registered-at: u0, 
      status: "" 
    } 
    (map-get? vehicles { vehicle-id: vehicle-id })
  ))
)

;; Helper functions
(define-read-only (get-last-tx-id)
  (map-get? last-tx-id "id")
)

(define-map last-tx-id (string-ascii 2) uint)

(define-private (set-last-tx-id (id uint))
  (map-set last-tx-id "id" id)
)