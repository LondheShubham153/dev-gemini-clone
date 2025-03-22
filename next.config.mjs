/** @type {import('next').NextConfig} */
const nextConfig = {
  images: {
    remotePatterns: [
      {
        protocol: "https",
        hostname: "lh3.googleusercontent.com",
        pathname: '/**',  // Wildcard for all paths under this hostname
      },
    ],
    unoptimized: true,  // Disables image optimization for this pattern
  },
};

export default nextConfig;