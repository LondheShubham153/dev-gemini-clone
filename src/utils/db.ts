import mongoose, { ConnectOptions } from "mongoose";

let isConnected = false;

const connectDB = async (): Promise<void> => {
  mongoose.set("strictQuery", true);

  if (isConnected) {
    console.info("MongoDB is already connected");
    return;
  }

  try {
    await mongoose.connect(process.env.MONGODB_URI as string, {
      dbName: "devgemini",
      useNewUrlParser: true,
      useUnifiedTopology: true,
    } as ConnectOptions);

    isConnected = true;
    console.info("MongoDB is now connected");
  } catch (error) {
    console.error("Failed to connect to MongoDB", error);
    throw new Error("MongoDB connection failed");
  }
};

export default connectDB;
