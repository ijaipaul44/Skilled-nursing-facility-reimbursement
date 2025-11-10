## Description

Healthcare billing platform for skilled nursing facilities calculating Medicare reimbursements using RUG-IV classification, therapy documentation, and patient acuity assessment.

## Key Features

### Patient Management
- Medicare beneficiary registration
- Admission and discharge tracking
- Active status monitoring
- Total reimbursement tracking
- Current RUG category assignment

### MDS Assessment System
- RUG-IV category classification (7 levels)
- ADL (Activities of Daily Living) scoring
- Clinical diagnosis documentation
- Comorbidity tracking
- Case-mix index calculation
- Per diem rate determination

### Therapy Documentation
- Physical therapy (PT) minute tracking
- Occupational therapy (OT) services
- Speech-language pathology (SLP)
- Individual vs group therapy classification
- Concurrent therapy monitoring
- Weekly minute totals and threshold compliance (150 min)

### Reimbursement Processing
- Per diem rate calculations
- Daily billing record generation
- Claim submission with billing periods
- Payment posting and tracking
- Denial management
- Revenue cycle monitoring

### Compliance Features
- Medicare Part A SNF PPS adherence
- Therapy minute threshold monitoring
- MDS 3.0 assessment requirements
- Audit trail maintenance
- Regulatory reporting support

## Contract Functions

### Read-Only
- `get-patient`: Patient demographics and status
- `get-assessment`: MDS assessment details
- `get-therapy-service`: Therapy documentation
- `get-weekly-therapy`: Weekly minute totals
- `get-claim`: Claim status and details
- `get-daily-billing`: Daily service records
- `calculate-reimbursement`: Payment calculations

### Public
- `register-patient`: Add Medicare beneficiaries
- `complete-assessment`: Document MDS and assign RUG
- `document-therapy`: Record therapy services
- `update-weekly-totals`: Calculate weekly minutes
- `record-daily-billing`: Create daily records
- `submit-claim`: Submit reimbursement claims
- `update-claim-status`: Process approvals/denials
- `post-payment`: Record received payments
- `discharge-patient`: Close patient episodes

## RUG-IV Categories

1. Ultra High Rehab
2. Very High Rehab
3. High Rehab
4. Medium Rehab
5. Low Rehab
6. Clinically Complex
7. Behavior Problems

## Workflow

1. Register patient on admission
2. Complete MDS assessment and assign RUG
3. Document daily therapy services
4. Calculate weekly therapy totals
5. Record daily billing with per diem rates
6. Submit claims for billing periods
7. Post payments when received
8. Discharge patient and finalize billing

## Compliance

- Medicare Part A SNF Prospective Payment System
- RUG-IV classification methodology
- MDS 3.0 documentation standards
- Therapy minute threshold requirements (150/week for ultra-high)
- CMS billing and coding regulations

## Security

- HIPAA-compliant data structures
- Administrative authorization required
- Immutable billing records
- Payment verification
- Audit trail maintenance

## Testing

Validated with `clarinet check` - all syntax checks passed.

## Dependencies

- Clarinet CLI
- Stacks blockchain
- Node.js environment
