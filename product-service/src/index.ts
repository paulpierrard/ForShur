import express from "express";
import productsRouter from "./routes/products";

const app = express();
app.use(express.json());

app.use("/products", productsRouter);

app.listen(3000, () => console.log("Product service running on 3000"));
