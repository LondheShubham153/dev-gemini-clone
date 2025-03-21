/** @type {import('next').NextConfig} */
const nextConfig = {
  experimental: {
    metadataBase: new URL("https://gemini.letsdeployit.com"), // Replace with your actual domain/IP
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
