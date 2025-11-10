;; Skilled Nursing Facility Reimbursement Calculator
;; Calculate reimbursement rates, track therapy minutes, document patient acuity, submit claims, and maximize facility revenue

;; Constants
(define-constant contract-owner tx-sender)
(define-constant err-owner-only (err u100))
(define-constant err-not-found (err u101))
(define-constant err-unauthorized (err u103))
(define-constant err-invalid-rug (err u104))
(define-constant err-claim-exists (err u105))

;; Data Variables
(define-data-var patient-id-nonce uint u0)
(define-data-var assessment-id-nonce uint u0)
(define-data-var therapy-id-nonce uint u0)
(define-data-var claim-id-nonce uint u0)

;; RUG-IV Categories (simplified)
(define-constant rug-ultra-high u7)
(define-constant rug-very-high u6)
(define-constant rug-high u5)
(define-constant rug-medium u4)
(define-constant rug-low u3)
(define-constant rug-clinically-complex u2)
(define-constant rug-behavior u1)

;; Therapy Types
(define-constant therapy-pt u1) ;; Physical Therapy
(define-constant therapy-ot u2) ;; Occupational Therapy
(define-constant therapy-slp u3) ;; Speech-Language Pathology

;; Claim Status
(define-constant claim-pending u0)
(define-constant claim-submitted u1)
(define-constant claim-approved u2)
(define-constant claim-denied u3)
(define-constant claim-paid u4)

;; Data Maps

;; Patient Registry
(define-map patients
    { patient-id: uint }
    {
        medicare-number: (string-ascii 50),
        name: (string-ascii 100),
        admission-date: uint,
        discharge-date: uint,
        current-rug-category: uint,
        total-reimbursement: uint,
        active: bool
    }
)

;; MDS Assessments
(define-map assessments
    { assessment-id: uint }
    {
        patient-id: uint,
        assessment-date: uint,
        rug-category: uint,
        adl-score: uint,
        clinical-diagnoses: (string-ascii 300),
        comorbidities: (string-ascii 300),
        case-mix-index: uint,
        per-diem-rate: uint,
        assessed-by: principal
    }
)

;; Therapy Services
(define-map therapy-services
    { therapy-id: uint }
    {
        patient-id: uint,
        therapy-type: uint,
        service-date: uint,
        minutes-delivered: uint,
        individual-therapy: bool,
        group-therapy: bool,
        concurrent-therapy: bool,
        therapist: principal,
        notes: (string-ascii 200)
    }
)

;; Weekly Therapy Totals
(define-map weekly-therapy
    { patient-id: uint, week-start: uint }
    {
        pt-minutes: uint,
        ot-minutes: uint,
        slp-minutes: uint,
        total-minutes: uint,
        meets-threshold: bool
    }
)

;; Reimbursement Claims
(define-map claims
    { claim-id: uint }
    {
        patient-id: uint,
        billing-period-start: uint,
        billing-period-end: uint,
        days-covered: uint,
        rug-category: uint,
        per-diem-rate: uint,
        total-amount: uint,
        status: uint,
        submitted-date: uint,
        paid-date: uint,
        denial-reason: (string-ascii 200)
    }
)

;; Daily Billing Records
(define-map daily-billing
    { patient-id: uint, service-date: uint }
    {
        rug-category: uint,
        per-diem-rate: uint,
        therapy-minutes: uint,
        billed: bool,
        claim-id: uint
    }
)

;; Read-only functions

;; Get patient information
(define-read-only (get-patient (patient-id uint))
    (ok (map-get? patients { patient-id: patient-id }))
)

;; Get assessment
(define-read-only (get-assessment (assessment-id uint))
    (ok (map-get? assessments { assessment-id: assessment-id }))
)

;; Get therapy service
(define-read-only (get-therapy-service (therapy-id uint))
    (ok (map-get? therapy-services { therapy-id: therapy-id }))
)

;; Get weekly therapy totals
(define-read-only (get-weekly-therapy (patient-id uint) (week-start uint))
    (ok (map-get? weekly-therapy { patient-id: patient-id, week-start: week-start }))
)

;; Get claim
(define-read-only (get-claim (claim-id uint))
    (ok (map-get? claims { claim-id: claim-id }))
)

;; Get daily billing
(define-read-only (get-daily-billing (patient-id uint) (service-date uint))
    (ok (map-get? daily-billing { patient-id: patient-id, service-date: service-date }))
)

;; Calculate expected reimbursement
(define-read-only (calculate-reimbursement (per-diem-rate uint) (days uint))
    (ok (* per-diem-rate days))
)

;; Public functions

;; Register patient
(define-public (register-patient
    (medicare-number (string-ascii 50))
    (name (string-ascii 100))
    (admission-date uint))
    (let
        (
            (new-patient-id (+ (var-get patient-id-nonce) u1))
        )
        (asserts! (is-eq tx-sender contract-owner) err-owner-only)
        (map-set patients
            { patient-id: new-patient-id }
            {
                medicare-number: medicare-number,
                name: name,
                admission-date: admission-date,
                discharge-date: u0,
                current-rug-category: u0,
                total-reimbursement: u0,
                active: true
            }
        )
        (var-set patient-id-nonce new-patient-id)
        (ok new-patient-id)
    )
)

;; Complete MDS assessment
(define-public (complete-assessment
    (patient-id uint)
    (rug-category uint)
    (adl-score uint)
    (clinical-diagnoses (string-ascii 300))
    (comorbidities (string-ascii 300))
    (case-mix-index uint)
    (per-diem-rate uint))
    (let
        (
            (new-assessment-id (+ (var-get assessment-id-nonce) u1))
            (patient-data (unwrap! (map-get? patients { patient-id: patient-id }) err-not-found))
        )
        (asserts! (is-eq tx-sender contract-owner) err-owner-only)
        (asserts! (<= rug-category rug-ultra-high) err-invalid-rug)
        
        ;; Create assessment
        (map-set assessments
            { assessment-id: new-assessment-id }
            {
                patient-id: patient-id,
                assessment-date: block-height,
                rug-category: rug-category,
                adl-score: adl-score,
                clinical-diagnoses: clinical-diagnoses,
                comorbidities: comorbidities,
                case-mix-index: case-mix-index,
                per-diem-rate: per-diem-rate,
                assessed-by: tx-sender
            }
        )
        
        ;; Update patient RUG category
        (map-set patients
            { patient-id: patient-id }
            (merge patient-data { current-rug-category: rug-category })
        )
        
        (var-set assessment-id-nonce new-assessment-id)
        (ok new-assessment-id)
    )
)

;; Document therapy service
(define-public (document-therapy
    (patient-id uint)
    (therapy-type uint)
    (minutes-delivered uint)
    (individual-therapy bool)
    (group-therapy bool)
    (concurrent-therapy bool)
    (notes (string-ascii 200)))
    (let
        (
            (new-therapy-id (+ (var-get therapy-id-nonce) u1))
        )
        (asserts! (is-eq tx-sender contract-owner) err-owner-only)
        (asserts! (is-some (map-get? patients { patient-id: patient-id })) err-not-found)
        
        (map-set therapy-services
            { therapy-id: new-therapy-id }
            {
                patient-id: patient-id,
                therapy-type: therapy-type,
                service-date: block-height,
                minutes-delivered: minutes-delivered,
                individual-therapy: individual-therapy,
                group-therapy: group-therapy,
                concurrent-therapy: concurrent-therapy,
                therapist: tx-sender,
                notes: notes
            }
        )
        
        (var-set therapy-id-nonce new-therapy-id)
        (ok new-therapy-id)
    )
)

;; Update weekly therapy totals
(define-public (update-weekly-totals
    (patient-id uint)
    (week-start uint)
    (pt-minutes uint)
    (ot-minutes uint)
    (slp-minutes uint))
    (let
        (
            (total-minutes (+ (+ pt-minutes ot-minutes) slp-minutes))
            (meets-threshold (>= total-minutes u150))
        )
        (asserts! (is-eq tx-sender contract-owner) err-owner-only)
        (ok (map-set weekly-therapy
            { patient-id: patient-id, week-start: week-start }
            {
                pt-minutes: pt-minutes,
                ot-minutes: ot-minutes,
                slp-minutes: slp-minutes,
                total-minutes: total-minutes,
                meets-threshold: meets-threshold
            }
        ))
    )
)

;; Record daily billing
(define-public (record-daily-billing
    (patient-id uint)
    (service-date uint)
    (rug-category uint)
    (per-diem-rate uint)
    (therapy-minutes uint))
    (begin
        (asserts! (is-eq tx-sender contract-owner) err-owner-only)
        (ok (map-set daily-billing
            { patient-id: patient-id, service-date: service-date }
            {
                rug-category: rug-category,
                per-diem-rate: per-diem-rate,
                therapy-minutes: therapy-minutes,
                billed: false,
                claim-id: u0
            }
        ))
    )
)

;; Submit reimbursement claim
(define-public (submit-claim
    (patient-id uint)
    (billing-period-start uint)
    (billing-period-end uint)
    (days-covered uint)
    (rug-category uint)
    (per-diem-rate uint))
    (let
        (
            (new-claim-id (+ (var-get claim-id-nonce) u1))
            (total-amount (* per-diem-rate days-covered))
            (patient-data (unwrap! (map-get? patients { patient-id: patient-id }) err-not-found))
        )
        (asserts! (is-eq tx-sender contract-owner) err-owner-only)
        
        (map-set claims
            { claim-id: new-claim-id }
            {
                patient-id: patient-id,
                billing-period-start: billing-period-start,
                billing-period-end: billing-period-end,
                days-covered: days-covered,
                rug-category: rug-category,
                per-diem-rate: per-diem-rate,
                total-amount: total-amount,
                status: claim-submitted,
                submitted-date: block-height,
                paid-date: u0,
                denial-reason: ""
            }
        )
        
        (var-set claim-id-nonce new-claim-id)
        (ok new-claim-id)
    )
)

;; Update claim status
(define-public (update-claim-status
    (claim-id uint)
    (new-status uint)
    (denial-reason (string-ascii 200)))
    (let
        (
            (claim-data (unwrap! (map-get? claims { claim-id: claim-id }) err-not-found))
        )
        (asserts! (is-eq tx-sender contract-owner) err-owner-only)
        (ok (map-set claims
            { claim-id: claim-id }
            (merge claim-data {
                status: new-status,
                denial-reason: denial-reason,
                paid-date: (if (is-eq new-status claim-paid) block-height u0)
            })
        ))
    )
)

;; Post payment
(define-public (post-payment (claim-id uint) (amount-paid uint))
    (let
        (
            (claim-data (unwrap! (map-get? claims { claim-id: claim-id }) err-not-found))
            (patient-data (unwrap! (map-get? patients { patient-id: (get patient-id claim-data) }) err-not-found))
        )
        (asserts! (is-eq tx-sender contract-owner) err-owner-only)
        
        ;; Update claim
        (map-set claims
            { claim-id: claim-id }
            (merge claim-data {
                status: claim-paid,
                paid-date: block-height
            })
        )
        
        ;; Update patient total reimbursement
        (map-set patients
            { patient-id: (get patient-id claim-data) }
            (merge patient-data {
                total-reimbursement: (+ (get total-reimbursement patient-data) amount-paid)
            })
        )
        
        (ok true)
    )
)

;; Discharge patient
(define-public (discharge-patient (patient-id uint) (discharge-date uint))
    (let
        (
            (patient-data (unwrap! (map-get? patients { patient-id: patient-id }) err-not-found))
        )
        (asserts! (is-eq tx-sender contract-owner) err-owner-only)
        (ok (map-set patients
            { patient-id: patient-id }
            (merge patient-data {
                discharge-date: discharge-date,
                active: false
            })
        ))
    )
)

