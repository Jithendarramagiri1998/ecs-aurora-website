FROM nginx:latest

# Remove default Nginx html files
RUN rm -rf /usr/share/nginx/html/*

# Copy your app files
COPY ./app /usr/share/nginx/html/

# Expose port 80
EXPOSE 80

# Start nginx
CMD ["nginx", "-g", "daemon off;"]
