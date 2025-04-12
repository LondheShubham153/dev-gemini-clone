# Advanced Gemini Clone

![Gemini Clone Logo](public/assets/readme-banner.png)

An advanced Gemini clone built with Next.js, featuring enhanced functionality and faster response times.

---

## Purpose

When you need to test your Docker image to ensure it is functioning correctly and the application is running properly with domain mapping, use this guide. After verifying the application's functionality with your domain, refer to the **DevOps** and **kind branch** sections for detailed DevSecOps implementation specific to this project.

---

## Prerequisites

1. A built Docker image.
2. A running Docker container using that image.
3. A configured `.env.local` file used to build the image and run the container.

---

**Important**: Replace <YOUR_DOMAIN_NAME> with your actual domain name throughout this guide.

---

## SSL Setup for Gemini Application via Nginx

### **Step 1: Install Nginx**

Update your package lists and install **Nginx**:

```bash
sudo apt update
sudo apt install nginx -y
```

Verify Nginx is running:

```bash
sudo systemctl status nginx
```

If Nginx is inactive, start it:

```bash
sudo systemctl start nginx
```

Enable Nginx to launch on system boot:

```bash
sudo systemctl enable nginx
```

---

### **Step 2: Install Certbot and Generate SSL Certificate**

Install **Certbot** along with the Nginx plugin:

```bash
sudo apt install certbot python3-certbot-nginx -y
```

Generate your SSL certificate:

```bash
sudo certbot --nginx -d <YOUR_DOMAIN_NAME>
```

During the process, you will be prompted to:

- Enter your email address.
- Accept the terms of service.
- Choose option **2: Redirect HTTP to HTTPS**.

Upon completion, you should see confirmation similar to:

**Congratulations! Your certificate has been saved at** `/etc/letsencrypt/live/<YOUR_DOMAIN_NAME>/`

---

### **Step 3: Configure Nginx for Your Application**

Create a new Nginx configuration file to proxy requests to your application running on **port 3000**:

```bash
sudo vim /etc/nginx/conf.d/gemini.conf
```

Insert the following configuration:

```jsx
server {
    listen 80;
    server_name <YOUR_DOMAIN_NAME>;

    location / {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }
}
server {
    listen 443 ssl;
    server_name <YOUR_DOMAIN_NAME>;

    ssl_certificate /etc/letsencrypt/live/<YOUR_DOMAIN_NAME>/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/<YOUR_DOMAIN_NAME>/privkey.pem;

    location / {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }
}
```

Save and exit the editor (`ESC` then `:wq` followed by `ENTER`).

---

### **Step 4: Test and Restart Nginx**

Validate the configuration for syntax errors:

```bash
sudo nginx -t
```

If the test is successful, restart Nginx:

```bash
sudo systemctl restart nginx
```

---

### **Step 5: Verify HTTPS Setup**

Confirm that your domain is serving the SSL certificate correctly by visiting:

🔗 [**https://<YOUR_DOMAIN_NAME>**](https://<YOUR_DOMAIN_NAME>)

Alternatively, verify the SSL certificate details using:

```bash
sudo certbot certificates
```

---

### **Step 6: Confirm Domain Resolution and Application Accessibility**

#### **Check Domain Resolution**

Ensure your domain points to your server's public IP:

```bash
nslookup <YOUR_DOMAIN_NAME>
```

or

```bash
dig <YOUR_DOMAIN_NAME> +short
```

#### **Check Application Accessibility**

Test the application with:

```bash
curl -IL https://<YOUR_DOMAIN_NAME>
```

Expected output:

- `HTTP/2 200 OK` if the application is accessible.
- `Location: https://<YOUR_DOMAIN_NAME>` for proper redirection.

---

### **Step 7: Verify in a Browser**

Open your web browser and navigate to:

🔗 [**https://<YOUR_DOMAIN_NAME>**](https://gemini.letsdeployit.com/)

If the configuration is correct, your application will be live and accessible.

---

### **Final Confirmation**

- **Nginx** is installed and operating.
- **SSL** is configured and enforced.
- Your application is successfully proxied by **Nginx** on port 3000.
- Your domain is secured with **HTTPS** and properly resolving.
- Your application is live and accessible.

---