FROM nginx:latest

# Remove default Nginx page
RUN rm -rf /usr/share/nginx/html/*

# Copy your HTML file(s) into Nginx's web root
COPY index.html /usr/share/nginx/html/

# If you have CSS/JS/images:
# COPY ./ /usr/share/nginx/html/

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
