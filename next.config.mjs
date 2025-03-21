/** @type {import('next').NextConfig} */
const nextConfig = {
  experimental: {
    metadataBase: new URL("http://34.247.167.192:3000"), // Replace with your actual domain/IP
  },
  images: {
    remotePatterns: [
      {
        protocol: "https",
        hostname: "lh3.googleusercontent.com",
        port: "",
      },
    ],
  },
};

export default nextConfig;
