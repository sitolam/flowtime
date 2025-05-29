# Use Nginx to serve Flutter web app
FROM nginx:alpine

# Remove default nginx website
#RUN rm -rf /usr/share/nginx/html/*

# Copy built Flutter web app to Nginx html directory
COPY build/web /usr/share/nginx/html

# Copy custom nginx config (optional)
# COPY nginx.conf /etc/nginx/conf.d/default.conf

