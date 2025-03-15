function handler(event) {
    var request = event.request;
    var headers = request.headers;

    // Add custom headers
    headers['x-page-view-time'] = { value: Date.now().toString() };
    headers['cache-control'] = { value: 'public, max-age=31536000' };

    // You can add more logic here for page optimization
    // For example: URL rewriting, request modification, etc.
    
    // Example: Add custom header based on device type
    var userAgent = headers['user-agent'].value || '';
    var isMobile = /Mobile|Android|iPhone/i.test(userAgent);
    headers['x-device-type'] = { value: isMobile ? 'mobile' : 'desktop' };

    return request;
} 