import NextAuth from "next-auth";
import GoogleProvider from "next-auth/providers/google";
import connectDB from "./utils/db";
import User from "./app/models/user.model";

export const { handlers, signIn, signOut, auth } = NextAuth({
  providers: [
    GoogleProvider({
      clientId: process.env.GOOGLE_ID as string,
      clientSecret: process.env.GOOGLE_SECRET as string,
    }),
  ],
  callbacks: {
    async session({ session }) {
      try {
        await connectDB();
        const sessionUser = await User.findOne({ email: session?.user?.email });
        if (session.user) {
          session.user.id = sessionUser?._id.toString();
        }
        return session;
      } catch (error) {
        console.error(error);
        return session;
      }
    },
    async signIn({ profile }) {
      try {
        const email = profile?.email;
        if (!email) return false;
        await connectDB();
        let user = await User.findOne({ email: email });
        if (!user) {
          user = await User.create({
            email: profile?.email,
            username: profile?.given_name?.replace(" ", "").toLowerCase(),
            image: profile?.picture,
          });
        }
        return true;
      } catch (error) {
        console.error(error);
        return false;
      }
    },
  },
  pages: {
    signIn: "/",
    error: "/",
  },
  secret: process.env.NEXTAUTH_SECRET,
  trustHost: true, // ✅ Fix for the "UntrustedHost" error
});
