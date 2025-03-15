# Backend Functions

This directory contains AWS Lambda and CloudFront functions used in the project.

## Structure

```
backend/
├── functions/
│   ├── hello-world/          # Basic Hello World API (Lambda)
│   │   ├── src/
│   │   │   └── lambda_function.py
│   │   └── requirements.txt
│   │
│   └── cloudfront-viewer/    # CloudFront Function
│       └── src/
│           └── function.js
```

## Functions

### hello-world (Lambda)
A basic API endpoint that returns a Hello World message.

### cloudfront-viewer (CloudFront Function)
A CloudFront Function that runs at the viewer request event. It handles:
- Page optimization
- Cache control headers
- Device type detection
- Custom headers injection
- Request modification before reaching the origin

CloudFront Functions are lightweight JavaScript functions that run at the edge locations. They are:
- More cost-effective than Lambda@Edge
- Have faster execution times (sub-millisecond latency)
- Perfect for simple request/response manipulations
- Limited to viewer request/response events

## Deployment
Functions can be deployed independently using Terraform configurations in the `infra/` directory. 