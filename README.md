# Skilled Nursing Facility Reimbursement

A blockchain-based healthcare billing platform for calculating Medicare reimbursements based on patient acuity, therapy minutes, and diagnosis codes.

## Overview

This smart contract system provides a comprehensive solution for managing skilled nursing facility (SNF) Medicare reimbursements under the Prospective Payment System (PPS). The platform automates RUG-IV (Resource Utilization Groups) classification, tracks therapy service delivery, calculates per diem rates, and ensures compliance with CMS billing regulations.

The system enables SNFs to accurately document patient assessments, therapy minutes, and clinical conditions to maximize appropriate reimbursement while maintaining regulatory compliance. By leveraging blockchain technology, the platform provides transparent, immutable records of assessments, therapy documentation, and billing calculations for audit purposes and revenue cycle management.

## Key Features

### Patient Assessment
- MDS (Minimum Data Set) documentation
- RUG-IV classification
- ADL (Activities of Daily Living) scoring
- Clinical diagnoses tracking
- Comorbidity documentation

### Therapy Documentation
- Physical therapy minutes tracking
- Occupational therapy documentation
- Speech-language pathology services
- Group vs individual therapy classification
- Concurrent therapy tracking

### Reimbursement Calculation
- Per diem rate determination
- RUG category-based rates
- Therapy threshold compliance
- Urban/rural adjustment factors
- Case-mix index calculations

### Revenue Management
- Daily billing records
- Claim submission tracking
- Payment posting
- Denial management
- Revenue cycle optimization

### Compliance Monitoring
- Medicare Part A requirements
- Therapy minute thresholds
- Documentation standards
- Audit trail maintenance
- Regulatory reporting

## System Components

### Core Functionality
1. **Patient Registration**: Onboard patients with Medicare information and admission details
2. **MDS Assessment**: Document Minimum Data Set assessments for RUG classification
3. **Therapy Tracking**: Record therapy minutes across disciplines (PT, OT, SLP)
4. **RUG Classification**: Automated RUG-IV category determination
5. **Rate Calculation**: Per diem reimbursement rate computation
6. **Claims Management**: Submit and track Medicare claims
7. **Revenue Optimization**: Maximize appropriate reimbursement

### Data Structures
- Patient profiles with Medicare eligibility
- MDS assessment records with ADL scores
- Therapy service documentation by discipline
- RUG classification results
- Daily billing records with per diem rates
- Claim submission and payment tracking

## Use Cases

### Skilled Nursing Facilities
- Automate RUG classification for accurate billing
- Track therapy minutes to meet RUG thresholds
- Calculate optimal per diem rates
- Maintain audit-ready documentation
- Maximize revenue while ensuring compliance
- Monitor case-mix index across facility

### Therapy Departments
- Document therapy services efficiently
- Track individual, group, and concurrent therapy
- Ensure adequate minutes for RUG categories
- Coordinate multi-disciplinary services
- Support clinical and billing documentation

### Billing Departments
- Generate accurate claims based on RUG classifications
- Track claim submission and payment status
- Identify and resolve billing denials
- Optimize revenue cycle processes
- Maintain compliance with Medicare requirements

### Quality Assurance
- Verify assessment accuracy
- Monitor therapy threshold compliance
- Track documentation completeness
- Support regulatory audits
- Identify improvement opportunities

## Smart Contract: nursing-reimbursement-calculator

### Features
- Register patients with Medicare Part A eligibility
- Document MDS assessments with ADL scoring
- Track therapy service delivery across disciplines
- Calculate RUG-IV classifications automatically
- Determine per diem reimbursement rates
- Submit and track Medicare claims
- Monitor compliance with therapy thresholds
- Maximize facility revenue through accurate classification

## Technical Architecture

### Blockchain Benefits
- **Immutability**: Assessment and therapy records cannot be altered retroactively
- **Transparency**: Complete audit trail for CMS reviews
- **Accuracy**: Automated calculations reduce billing errors
- **Compliance**: Built-in threshold and documentation checks
- **Efficiency**: Streamlined billing and claims processes

### RUG-IV Classification
Supports all RUG-IV categories including:
- Rehabilitation Plus Extensive Services
- Rehabilitation (Ultra High, Very High, High, Medium, Low)
- Extensive Services
- Special Care (High, Low)
- Clinically Complex
- Behavioral Symptoms and Cognitive Performance
- Reduced Physical Function

### Therapy Thresholds
- Ultra High: 720+ minutes/week
- Very High: 500-719 minutes/week
- High: 325-499 minutes/week
- Medium: 150-324 minutes/week
- Low: 45-149 minutes/week

## Getting Started

```bash
git clone <repository-url>
cd Skilled-nursing-facility-reimbursement
npm install
clarinet check
clarinet test
```

## Security

- HIPAA-compliant data handling
- Provider authentication
- Immutable billing records
- Audit trail enforcement
- Payment verification

## Compliance

- Medicare Part A SNF PPS
- RUG-IV classification system
- MDS 3.0 assessment requirements
- Therapy service documentation standards
- CMS billing regulations

## License

MIT License
